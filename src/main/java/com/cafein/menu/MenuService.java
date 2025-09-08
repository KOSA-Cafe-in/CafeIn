package com.cafein.menu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.menu.mapper.MenuMapper;

import java.util.List;

@Service
public class MenuService {

    @Autowired
    private MenuMapper menuMapper;

    public List<MenuDTO> getAllMenus() {
        return menuMapper.findAll();
    }
    
    public MenuDTO getMenuById(Long menuId) {
        return menuMapper.findById(menuId);
    }
}