package com.cafein.cafe.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.cafe.CafeDTO;

public interface CafeMapper {
	public CafeDTO findCafeById(@Param("cafeId") Long cafeId);
    String findIntro(@Param("cafeId") Long cafeId);
    int updateIntro(@Param("cafeId") Long cafeId, @Param("content") String content);
}

