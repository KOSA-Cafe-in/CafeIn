package com.cafein.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

// 커스텀 접근 거부 핸들러 (담당 : 나규태)
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
    // 접근 거부 시 처리 메서드
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException, ServletException {
        
        // 접근 거부 에러페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/error/error?message=" + 
                             java.net.URLEncoder.encode("해당 페이지에 접근할 권한이 없습니다.", "UTF-8"));
    }
}
