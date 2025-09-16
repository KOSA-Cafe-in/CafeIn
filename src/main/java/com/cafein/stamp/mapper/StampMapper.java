package com.cafein.stamp.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.stamp.StampDTO;

// 스탬프 MyBatis 매퍼 인터페이스 (담당 : 나규태, 손윤찬)
public interface StampMapper {
	// 스탬프 조회 및 CUD 작업
	public StampDTO findStampByUserCafeId(@Param("userCafeId") Long userCafeId);	// userCafeId로 스탬프 조회
	public StampDTO findStampByStampId(@Param("stampId") Long stampId);	// stampId로 스탬프 조회
	public void createStamp(@Param("userCafeId") Long userCafeId, @Param("stampCount") Integer stampCount, @Param("discount") Integer discount);	// 스탬프 생성
	public void updateStampCountByStampId(@Param("stampId") Long stampId, @Param("stampCount") Integer stampCount);	// stampId로 스탬프 카운트 수정
	public void updateStampCountByUserCafeId(@Param("userCafeId") Long userCafeId, @Param("stampCount") Integer stampCount);	// userCafeId로 스탬프 카운트 수정
	public void minusStampCountByStampId(@Param("stampId") Long stampId);	// stampId로 스탬프 카운트 1 감소
	public void minusStampCountByUserCafeId(@Param("userCafeId") Long userCafeId);	// userCafeId로 스탬프 카운트 1 감소
}

