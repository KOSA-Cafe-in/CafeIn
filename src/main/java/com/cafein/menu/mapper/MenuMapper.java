package com.cafein.menu.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.cafein.menu.MenuDTO;
import java.util.List;

@Mapper
public interface MenuMapper {

    // (선택) 기존에 쓰던 메서드들 유지
    List<MenuDTO> findAll();
    MenuDTO findById(Long menuId);

    // 실제 서비스에서 사용 중인 메서드들
    void createMenu(MenuDTO dto);
    List<MenuDTO> findAllMenus();

    MenuDTO findMenuById(@Param("id") Long id);
    void updateMenu(MenuDTO dto);

    // 소프트 삭제: IS_DELETE='Y' 로 전환 (메서드명 유지)
    int deleteMenu(@Param("id") Long id);
}
