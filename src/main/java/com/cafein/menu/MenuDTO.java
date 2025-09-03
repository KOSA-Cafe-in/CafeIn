package com.cafein.menu;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MenuDTO {
    private Long menuId;
    private String name;
    private String content;
    private int price;
    private String menuPictureUrl;
    private Date createDate;
    private Date modifiedDate;
}