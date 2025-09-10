package com.cafein.payment;

import lombok.Data;

@Data
public class PaymentDTO {
    private String merchantUid;         // 주문번호
    private String impUid;              // PortOne 거래 고유번호
    private String paymentMethod;       // 결제수단
    private Long amount;                 // 결제금액
    private String status;              // 결제상태 (paid, failed, cancelled)
    private String buyerName;           // 구매자명
    private String buyerEmail;          // 구매자 이메일
    private String buyerTel;            // 구매자 연락처
    private String name;                // 상품명
    private String pgProvider;          // PG사
    private String pgTid;               // PG사 거래번호
    private String receiptUrl;          // 영수증 URL
    private String failReason;          // 실패사유
    private String createdDate;         // 생성일시
}
