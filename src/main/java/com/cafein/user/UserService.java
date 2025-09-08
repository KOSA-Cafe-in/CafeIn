package com.cafein.user;

public interface UserService {
    UserDTO findUserById(Long userId);    
    UserDTO findUserBySocial(String socialProvider, String socialId);    
    UserDTO processLogin(String socialProvider, String socialId, String nickname, String email, Long cafeId);
	void createUser(String socialProvider, String socialId, String nickname, String email);
	void updateUserNickname(Long userId, String nickname);
}