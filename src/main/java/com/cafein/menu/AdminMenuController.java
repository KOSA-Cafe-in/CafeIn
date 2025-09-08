package com.cafein.menu;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private static final Long CAFE_ID = 1L;

    // =========================
    // 홈 = 메뉴판 (/admin/home)
    // =========================
    @GetMapping("/home")
    public String showHome(Model model) {
        String cafeIntro = cafeService.findIntro(CAFE_ID);
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
    public Map<String, Object> updateIntroAjax(@RequestParam("content") String content) {
        cafeService.updateIntro(CAFE_ID, content);
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
    public String showOrders(Model model) {
        model.addAttribute("orders", orderService.findRecentOrdersForCafe(CAFE_ID));
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
}
