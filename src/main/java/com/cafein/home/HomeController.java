package com.cafein.home;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    
    @GetMapping("/home")
    public String home(HttpSession session) {
        // 세션에서 사용자 역할 확인
        String role = (String) session.getAttribute("role");
        Long cafeId = (Long) session.getAttribute("cafeId");
        
        // 로그인되지 않은 경우 로그인 페이지로
        if (role == null || cafeId == null) {
            if (cafeId != null) {
                return "redirect:/login?cafeId=" + cafeId;
            } else {
                // cafeId가 없는 경우 기본 로그인 페이지로 (실제로는 에러 처리 필요)
                return "redirect:/error/error";
            }
        }
        
        // 역할에 따른 홈페이지 분기
        if ("MANAGER".equals(role)) {
            return "redirect:/admin/home";
        } else if ("CUSTOMER".equals(role)) {
            return "redirect:/user/home";
        } else {
            // 알 수 없는 역할인 경우 로그아웃 후 로그인 페이지로
            return "redirect:/logout";
        }
    }
}
