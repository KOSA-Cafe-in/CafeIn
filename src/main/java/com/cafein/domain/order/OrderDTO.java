package com.cafein.domain.order;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class OrderDTO {
    private Long orderId;
    private Long userId;
    private Long cafeId;
    private String paymentMethod;
    private Long totalPrice;
    private LocalDateTime createdDate;
    private String status;   // CHAR(1)
    private String takeout;  // CHAR(1)
    private String couponUse; // CHAR(1)
}