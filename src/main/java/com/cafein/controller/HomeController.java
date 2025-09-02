package com.cafein.controller;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.cafein.domain.menu.MenuDTO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);

		// 메뉴 목록 추가
		List<MenuDTO> menuList = createSampleMenus();
		model.addAttribute("menuList", menuList);
		model.addAttribute("serverTime", formattedDate);

		return "home";
	}

	@GetMapping("/menu/{menuId}")
	public String menuDetail(@PathVariable int menuId, Model model) {
		// 특정 메뉴 정보 조회 (추후 DB에서 가져오도록 수정)
		MenuDTO menu = getMenuById(menuId);
		if (menu != null) {
			model.addAttribute("menu", menu);
			return "menu-detail";
		} else {
			return "redirect:/";
		}
	}

	// 샘플 메뉴 데이터 생성 (임시)
	private List<MenuDTO> createSampleMenus() {
		List<MenuDTO> menuList = new ArrayList<>();

		// home.jsp의 메뉴들과 매칭되는 데이터
		menuList.add(new MenuDTO(0, "리뷰쓰고 마카롱 1개 받기", "이벤트에 참여해주시면 직원이 리뷰작성용 영수증을 가져다드려요.", 0, "/resources/images/event.jpg", "이벤트", true));
		menuList.add(new MenuDTO(1, "루꼴라 크로와상 샌드위치", "크림치즈, 햄, 토마토, 루꼴라, 로메인이 들어간 건강한 샌드위치", 7500, "/resources/images/rukkola.jpg", "샌드위치", true));
		menuList.add(new MenuDTO(2, "햄치즈 통밀 샌드위치", "건강한 통밀빵에 햄, 치즈, 신선한 야채가 듬뿍 들어간 담백한 샌드위치", 7000, "/resources/images/hamcheese.jpg", "샌드위치", true));
		menuList.add(new MenuDTO(3, "메뉴 준비중", "커피 메뉴가 곧 업데이트 됩니다.", 0, "/resources/images/coming.jpg", "커피", false));

		return menuList;
	}

	// ID로 메뉴 찾기 (임시)
	private MenuDTO getMenuById(int menuId) {
		List<MenuDTO> menuList = createSampleMenus();
		return menuList.stream().filter(menu -> menu.getMenuId() == menuId).findFirst().orElse(null);
	}
}
