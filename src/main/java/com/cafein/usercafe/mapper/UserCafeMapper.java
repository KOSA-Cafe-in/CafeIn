package com.cafein.usercafe.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.usercafe.UserCafeDTO;

public interface UserCafeMapper {
	public UserCafeDTO findUserCafeById(@Param("userCafeId") Long userCafeId);
	public UserCafeDTO findUserCafeByUserAndCafe(@Param("userId") Long userId, @Param("cafeId") Long cafeId);
	public void createUserCafe(@Param("userId") Long userId, @Param("cafeId") Long cafeId);
}

