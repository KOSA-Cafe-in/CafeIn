package com.cafein.order;

//PaymentCompleteRequest.java
import lombok.Data;
import java.util.List;

@Data
public class OrderInfoDTO {
 private String imp_uid;
 private String merchant_uid;
 private String takeOut;   // "Y" | "N"
 private String coupon;    // "Y" | "N"
 private List<Item> items; // <-- 배열을 여기로

 @Data
 public static class Item {
     private Long menuId;
     private Integer qty;  // 수량
 }
}

