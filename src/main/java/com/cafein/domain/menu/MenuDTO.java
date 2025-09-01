package com.cafein.domain.menu;

import java.util.Date;
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