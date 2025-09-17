package com.cafein.menu;

import java.util.Date;

import lombok.Data;

// 메뉴 정보를 담는 DTO (담당 : 손윤찬)
@Data
public class MenuDTO {
    private Long menuId;    // 메뉴 ID (PK)
    private String name;    // 메뉴 이름
    private String content; // 메뉴 설명
    private int price;  // 메뉴 가격
    private String menuPictureUrl;  // 메뉴 이미지 URL (S3)
    private Date createdDate;   // 생성일
    private Date modifiedDate;  // 수정일
}