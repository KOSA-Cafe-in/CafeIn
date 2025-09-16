package com.cafein.usercafe;

import java.util.Date;

import lombok.Data;

// 사용자-카페 관계를 담는 DTO (담당 : 나규태)
@Data
public class UserCafeDTO {
	private Long userCafeId;	// PK
	private Long userId;	// 사용자 ID
	private Long cafeId;	// 카페 ID
	private String role;	// 역할 (예: CUSTOMER, MANAGER)
	private Date joinDate;	// 가입일
}