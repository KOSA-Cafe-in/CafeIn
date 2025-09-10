package com.cafein.order;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class OrderController {
	@GetMapping("/orders")
	public String orders(HttpSession session) {
        // 세션에서 사용자 역할 확인
        String role = (String) session.getAttribute("role");
        
        if("MANAGER".equals(role)) {
        	return "redirect:/admin/orders";
        } else if("CUSTOMER".equals(role)) {
        	return "redirect:/user/orders";
        } else {
        	// 알 수 없는 역할인 경우 로그아웃 후 로그인 페이지로
        	return "redirect:/logout";
        }
	}
}
