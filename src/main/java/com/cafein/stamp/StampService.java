package com.cafein.stamp;

// 스탬프 서비스 인터페이스 (담당 : 나규태, 손윤찬)
public interface StampService {
	public StampDTO findStampByUserCafeId(Long userCafeId);	// userCafeId로 스탬프 조회
	public StampDTO findStampByStampId(Long stampId);	// stampId로 스탬프 조회
	public void createStamp(Long userCafeId, Integer stampCount, Integer discount);	// 스탬프 생성
	public void updateStampCountByStampId(Long stampId, Integer stampCount);	// stampId로 스탬프 카운트 수정
	public void updateStampCountByUserCafeId(Long userCafeId,Integer stampCount);	// userCafeId로 스탬프 카운트 수정
	public void minusStampCountByStampId(Long stampId);	// stampId로 스탬프 카운트 1 감소
	public void minusStampCountByUserCafeId(Long userCafeId);	// userCafeId로 스탬프 카운트 1 감소
}