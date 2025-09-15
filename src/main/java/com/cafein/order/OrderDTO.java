package com.cafein.order;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class OrderDTO {
    private Long orderId;
    private String merchantUid;
    private Long userCafeId;
    private String paymentMethod;
    private Long totalPrice;
    private Date createdDate;
    private String status;     // CHAR(1) → 'N'(조리중), 'Y'(완료)
    private String takeout;    // CHAR(1) → 'Y'/'N'
    private String couponUse;  // CHAR(1) → 'Y'/'N'

    // ✅ 주문 상세 리스트 포함
    private List<OrderItemDTO> items;

    // 👇 추가 추천
    private String userName;   // 주문자 닉네임/이름 표시용
    private String cafeName;   // 필요시 점장 페이지에서 바로 보여주기용
}