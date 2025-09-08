package com.cafein.menu;

import java.util.Date;

import lombok.Data;

@Data
public class MenuDTO {
    private Long menuId;
    private String name;
    private String content;
    private int price;
    private String menuPictureUrl;
    private Date createdDate;
    private Date modifiedDate;
}