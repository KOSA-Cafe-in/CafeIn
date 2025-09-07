package com.cafein.mypage;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.cafe.CafeDTO;
import com.cafein.cafe.CafeService;
import com.cafein.user.UserDTO;
import com.cafein.user.UserService;
import com.cafein.usercafe.UserCafeDTO;
import com.cafein.usercafe.UserCafeService;

@Controller
public class MypageController {
	@Autowired
	private UserCafeService userCafeService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CafeService cafeService;
	
	// 마이페이지 조회
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
    	// 세션에서 현재 로그인 사용자 정보 가져오기
    	Long userCafeId = (Long) session.getAttribute("currentUserCafeId");
    	
    	if(userCafeId == null) {
    		return "redirect:/login"; // 로그인 안됨
    	}
    	    	
    	// userCafeId로 사용자 정보 조회
    	UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
    	UserDTO user = userService.findUserById(userCafe.getUserId());
    	CafeDTO cafe = cafeService.findCafeById(userCafe.getCafeId());
    	
    	model.addAttribute("user", user);
    	model.addAttribute("cafe", cafe);
    	model.addAttribute("userCafe", userCafe);
    
    	return "mypage/mypage"; 
    }
    
    // 수정 페이지 조회
    @GetMapping("/mypage/edit")
    public String mypageEdit(HttpSession session, Model model) {
    	// 세션에서 현재 로그인 사용자 정보 가져오기
    	Long userCafeId = (Long) session.getAttribute("currentUserCafeId");
    	
    	if(userCafeId == null) {
    		return "redirect:/login"; // 로그인 안됨
    	}
    	
    	// userCafeId로 사용자 정보 조회
    	UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
    	UserDTO user = userService.findUserById(userCafe.getUserId());
    	
    	model.addAttribute("user", user);
    	
    	return "mypage/edit"; 
    }
    
    @PostMapping("/mypage/updateNickname")
    public String updateNickname(HttpSession session, @RequestParam("nickname") String nickname) {
    	// 세션에서 현재 사용자 확인
    	Long userCafeId = (Long) session.getAttribute("currentUserCafeId");
    	if(userCafeId == null) {
    		return "redirect:/login";
    	}
    	
    	// 사용자 정보 업데이트
        UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
        userService.updateUserNickname(userCafe.getUserId(), nickname);
        
        // 성공 후 다시 마이페이지로 리다이렉트
        return "redirect:/mypage";
    }    
}