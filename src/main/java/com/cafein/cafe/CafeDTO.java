package com.cafein.cafe;

import lombok.Data;

@Data
public class CafeDTO {
    private Long cafeId;
    private String name;
    private String content;
    private String code;
    private String logoUrl; // CLOB → String
}