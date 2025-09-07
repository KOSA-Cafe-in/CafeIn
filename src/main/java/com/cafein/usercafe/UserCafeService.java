package com.cafein.usercafe;

public interface UserCafeService {
    UserCafeDTO findUserCafeById(Long userCafeId);
    UserCafeDTO findUserCafeByUserAndCafe(Long userId, Long cafeId);    
    void createUserCafe(Long userId, Long cafeId);    
}