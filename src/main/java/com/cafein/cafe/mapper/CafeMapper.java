package com.cafein.cafe.mapper;

import org.apache.ibatis.annotations.Param;

import com.cafein.cafe.CafeDTO;

public interface CafeMapper {
	
	public CafeDTO findCafeById(@Param("cafeId") Long cafeId);

}

