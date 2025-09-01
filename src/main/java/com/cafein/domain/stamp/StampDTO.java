package com.cafein.domain.stamp;

import lombok.Data;

@Data
public class StampDTO {
    private Long stampId;
    private Long stampCount;
    private Long discount;
    private Long userId;
}