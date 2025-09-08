package com.cafein.cafe;

import java.sql.Date;

import lombok.Data;

@Data
public class CafeDTO {
    private Long cafeId;
    private String name;
    private String content;
    private String logoUrl; // CLOB → String
    private Date createdDate;
}