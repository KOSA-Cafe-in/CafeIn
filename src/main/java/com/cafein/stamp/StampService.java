package com.cafein.stamp;

public interface StampService {
	public StampDTO findStampByUserCafeId(Long userCafeId);
	public StampDTO findStampByStampId(Long stampId);
	public void createStamp(Long userCafeId, Integer stampCount, Integer discount);
	public void updateStampCountByStampId(Long stampId, Integer stampCount);
	public void updateStampCountByUserCafeId(Long userCafeId,Integer stampCount);
	public void minusStampCountByStampId(Long stampId);
	public void minusStampCountByUserCafeId(Long userCafeId);
}