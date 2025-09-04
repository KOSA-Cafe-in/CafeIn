package com.cafein.menu.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.cafein.menu.MenuDTO;

import java.util.List;

@Mapper
public interface MenuMapper {

    List<MenuDTO> findAll();

    MenuDTO findById(Long menuId);
}