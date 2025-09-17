package com.cafein.stamp;

import lombok.Data;

// 스탬프 정보를 담는 DTO (담당 : 나규태, 손윤찬)
@Data
public class StampDTO {
    private Long stampId;     // 스탬프 ID (PK)
    private Long userCafeId;    // 사용자-카페 ID (FK)
    private Integer stampCount; // 스탬프 개수
    private Integer discount;   // 할인율
}