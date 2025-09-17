package com.cafein.cafe;

// 카페 서비스 인터페이스 (담당 : 나규태, 손윤찬)
public interface CafeService {
    CafeDTO findCafeById(Long cafeId);  // cafeId로 조회
    String findIntro(Long cafeId);  // cafeId로 조회
    void updateIntro(Long cafeId, String content);  // cafeId로 소개글 수정
}