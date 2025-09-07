package com.cafein.login;

import java.util.Arrays;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.security.JwtUtil;
import com.cafein.security.KakaoOAuth2Service;
import com.cafein.user.UserDTO;
import com.cafein.user.UserService;
import com.cafein.usercafe.UserCafeDTO;
import com.cafein.usercafe.UserCafeService;

@Controller
@RequestMapping("/kakao")
public class KakaoLoginController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private UserCafeService userCafeService;
	
	@Autowired
	private KakaoOAuth2Service kakaoOAuth2Service;
	
	@Autowired
	private JwtUtil jwtUtil;
    
	// 카카오 로그인 시작
	@GetMapping("/login")
	public String kakaoLogin(@RequestParam("cafeId") Long cafeId) {
		// 카카오 로그인 페이지로 리다이렉트
		String redirectUrl = kakaoOAuth2Service.getAuthorizationRedirectUrl(cafeId);
		return "redirect:" + redirectUrl;
	}
	
	@GetMapping("/callback")
	public String kakaoCallback(@RequestParam("code") String code, @RequestParam("state") Long cafeId, HttpSession session, HttpServletResponse response) {
		System.out.println("인증코드 받음: " + code + "/ 카페 ID : " + cafeId);
		
		try {
			// 토큰 발급
			Map<String, Object> tokenInfo = kakaoOAuth2Service.getAccessToken(code);
			String token = (String) tokenInfo.get("access_token");
			
			// 사용자 정보 조회
			Map<String, Object> userInfo = kakaoOAuth2Service.getUserInfo(token);
			System.out.println("사용자 정보: " + userInfo);
			
      	    // 카카오 사용자 socialId 추출
	        String socialId = String.valueOf(userInfo.get("id"));

	        // properties에서 nickname 추출
	        Map<String, Object> properties = (Map<String, Object>) userInfo.get("properties");
	        String nickname = (String) properties.get("nickname");
	        
	        // kakao_account에서 email 추출
	        Map<String, Object> kakaoAccount = (Map<String, Object>) userInfo.get("kakao_account");
	        String email = (String) kakaoAccount.get("email");
	        
	        UserDTO user = userService.processLogin("KAKAO", socialId, nickname, email, cafeId);
	        
	        // role에 따른 redirect 처리
	        UserCafeDTO userCafe = userCafeService.findUserCafeByUserAndCafe(user.getUserId(), cafeId);
	        
	        // 세션에 userCafeId 저장
	        session.setAttribute("currentUserCafeId", userCafe.getUserCafeId());

	        // Access Token 생성 (짧은 만료시간)
	        String accessToken = jwtUtil.generateAccessToken(user.getUserId(), user.getNickname());
	        
	        // Refresh Token 생성 (긴 만료시간)
	        String refreshToken = jwtUtil.generateRefreshToken(user.getUserId());
	        
	        // Access Token은 일반 쿠키로 (JavaScript 접근 가능)
	        Cookie accessCookie = new Cookie("accessToken", accessToken);
	        accessCookie.setHttpOnly(false);
	        accessCookie.setPath("/");
	        accessCookie.setMaxAge(60 * 60); // 1시간
	        response.addCookie(accessCookie);
	        
	        // Refresh Token은 HttpOnly 쿠키로 (더 안전)
	        Cookie refreshCookie = new Cookie("refreshToken", refreshToken);
	        refreshCookie.setHttpOnly(true); // JavaScript 접근 불가
	        refreshCookie.setPath("/");
	        refreshCookie.setMaxAge(7 * 24 * 60 * 60); // 7일
	        response.addCookie(refreshCookie);
	        
	        System.out.println("JWT 토큰 생성 완료:" + accessCookie + "/" + refreshCookie);
	        
	        // Spring Security 인증 객체 생성
	        String role = "ROLE_" + userCafe.getRole();	// ROLE_MANAGER 또는 ROLE_CUSTOMER
	        Authentication auth = new UsernamePasswordAuthenticationToken(
	        		userCafe.getUserCafeId().toString(),
	        		null,
	        		Arrays.asList(new SimpleGrantedAuthority(role))
	        );
	        
	        // Spring security 컨텍스트에 인증 정보 저장
	        SecurityContextHolder.getContext().setAuthentication(auth);
	        
	        // 로그인 처리 후 점장이면 ADMIN 페이지로 이동
	        if(userCafe.getRole().equals("MANAGER")) {
	        	return "redirect:/admin/home";
	        }	        
			
			// 로그인 처리 후 손님이면 메인 페이지로 이동
			return "redirect:/home";
		} catch(Exception e) {
			e.printStackTrace();
			return "redirect:/login?error=kakao";
		}
	}
}