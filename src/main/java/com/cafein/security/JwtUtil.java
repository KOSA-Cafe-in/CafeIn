package com.cafein.security;


import java.util.Date;

import javax.crypto.SecretKey;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@Component
@PropertySource("classpath:application.properties")
public class JwtUtil {
	@Value("${jwt.secret}")
	private String secretKey;
	
    // Access Token: 1시간
    private static final long ACCESS_TOKEN_EXPIRATION = 60 * 60 * 1000L;
    // Refresh Token: 7일
    private static final long REFRESH_TOKEN_EXPIRATION = 7 * 24 * 60 * 60 * 1000L;
	
	private SecretKey getSigninKey() {
		return Keys.hmacShaKeyFor(secretKey.getBytes());
	}
	
	// 액세스 토큰 생성
	public String generateAccessToken(Long userId, String nickname) {
		Date now = new Date();
		Date expiryDate = new Date(now.getTime() + ACCESS_TOKEN_EXPIRATION); 
		
		return Jwts.builder()
				.setSubject(String.valueOf(userId))
				.claim("nickname", nickname)
				.claim("type","access")	// 토큰 타입 구분
				.setIssuedAt(now)
				.setExpiration(expiryDate)
				.signWith(getSigninKey(), SignatureAlgorithm.HS256)
				.compact();
	}
	
	// 리프레시 토큰 생성
	public String generateRefreshToken(Long userId) {
		Date now = new Date();
		Date expiryDate = new Date(now.getTime() + REFRESH_TOKEN_EXPIRATION); 
		
		return Jwts.builder()
				.setSubject(String.valueOf(userId))				
				.claim("type","refreesh")	// 토큰 타입 구분
				.setIssuedAt(now)
				.setExpiration(expiryDate)
				.signWith(getSigninKey(), SignatureAlgorithm.HS256)
				.compact();
	}
	
    // 토큰 타입 확인
    public String getTokenType(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSigninKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        
        return claims.get("type", String.class);
    }
    
    // Access Token인지 확인
    public boolean isAccessToken(String token) {
        return "access".equals(getTokenType(token));
    }
    
    // Refresh Token인지 확인
    public boolean isRefreshToken(String token) {
        return "refresh".equals(getTokenType(token));
    }
	    
    // JWT 토큰에서 사용자 ID 추출    
    public Long getUserIdFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSigninKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        
        return Long.valueOf(claims.getSubject());
    }
       
    // JWT 토큰에서 닉네임 추출    
    public String getNicknameFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSigninKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        
        return claims.get("nickname", String.class);
    }
	
	// JWT 토큰 유효성 검증
	public boolean validateToken(String token) {
		try {
			Jwts.parserBuilder()
				.setSigningKey(getSigninKey())
				.build()
				.parseClaimsJws(token);
			return true;
		} catch(JwtException | IllegalArgumentException e){
			System.out.println("JWT 토큰 검증 실패: " + e.getMessage());
			return false;
		}
	}
	
	// 토큰 만료 여부 확인
	public boolean isTokenExpired(String token) {
		try {
			Claims claims = Jwts.parserBuilder()
					.setSigningKey(getSigninKey())
					.build()
					.parseClaimsJws(token)
					.getBody();
			
			return claims.getExpiration().before(new Date());
		}catch(JwtException e) {
			return true;
		}
	}
	
	// HttpServletRequest에서 JWT 토큰 추출(쿠키에서)
	public String extractTokenFromRequest(HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("accessToken")) {
					return cookie.getValue();
				}
			}
		}
		return null;
	}
	
	// HttpServletRequest에서 JWT 토큰 추출 (Authorization 헤더에서)
	public String extractTokenFromHeader(HttpServletRequest request) {
		String bearerToken = request.getHeader("Authorization");
		if(bearerToken != null && bearerToken.startsWith("bearer")) {
			return bearerToken.substring(7);
		}
		return null;
	}
}