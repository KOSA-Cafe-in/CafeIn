package com.cafein.stamp.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.stamp.StampDTO;

public interface StampMapper {
	public StampDTO findStampByUserCafeId(@Param("userCafeId") Long userCafeId);
	public StampDTO findStampByStampId(@Param("stampId") Long stampId);
	public void createStamp(@Param("userCafeId") Long userCafeId, @Param("stampCount") Integer stampCount, @Param("discount") Integer discount);
	public void updateStampCountByStampId(@Param("stampId") Long stampId, @Param("stampCount") Integer stampCount);
	public void updateStampCountByUserCafeId(@Param("userCafeId") Long userCafeId, @Param("stampCount") Integer stampCount);
	public void minusStampCountByStampId(@Param("stampId") Long stampId);
	public void minusStampCountByUserCafeId(@Param("userCafeId") Long userCafeId);
}

