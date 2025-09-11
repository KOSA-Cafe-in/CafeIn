package com.cafein.stamp;

import lombok.Data;

@Data
public class StampDTO {
    private Long stampId;
    private Long userCafeId;
    private Integer stampCount;
    private Integer discount;
}