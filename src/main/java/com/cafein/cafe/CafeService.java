package com.cafein.cafe;

public interface CafeService {
    CafeDTO findCafeById(Long cafeId);
    String findIntro(Long cafeId);
    void updateIntro(Long cafeId, String content);
}