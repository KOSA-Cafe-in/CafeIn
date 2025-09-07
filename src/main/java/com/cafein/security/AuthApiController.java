package com.cafein.security;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthApiController {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("error", message);
        return response;
    }

    private Map<String, Object> createSuccessResponse(String message, String accessToken) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", message);
        response.put("accessToken", accessToken);
        return response;
    }
    
    @GetMapping("/status")
    public ResponseEntity<Map<String,Object>> getAuthStatus(HttpServletRequest request){
    	Map<String, Object> response = new HashMap<>();
    	
        try {
            // 1. Authorization 헤더에서 먼저 확인
            String token = jwtUtil.extractTokenFromHeader(request);
            
            // 2. 헤더에 없으면 쿠키에서 확인
            if (token == null) {
                token = jwtUtil.extractTokenFromRequest(request);
            }
            
            System.out.println(token);
            
            if (token != null && jwtUtil.validateToken(token)) {
                Long userId = jwtUtil.getUserIdFromToken(token);
                String nickname = jwtUtil.getNicknameFromToken(token);
                
                response.put("isLoggedIn", true);
                response.put("userId", userId);
                response.put("nickname", nickname);
                
                System.out.println("인증 성공 - 사용자: " + nickname + " (ID: " + userId + ")");
                
            } else {
                response.put("isLoggedIn", false);
                System.out.println("인증 실패 - 토큰이 없거나 유효하지 않음");
            }
            
        } catch (Exception e) {
            response.put("isLoggedIn", false);
            response.put("error", "Token validation failed");
            System.out.println("인증 오류: " + e.getMessage());
        }
        
    	return ResponseEntity.ok(response);
    }
    
    // Access Token 갱신
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Refresh Token 추출 (HttpOnly 쿠키에서)
            String refreshToken = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("refreshToken".equals(cookie.getName())) {
                        refreshToken = cookie.getValue();
                        break;
                    }
                }
            }
            
            if (refreshToken == null || !jwtUtil.validateToken(refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(createErrorResponse("Invalid refresh token"));
            }
            
            // Refresh Token인지 확인
            if (!jwtUtil.isRefreshToken(refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(createErrorResponse("Not a refresh token"));
            }
            
            // 새로운 Access Token 생성
            Long userId = jwtUtil.getUserIdFromToken(refreshToken);
            // 닉네임은 DB에서 다시 조회하거나 별도 방법으로 가져오기
            String newAccessToken = jwtUtil.generateAccessToken(userId, "nickname");
            
            // 새로운 Access Token 쿠키 설정
            Cookie accessCookie = new Cookie("accessToken", newAccessToken);
            accessCookie.setHttpOnly(false);
            accessCookie.setPath("/");
            accessCookie.setMaxAge(15 * 60);
            response.addCookie(accessCookie);
            
            
            return ResponseEntity.ok(createSuccessResponse("Token refreshed successfully", newAccessToken));    
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(createErrorResponse("Token refresh failed"));
        }
    }
}