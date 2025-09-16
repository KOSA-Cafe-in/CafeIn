package com.cafein.user.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.user.UserDTO;

// 사용자 MyBatis 매퍼 인터페이스 (담당 : 나규태)
public interface UserMapper {
	public UserDTO read(String username);	
	public UserDTO findUserById(@Param("userId") Long userId);	// userId로 조회
	public UserDTO findUserBySocial(@Param("socialProvider") String socialProvider, @Param("socialId") String socialId); // 소셜 로그인 정보로 조회
	public void createUser(@Param("socialProvider") String socialProvider, @Param("socialId") String socialId, @Param("nickname") String nickname, @Param("email") String email); 	// 사용자 생성
	public void updateUserNickname(@Param("userId") Long userId, @Param("nickname") String nickname); // 닉네임 수정
}

