package com.cafein.menu;

import java.sql.Date;

import lombok.Data;

@Data
public class MenuDTO {
    private Long menuId;
    private String name;
    private String content;
    private Long price;
    private String menuPictureUrl; // CLOB → String
    private Date createdDate;
    private Date modifiedDate;
}