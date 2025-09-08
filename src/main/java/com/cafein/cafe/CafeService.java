package com.cafein.cafe;

public interface CafeService {
    String findIntro(Long cafeId);
    void updateIntro(Long cafeId, String content);
}
