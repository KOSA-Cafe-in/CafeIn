package com.cafein.payment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafein.order.OrderDTO;
import com.cafein.order.OrderInfoDTO;
import com.cafein.order.OrderItemDTO;
import com.cafein.order.OrderService;
@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private OrderService orderService;

    @Value("${portone.imp.code}")
    private String portoneImpCode;

    // 결제 페이지로 이동
    @PostMapping("/checkout")
    public String checkout(@RequestParam Map<String, Object> params, Model model) {
        // 장바구니 데이터와 주문 정보를 모델에 추가
        model.addAttribute("orderData", params);
        model.addAttribute("merchantUid", paymentService.generateMerchantUid());
        model.addAttribute("portoneImpCode", portoneImpCode);
        return "payment/checkout";
    }
    
 // 모바일 결제 완료 처리 (GET 방식)
    @GetMapping("/complete")
    public String paymentCompleteGet(
        @RequestParam("imp_uid") String impUid,
        @RequestParam("merchant_uid") String merchantUid,
        @RequestParam(value = "imp_success", defaultValue = "false") String impSuccess,
        HttpSession session) {
        
        System.out.println("Mobile payment complete - GET method");
        System.out.println("imp_uid: " + impUid + ", merchant_uid: " + merchantUid + ", success: " + impSuccess);

        if ("true".equals(impSuccess)) {
            try {
                // PortOne에서 결제 정보 검증
            	PaymentDTO payment = paymentService.verifyPayment(impUid);

                if (payment == null || !"paid".equals(payment.getStatus())) {
                    return "redirect:/payment/fail?error_msg=" + java.net.URLEncoder.encode("결제 검증에 실패했습니다", "UTF-8");
                }

                // 세션에 결제 정보 저장
                session.setAttribute("lastPayment", payment);

                // 간단한 주문 정보 생성
                OrderDTO order = new OrderDTO();
                order.setTotalPrice(payment.getAmount().longValue());
                order.setPaymentMethod(payment.getPaymentMethod());
                order.setStatus("Y"); // 완료 상태로 설정
                session.setAttribute("lastOrder", order);

                return "redirect:/payment/success";

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/payment/fail?error_msg=";
            }
        } else {
            return "redirect:/payment/fail?error_msg=결제취소";
        }
    }

    // 결제 검증 및 완료 처리
    @PostMapping(
    		  value = "/complete",
    		  consumes = MediaType.APPLICATION_JSON_VALUE,
    		  produces = MediaType.APPLICATION_JSON_VALUE
    		)
    @ResponseBody
    public ResponseEntity<?> paymentComplete(@RequestBody OrderInfoDTO orderInfo, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        System.out.println("POST 성공");
        try {
            String impUid = orderInfo.getImp_uid();
            String merchantUid = orderInfo.getMerchant_uid();
            System.out.println(impUid +" , " + merchantUid);
            
            String orderType = orderInfo.getTakeOut();
            String couponUse = orderInfo.getCoupon();
            
            									
            // 1. PortOne에서 결제 정보 검증
            PaymentDTO payment = paymentService.verifyPayment(impUid);
            
            if (payment == null) {
                response.put("success", false);
                response.put("message", "결제 검증 실패");
                return ResponseEntity.ok(response);
            }

            // 2. 결제 상태 확인
            if (!"paid".equals(payment.getStatus())) {
                response.put("success", false);
                response.put("message", "결제가 완료되지 않았습니다.");
                return ResponseEntity.ok(response);
            }

            // items 변환 (menuId, qty -> OrderItemDTO.menuId, count)
            List<OrderItemDTO> items = orderInfo.getItems().stream()
            	    .map(it -> {
            	        OrderItemDTO dto = new OrderItemDTO();
            	        dto.setMenuId(it.getMenuId());
            	        // null 방지를 위해 qty 체크
            	        Long count = (it.getQty() != null) ? it.getQty().longValue() : 0L;
            	        dto.setCount(count);
            	        dto.setMenuName(it.getMenuName());
            	        return dto;
            	    })
            	    .collect(Collectors.toList());
            
            for(OrderItemDTO item : items)
            {
            	System.out.println("리스트 테스트ㅡㅡㅡㅡㅡㅡㅡ" + item.getCount());
            	System.out.println(item.getMenuId());
            }
            
            // 3. 주문 정보 저장 (실제 주문 처리)
            // 여기서 OrderService를 통해 주문을 데이터베이스에 저장
            Long userCafeId = (Long) session.getAttribute("userCafeId");
            OrderDTO order = orderService.createOrder(payment, orderType, couponUse, userCafeId, items);
            
            // 성공 데이터 세션에 보관 (성공 페이지에서 사용)
            session.setAttribute("lastPayment", payment);
            session.setAttribute("lastOrder", order);
            
            response.put("success", true);
            response.put("message", "결제가 성공적으로 완료되었습니다.");
            response.put("payment", payment);
            response.put("order", order);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "결제 처리 중 오류가 발생했습니다.");
        }
        System.out.println(response.get("message"));
        return ResponseEntity.ok(response);
    }

    // 결제 성공 페이지
    @GetMapping("/success")
    public String success(HttpSession session, Model model) {
        PaymentDTO payment = (PaymentDTO) session.getAttribute("lastPayment");
        OrderDTO order = (OrderDTO) session.getAttribute("lastOrder");
        if (payment == null || order == null) {
            return "redirect:/"; // 새로고침 등으로 세션이 비었을 때 대비
        }
        model.addAttribute("payment", payment);
        model.addAttribute("order", order);

        // 원하면 일회성으로 제거
        //session.removeAttribute("lastPayment");
        //session.removeAttribute("lastOrder");
        return "/payment/success"; // success.jsp
    }


    // 결제 실패 페이지
    @GetMapping("/fail")
    public String paymentFail(@RequestParam String error_msg, Model model) {
        model.addAttribute("errorMsg", error_msg);
        return "payment/fail";
    }

    // 결제 취소
    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelPayment(@RequestParam String impUid, @RequestParam String reason) {
        Map<String, Object> response = new HashMap<>();

        boolean cancelled = paymentService.cancelPayment(impUid, reason);

        if (cancelled) {
            response.put("success", true);
            response.put("message", "결제가 취소되었습니다.");
        } else {
            response.put("success", false);
            response.put("message", "결제 취소에 실패했습니다.");
        }

        return ResponseEntity.ok(response);
    }
}
