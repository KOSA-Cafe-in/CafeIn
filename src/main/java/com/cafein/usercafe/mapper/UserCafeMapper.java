package com.cafein.usercafe.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.usercafe.UserCafeDTO;

// 사용자-카페 관계 MyBatis 매퍼 인터페이스 (담당 : 나규태)
public interface UserCafeMapper {
	public UserCafeDTO findUserCafeById(@Param("userCafeId") Long userCafeId);  // userCafeId로 조회
	public UserCafeDTO findUserCafeByUserAndCafe(@Param("userId") Long userId, @Param("cafeId") Long cafeId);  // userId와 cafeId로 조회
	public void createUserCafe(@Param("userId") Long userId, @Param("cafeId") Long cafeId); // 사용자-카페 관계 생성
}

