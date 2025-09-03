package com.cafein.menu;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MenuController {
	
	@Autowired
	private MenuService menuService;

	@GetMapping("/user/home")
	public String menu(Model model) {
		List<MenuDTO> menuList = menuService.getAllMenus();
		model.addAttribute("menuList", menuList);
		return "user/home";
	}
}
