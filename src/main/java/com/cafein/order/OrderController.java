package com.cafein.order;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.payment.PaymentDTO;

@Controller
public class OrderController {
	
	@Autowired
    private OrderService orderService;
    
	@GetMapping("/orders")
	public String orders(HttpSession session) {
        // 세션에서 사용자 역할 확인
        String role = (String) session.getAttribute("role");
        
        if("MANAGER".equals(role)) {
        	return "redirect:/admin/orders";
        } else if("CUSTOMER".equals(role)) {       	
        	return "redirect:/user/orderHistory";
        } else {
        	// 알 수 없는 역할인 경우 로그아웃 후 로그인 페이지로
        	return "redirect:/logout";
        }
	}
	
	@GetMapping("/user/orderHistory")
	public String orderHistory(HttpSession session, Model model)
	{
		long userCafeId = (Long) session.getAttribute("userCafeId");
		java.util.List<OrderDTO> orders = orderService.findAllOrderHistory(userCafeId);
	    model.addAttribute("orders", orders);
	    return "/user/orderHistory";
	}
	
	@GetMapping("/order/status")
    public ResponseEntity<Map<String, String>> getStatus(@RequestParam("merchantUid") String merchantUid) {
        String status = orderService.getCurrentStatusByMerchantUid(merchantUid);
        return ResponseEntity.ok(java.util.Collections.singletonMap("status", status)); // {"status":"Y"|"N"}
    }

	@GetMapping("/orderHistoryDetail/{orderId}")
	public String orderHistoryDetail(@PathVariable("orderId") Long orderId, Model model) {
	    // Fetch order and payment details by orderId
	    OrderDTO order = orderService.findOrderById(orderId);
	    order.setItems(orderService.findItemsByOrderId(orderId));
	    //PaymentDTO payment = orderService.findPaymentByOrderId(orderId);

	    // Add data to the model
	    model.addAttribute("order", order);
	    //model.addAttribute("payment", payment);

	    return "/user/orderHistoryDetail";
	}
}
