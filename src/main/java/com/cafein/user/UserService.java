package com.cafein.user;

// 사용자 서비스 인터페이스 (담당 : 나규태)
public interface UserService {
    UserDTO findUserById(Long userId);      // userId로 조회
    UserDTO findUserBySocial(String socialProvider, String socialId);    // 소셜 로그인 정보로 조회             
    UserDTO processLogin(String socialProvider, String socialId, String nickname, String email, Long cafeId);   // 로그인 처리 (사용자 생성 및 세션 설정)
	void createUser(String socialProvider, String socialId, String nickname, String email);   // 사용자 생성
	void updateUserNickname(Long userId, String nickname);  // 닉네임 수정
}