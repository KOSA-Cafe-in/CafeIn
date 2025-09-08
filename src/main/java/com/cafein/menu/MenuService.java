package com.cafein.menu;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface MenuService {
	List<MenuDTO> findAll(); // 홈에서 메뉴 목록 조회용
    void createMenu(MenuDTO dto, MultipartFile imageFile) throws Exception;
    MenuDTO findById(Long id);
    void updateMenu(MenuDTO menuDTO, MultipartFile imageFile) throws Exception;
    void deleteMenu(Long id);
    List<MenuDTO> getAllMenus();
    MenuDTO getMenuById(Long menuId);
}