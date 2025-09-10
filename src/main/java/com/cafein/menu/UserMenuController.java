package com.cafein.menu;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class UserMenuController {
	
	@Autowired
	private MenuService menuService;

	@GetMapping("/")
	public String root() {
		return "redirect:/home";
	}

	@GetMapping("/user/home")
	public String menu(Model model){
		List<MenuDTO> menuList = menuService.getAllMenus();
		model.addAttribute("menuList", menuList);
		return "user/home";
	}

	@GetMapping("/menu/detail/{menuId}")
	public String menuDetail(@PathVariable Long menuId, Model model) {
		MenuDTO menu = menuService.getMenuById(menuId);
		model.addAttribute("menu", menu);
		return "user/menuDetail";
	}
	
	@RequestMapping(value = "/user/cart", method = RequestMethod.GET)
	public String cart() {
	    return "user/cart";  // cart.jsp로 이동
	}
}
