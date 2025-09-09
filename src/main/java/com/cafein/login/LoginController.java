package com.cafein.login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.cafe.CafeDTO;
import com.cafein.cafe.CafeService;

@Controller
public class LoginController {
	
	@Autowired
	private CafeService cafeService;

    @GetMapping("/login")
    public String login(@RequestParam("cafeId") Long cafeId, Model model) {
	    System.out.println("카페 ID: " + cafeId);
	    
        if (cafeId != null) {
            try {
                // CafeService의 findCafeById로 카페 정보 조회
                CafeDTO cafe = cafeService.findCafeById(cafeId);
                
                if (cafe != null) {
                    // Model에 카페 정보 추가 (JSP에서 사용 가능)
                    model.addAttribute("cafe", cafe);
                    model.addAttribute("cafeId", cafeId);
                    
                    System.out.println("카페 정보 조회 성공: " + cafe.getName());
                } else {
                    System.out.println("카페를 찾을 수 없습니다: " + cafeId);
                    model.addAttribute("error", "카페를 찾을 수 없습니다.");
                }
                
            } catch (Exception e) {
                System.out.println("카페 정보 조회 오류: " + e.getMessage());
                model.addAttribute("error", "카페 정보를 불러오는데 실패했습니다.");
            }
        }
        
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