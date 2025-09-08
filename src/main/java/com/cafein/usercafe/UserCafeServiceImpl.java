package com.cafein.usercafe;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.usercafe.mapper.UserCafeMapper;

@Service
public class UserCafeServiceImpl implements UserCafeService{
	@Autowired
	private UserCafeMapper userCafeMapper;
	
	@Override
	public UserCafeDTO findUserCafeById(Long userCafeId) {
		return userCafeMapper.findUserCafeById(userCafeId);
	}
	
	@Override
    public UserCafeDTO findUserCafeByUserAndCafe(Long userId, Long cafeId) {
    	return userCafeMapper.findUserCafeByUserAndCafe(userId, cafeId);
    }
	
	@Override
	public void createUserCafe(Long userId, Long cafeId) {
		userCafeMapper.createUserCafe(userId, cafeId);
	}
    
}