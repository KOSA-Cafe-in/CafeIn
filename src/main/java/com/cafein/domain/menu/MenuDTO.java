package com.cafein.domain.menu;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class MenuDTO {
    private Long menuId;
    private String name;
    private String content;
    private Long price;
    private String menuPictureUrl; // CLOB → String
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
}