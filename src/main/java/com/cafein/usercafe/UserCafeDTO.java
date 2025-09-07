package com.cafein.usercafe;

import java.sql.Date;

import lombok.Data;

@Data
public class UserCafeDTO {
	private Long userCafeId;
	private Long userId;
	private Long cafeId;
	private String role;	// MANAGER, CUSTOMER
	private Date joinDate;
}