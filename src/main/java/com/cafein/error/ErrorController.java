package com.cafein.error;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

// 에러 컨트롤러 (담당 : 나규태)
@Controller
public class ErrorController {
    // 일반 에러 페이지
    @GetMapping("/error/error")
    public String accessDenied(@RequestParam(required = false) String message, Model model) {
        if (message == null) {
            message = "접근 권한이 없습니다.";
        }
        model.addAttribute("errorMessage", message);
        return "error/error";
    }
    
    // 401 Unauthorized 에러 처리
    @GetMapping("/error/401")
    public String unauthorized(Model model) {
        model.addAttribute("errorMessage", "로그인이 필요합니다.");
        return "error/error";
    }
    
    // 403 Forbidden 에러 처리
    @GetMapping("/error/403")
    public String forbidden(Model model) {
        model.addAttribute("errorMessage", "접근 권한이 없습니다.");
        return "error/error";
    }
}
