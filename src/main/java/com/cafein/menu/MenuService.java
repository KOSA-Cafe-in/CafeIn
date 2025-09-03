package com.cafein.menu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuService {

    @Autowired
    private MenuMapper menuMapper;

    public List<MenuDTO> getAllMenus() {
        return menuMapper.findAll();
    }
}