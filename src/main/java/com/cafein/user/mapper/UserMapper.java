package com.cafein.user.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.user.UserDTO;

public interface UserMapper {
	public UserDTO read(String username);
	public UserDTO findUserById(@Param("userId") Long userId);
	public UserDTO findUserBySocial(@Param("socialProvider") String socialProvider, @Param("socialId") String socialId);
	public void createUser(@Param("socialProvider") String socialProvider, @Param("socialId") String socialId, @Param("nickname") String nickname, @Param("email") String email);
	public void updateUserNickname(@Param("userId") Long userId, @Param("nickname") String nickname);
}

