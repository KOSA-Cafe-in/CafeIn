package com.cafein.menu;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class UserMenuController {
	
	@Autowired
	private MenuService menuService;

	@GetMapping("/")
	public String root() {
		return "redirect:/user/home";
	}

	@GetMapping("/user/home")
	public String menu(Model model) {
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
}
