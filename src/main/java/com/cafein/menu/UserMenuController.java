package com.cafein.menu;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.cafein.cafe.CafeService;
import com.cafein.stamp.StampDTO;
import com.cafein.stamp.StampService;

// 사용자 메뉴 컨트롤러 (담당 : 손윤찬)
@Controller
public class UserMenuController {
	
	@Autowired
	private MenuService menuService;
	
	@Autowired
	private CafeService cafeService;
	
	@Autowired
	private StampService stampService;

	// 루트 경로 접속 시 /home 으로 리다이렉트
	@GetMapping("/")
	public String root() {
		return "redirect:/home";
	}

	// 사용자 홈 (메뉴 리스트 및 카페 소개)
	@GetMapping("/user/home")
	public String menu(Model model, HttpSession session){
		long cafeId = (Long) session.getAttribute("cafeId");
		List<MenuDTO> menuList = menuService.getAllMenus();
		String content = cafeService.findIntro(cafeId);
		
		model.addAttribute("menuList", menuList);
		model.addAttribute("content", content);
		return "user/home";
	}

	// 메뉴 상세 페이지
	@GetMapping("/menu/detail/{menuId}")
	public String menuDetail(@PathVariable Long menuId, Model model) {
		MenuDTO menu = menuService.getMenuById(menuId);
		model.addAttribute("menu", menu);
		return "user/menuDetail";
	}
	
	// 장바구니 페이지
	@GetMapping("/user/cart")
	public String cart(HttpSession session, Model model) {
		long userCafeId = (Long) session.getAttribute("userCafeId");
		StampDTO stamp = stampService.findStampByUserCafeId(userCafeId);
		
		model.addAttribute("stamp", stamp);
	    return "user/cart";  // cart.jsp로 이동
	}
}
