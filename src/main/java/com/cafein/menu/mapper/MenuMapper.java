package com.cafein.menu.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.cafein.menu.MenuDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;  // ✅ 추가

@Mapper
public interface MenuMapper {

    List<MenuDTO> findAll();
    
    MenuDTO findById(Long menuId);
    void createMenu(MenuDTO dto);
    List<MenuDTO> findAllMenus();

    // ✅ 단건조회/수정/삭제가 이미 있다면 아래처럼 @Param("id")만 보강
    MenuDTO findMenuById(@Param("id") Long id);
    void updateMenu(MenuDTO dto);
    int deleteMenu(@Param("id") Long id); // ✅ 반환값 int로 바꿔 영향행 확인 가능(안 바꿔도 동작엔 문제 없음)
}