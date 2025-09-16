package com.cafein.stamp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.stamp.mapper.StampMapper;

// 스탬프 비즈니스 로직 구현 클래스 (담당 : 나규태, 손윤찬)
@Service
public class StampServiceImpl implements StampService{
	@Autowired
	private StampMapper stampMapper;

	// userCafeId로 스탬프 조회
	@Override
	public StampDTO findStampByUserCafeId(Long userCafeId) {
		return stampMapper.findStampByUserCafeId(userCafeId);
	}
	
	// stampId로 스탬프 조회
	@Override
    public StampDTO findStampByStampId(Long stampId) {
    	return stampMapper.findStampByStampId(stampId);
    }
	
	// 스탬프 생성
	@Override
	public void createStamp(Long userCafeId, Integer stampCount, Integer discount) {
		stampMapper.createStamp(userCafeId, stampCount, discount);
	}
	
	// stampId로 스탬프 카운트 수정
	@Override
	public void updateStampCountByStampId(Long stampId, Integer stampCount) {
		stampMapper.updateStampCountByStampId(stampId, stampCount);
	}
	
	// userCafeId로 스탬프 카운트 수정
	@Override
	public void updateStampCountByUserCafeId(Long userCafeId,Integer stampCount) {
		stampMapper.updateStampCountByUserCafeId(userCafeId, stampCount);
	}
	
	// stampId로 스탬프 카운트 1 감소
	@Override
	public void minusStampCountByStampId(Long stampId) {
		stampMapper.minusStampCountByStampId(stampId);
	}
    
	// userCafeId로 스탬프 카운트 1 감소
	@Override
	public void minusStampCountByUserCafeId(Long userCafeId) {
		stampMapper.minusStampCountByUserCafeId(userCafeId);
	}	
}