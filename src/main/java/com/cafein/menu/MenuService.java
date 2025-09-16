package com.cafein.menu;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

// 메뉴 비즈니스 로직 인터페이스 (담당 : 손윤찬)
public interface MenuService {
	List<MenuDTO> findAll(); // 홈에서 메뉴 목록 조회용
    void createMenu(MenuDTO dto, MultipartFile imageFile) throws Exception;     // 메뉴 생성
    MenuDTO findById(Long id);   // 메뉴 ID로 단일 메뉴 조회
    void updateMenu(MenuDTO menuDTO, MultipartFile imageFile) throws Exception;   // 메뉴 수정
    void deleteMenu(Long id);   // 메뉴 삭제 (소프트 삭제)
    List<MenuDTO> getAllMenus();    // 전체 메뉴 조회
    MenuDTO getMenuById(Long menuId); // 메뉴 ID로 단일 메뉴 조회
}