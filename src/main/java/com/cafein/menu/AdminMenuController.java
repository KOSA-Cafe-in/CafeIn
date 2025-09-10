package com.cafein.menu;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpSession;
import javax.annotation.Resource;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.cafein.order.OrderDTO;
import com.cafein.order.OrderService;

@Controller
@RequestMapping("/admin") // ✅ 클래스 레벨을 /admin 으로 통합
public class AdminMenuController {

    @Resource
    private MenuService menuService;

    // ✅ 카페 소개글 서비스 & 고정 카페ID
    @Resource
    private com.cafein.cafe.CafeService cafeService;

    // ✅ 주문 서비스 (주문내역 화면/상태 변경)
    @Resource
    private OrderService orderService;

    // =========================
    // 홈 = 메뉴판 (/admin/home)
    // =========================
    @GetMapping("/home")
    public String showHome(Model model, HttpSession session) {
        // 관리자 권한 체크
        Long cafeId = (Long) session.getAttribute("cafeId");
        
        String cafeIntro = cafeService.findIntro(cafeId);
        model.addAttribute("cafeIntro", cafeIntro);

        List<MenuDTO> menuList = menuService.findAll();
        model.addAttribute("menuList", menuList);

        return "admin/home";
    }

    // =========================
    // 소개글 저장 (AJAX)
    // =========================
    @PostMapping(value = "/home/updateIntro", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> updateIntroAjax(@RequestParam("content") String content, HttpSession session) {
        Long cafeId = (Long) session.getAttribute("cafeId");
        cafeService.updateIntro(cafeId, content);
        Map<String, Object> res = new HashMap<>();
        res.put("ok", true);
        res.put("content", content);
        return res;
    }

    // =========================
    // 메뉴 등록
    // =========================
    @GetMapping("/menu/add")
    public String addForm() { return "admin/menuAdd"; }

    @PostMapping("/menu/add")
    public String addMenu(@ModelAttribute MenuDTO menuDTO,
                          @RequestParam("image") MultipartFile imageFile) throws Exception {
        menuService.createMenu(menuDTO, imageFile);
        return "redirect:/admin/home";
    }

    // =========================
    // 메뉴 수정/삭제
    // =========================
    @GetMapping("/menu/{id}/edit")
    public String editForm(@PathVariable("id") Long id, Model model) {
        MenuDTO menu = menuService.findById(id);
        model.addAttribute("menu", menu);
        return "admin/menuEdit";
    }

    @PostMapping("/menu/update")
    public String updateMenu(@ModelAttribute MenuDTO menuDTO,
                             @RequestParam(value = "image", required = false) MultipartFile imageFile) throws Exception {
        menuService.updateMenu(menuDTO, imageFile);
        return "redirect:/admin/home";
    }

    @PostMapping("/menu/delete")
    public String deleteMenuByParam(@RequestParam("id") Long id, RedirectAttributes ra) {
        try {
            menuService.deleteMenu(id);
            ra.addFlashAttribute("msg", "메뉴가 삭제되었습니다.");
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            ra.addFlashAttribute("err", "해당 메뉴와 연결된 주문 내역이 있어 삭제할 수 없습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("err", "삭제 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/home";
    }

    @PostMapping("/menu/{id}/delete")
    public String deleteMenuByPath(@PathVariable("id") Long id, RedirectAttributes ra) {
        return deleteMenuByParam(id, ra);
    }

    // =========================
    // 주문내역 화면
    // =========================
    @GetMapping("/orders")
    public String showOrders(Model model, HttpSession session) {
        Long cafeId = (Long) session.getAttribute("cafeId");
        model.addAttribute("orders", orderService.findRecentOrdersForCafe(cafeId));
        return "admin/AdminOrderDetail";
    }

    // =========================
    // 조리중 → 완료 (AJAX)
    // =========================
    @PostMapping(value = "/orders/{orderId}/done", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> markOrderDone(@PathVariable("orderId") Long orderId) {
        int updated = orderService.markDone(orderId);
        Map<String, Object> res = new HashMap<>();
        res.put("ok", updated > 0);
        return res;
    }

 // =========================
    // ✅ (추가) 신규 '처리중(N)' 카운트 (홈에서 3초 폴링)
    // - 세션에 저장된 lastSeenOrderId 이후 생성된 'N' 상태만 카운트
    // - OrderService 변경 없이, 목록 조회로 계산
    // =========================
    @GetMapping(value = "/order/pendingCount", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> pendingCount(HttpSession session) {
        // 세션 키: 카페별 lastSeen
        Long cafeId = (Long) session.getAttribute("cafeId");
        final String key = "lastSeenOrderId:" + cafeId;
        Long lastSeen = (Long) session.getAttribute(key);

        List<OrderDTO> all = orderService.findRecentOrdersForCafe(cafeId);
        long count = all.stream()
                .filter(o -> o != null && "N".equals(o.getStatus()))
                .filter(o -> lastSeen == null || (o.getOrderId() != null && o.getOrderId() > lastSeen))
                .count();

        Map<String, Object> res = new HashMap<>();
        res.put("count", count);
        return res;
    }

    // =========================
    // ✅ (추가) '주문내역' 진입 시 기준점 리셋
    // - 현재 카페의 최대 orderId를 세션에 저장 → 홈의 폴링 뱃지 0으로
    // =========================
    @PostMapping(value = "/order/markSeen", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> markSeen(HttpSession session) {
        Long cafeId = (Long) session.getAttribute("cafeId");
        final String key = "lastSeenOrderId:" + cafeId;

        List<OrderDTO> all = orderService.findRecentOrdersForCafe(cafeId);
        Long maxId = all.stream()
                .filter(Objects::nonNull)
                .map(OrderDTO::getOrderId)
                .filter(Objects::nonNull)
                .max(Comparator.naturalOrder())
                .orElse(0L);

        session.setAttribute(key, maxId);

        Map<String, Object> res = new HashMap<>();
        res.put("ok", true);
        res.put("lastSeen", maxId);
        return res;
    }
}
