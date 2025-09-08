package com.cafein.login;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login(@RequestParam("cafeId") Long cafeId) {
	    System.out.println("카페 ID: " + cafeId);
	 // cafeId 값이 있으면 처리, 없으면 null
    	return "login"; // /WEB-INF/views/login.jsp
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 로그아웃 전에 카페 정보 저장
        Long cafeId = (Long) session.getAttribute("cafeId");
        
        session.invalidate();   // 세션 완전 삭제

        // 카페별 로그인 페이지로 리다이렉트
        if (cafeId != null) {
            return "redirect:/login?cafeId=" + cafeId;
        } else {
            return "redirect:/login";
        }
    }
}