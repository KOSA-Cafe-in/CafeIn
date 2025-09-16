package com.cafein.cafe;

import java.util.Date;

import lombok.Data;

// 카페 정보를 담는 DTO (담당 : 나규태, 손윤찬)
@Data
public class CafeDTO {
    private Long cafeId;    // 카페 ID (PK)
    private String name;    // 카페 이름
    private String content; // 카페 소개글
    private String logoUrl; // 카페 로고 URL
    private Date createdDate; // 생성일
}