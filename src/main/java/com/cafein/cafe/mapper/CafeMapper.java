package com.cafein.cafe.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.cafe.CafeDTO;

// 카페 MyBatis 매퍼 인터페이스 (담당 : 나규태, 손윤찬)
public interface CafeMapper {
	public CafeDTO findCafeById(@Param("cafeId") Long cafeId);  // cafeId로 조회
    String findIntro(@Param("cafeId") Long cafeId);  // cafeId로 조회
    int updateIntro(@Param("cafeId") Long cafeId, @Param("content") String content);    // cafeId로 소개글 수정
}

