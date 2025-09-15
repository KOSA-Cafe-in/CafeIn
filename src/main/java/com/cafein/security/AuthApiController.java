package com.cafein.security;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthApiController {
    
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
    
    // 현재 사용자의 인증 상태와 정보를 반환
    @GetMapping("/status")
    public ResponseEntity<Map<String,Object>> getAuthStatus(HttpServletRequest request){
    	Map<String, Object> response = new HashMap<>();
    	
        try {
            HttpSession session = request.getSession(false); // 기존 세션만 가져오기
            
            if (session != null && session.getAttribute("userCafeId") != null) {
                // 로그인된 상태
                response.put("isLoggedIn", true);
                response.put("userId", session.getAttribute("userId"));
                response.put("nickname", session.getAttribute("nickname"));
                response.put("role", session.getAttribute("role"));
                response.put("cafeId", session.getAttribute("cafeId"));
                response.put("userCafeId", session.getAttribute("userCafeId"));
                
            } else {
                // 로그인되지 않은 상태
                response.put("isLoggedIn", false);
                response.put("message", "Not authenticated");
            }
            
        } catch (Exception e) {
            response.put("isLoggedIn", false);
            response.put("error", "Token validation failed");
        }
        
    	return ResponseEntity.ok(response);
    }

    // 현재 사용자의 상세 정보를 반환 (로그인한 경우만)
    @GetMapping("/user")
    public ResponseEntity<Map<String, Object>> getCurrentUser(HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userCafeId") == null) {
            response.put("error", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        // 세션에서 사용자 정보 추출
        response.put("userId", session.getAttribute("userId"));
        response.put("nickname", session.getAttribute("nickname"));
        response.put("role", session.getAttribute("role"));
        response.put("cafeId", session.getAttribute("cafeId"));
        response.put("userCafeId", session.getAttribute("userCafeId"));
        
        return ResponseEntity.ok(response);
    }
    
    // 세션 유효성 체크 (AJAX 요청용)
    @GetMapping("/check")
    public ResponseEntity<Map<String, Object>> checkSession(HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        HttpSession session = request.getSession(false);
        boolean isValid = session != null && session.getAttribute("userCafeId") != null;
        
        response.put("valid", isValid);
        
        if (isValid) {
            response.put("sessionId", session.getId());
            response.put("maxInactiveInterval", session.getMaxInactiveInterval());
        }
        
        return ResponseEntity.ok(response);
    }
}