package com.cafein.usercafe;

// 사용자-카페 관계 서비스 인터페이스 (담당 : 나규태)
public interface UserCafeService {
    UserCafeDTO findUserCafeById(Long userCafeId);  // userCafeId로 조회
    UserCafeDTO findUserCafeByUserAndCafe(Long userId, Long cafeId);  // userId와 cafeId로 조회
    void createUserCafe(Long userId, Long cafeId);  // 사용자-카페 관계 생성
}