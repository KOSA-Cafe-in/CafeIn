package com.cafein.usercafe;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.usercafe.mapper.UserCafeMapper;

// 사용자-카페 관계 비즈니스 로직 구현 클래스 (담당 : 나규태)
@Service
public class UserCafeServiceImpl implements UserCafeService{
	@Autowired
	private UserCafeMapper userCafeMapper;
	
	// userCafeId로 단일 사용자-카페 관계 조회
	@Override
	public UserCafeDTO findUserCafeById(Long userCafeId) {
		return userCafeMapper.findUserCafeById(userCafeId);
	}
	
	// userId와 cafeId로 단일 사용자-카페 관계 조회
	@Override
    public UserCafeDTO findUserCafeByUserAndCafe(Long userId, Long cafeId) {
    	return userCafeMapper.findUserCafeByUserAndCafe(userId, cafeId);
    }
	
	// 사용자-카페 관계 생성
	@Override
	public void createUserCafe(Long userId, Long cafeId) {
		userCafeMapper.createUserCafe(userId, cafeId);
	}
    
}