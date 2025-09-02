package com.cafein.order;

import lombok.Data;

@Data
public class OrderItemDTO {
    private Long orderItemId;
    private Long orderId;
    private Long menuId;
    private Long count;
    private Long unitPrice;
}