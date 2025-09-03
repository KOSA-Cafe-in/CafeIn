package com.cafein.menu;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface MenuMapper {

    List<MenuDTO> findAll();
}