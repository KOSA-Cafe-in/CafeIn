package com.cafein.order;

import lombok.Data;

@Data
public class OrderItemDTO {
    private Long orderItemId;
    private Long orderId;
    private Long menuId;
    private Long count;
    private Long unitPrice;

    // ✅ 메뉴 이름도 함께 가져오면 JSP에서 더 편리
    private String menuName;

    // 👇 추가 추천
    private String menuPictureUrl; // 메뉴 썸네일 같이 보여주려면
}
