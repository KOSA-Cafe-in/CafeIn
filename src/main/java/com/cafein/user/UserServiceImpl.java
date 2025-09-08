package com.cafein.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.cafe.CafeDTO;
import com.cafein.cafe.CafeService;
import com.cafein.user.mapper.UserMapper;
import com.cafein.usercafe.UserCafeDTO;
import com.cafein.usercafe.UserCafeService;

@Service
public class UserServiceImpl implements UserService{
	@Autowired
	private UserMapper userMapper;
	
	@Autowired
	private CafeService cafeService;
	
	@Autowired
	private UserCafeService userCafeService;
	
	@Override
	public UserDTO findUserById(Long userId) {
		return userMapper.findUserById(userId);
	}
	
	@Override
    public UserDTO findUserBySocial(String socialProvider, String socialId) {
    	return userMapper.findUserBySocial(socialProvider, socialId);
    }
	
	@Override
	public void createUser(String socialProvider, String socialId, String nickname, String email) {
		userMapper.createUser(socialProvider, socialId, nickname, email);
	}
	
	@Override
	public void updateUserNickname(Long userId, String nickname) {
		userMapper.updateUserNickname(userId, nickname);
	}
    
	@Override
	public UserDTO processLogin(String socialProvider, String socialId, String nickname, String email, Long cafeId) {
		// 카페 존재 확인
		CafeDTO cafe = cafeService.findCafeById(cafeId);
		
		if(cafe == null) {
			throw new IllegalArgumentException("존재하지 않는 카페입니다.");
		}
		
		// 유저 존재 확인
		UserDTO user = findUserBySocial(socialProvider, socialId);
		
		if(user == null) {
			// 신규 회원 - 회원가입 처리
			createUser(socialProvider, socialId, nickname, email);
			// 방금 생성한 사용자 조회
			user = findUserBySocial(socialProvider, socialId);
			// UserCafe 관계도 생성
			userCafeService.createUserCafe(user.getUserId(), cafeId);
		} else {
			// 기존 회원 - UserCafe 관계 확인
			UserCafeDTO userCafe = userCafeService.findUserCafeByUserAndCafe(user.getUserId(), cafeId);
			if(userCafe == null) {
				// 기존 회원이지만 이 카페는 처음일 경우
				userCafeService.createUserCafe(user.getUserId(), cafeId);
			}
		}
		
		return user;
	}
}