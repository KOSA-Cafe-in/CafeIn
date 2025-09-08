package com.cafein.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("/home")
    @PreAuthorize("hasRole('ROLE_MANAGER')")
    public String adminHome(Authentication auth) {
        // 이미 권한 검증 완료
        return "admin/home";
    }
}