package com.cafein.stamp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.stamp.mapper.StampMapper;

@Service
public class StampServiceImpl implements StampService{
	@Autowired
	private StampMapper stampMapper;

	@Override
	public StampDTO findStampByUserCafeId(Long userCafeId) {
		return stampMapper.findStampByUserCafeId(userCafeId);
	}
	
	@Override
    public StampDTO findStampByStampId(Long stampId) {
    	return stampMapper.findStampByStampId(stampId);
    }
	
	@Override
	public void createStamp(Long userCafeId, Integer stampCount, Integer discount) {
		stampMapper.createStamp(userCafeId, stampCount, discount);
	}
	
	@Override
	public void updateStampCountByStampId(Long stampId, Integer stampCount) {
		stampMapper.updateStampCountByStampId(stampId, stampCount);
	}
	
	@Override
	public void updateStampCountByUserCafeId(Long userCafeId,Integer stampCount) {
		stampMapper.updateStampCountByUserCafeId(userCafeId, stampCount);
	}
	
	@Override
	public void minusStampCountByStampId(Long stampId) {
		stampMapper.minusStampCountByStampId(stampId);
	}
    
	@Override
	public void minusStampCountByUserCafeId(Long userCafeId) {
		stampMapper.minusStampCountByUserCafeId(userCafeId);
	}	
}