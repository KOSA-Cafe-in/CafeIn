package com.cafein.cafe.mapper;

import org.apache.ibatis.annotations.Param;

public interface CafeMapper {
    String findIntro(@Param("cafeId") Long cafeId);
    int updateIntro(@Param("cafeId") Long cafeId, @Param("content") String content);
}
