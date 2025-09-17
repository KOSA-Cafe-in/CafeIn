package com.cafein.cafe;

import org.springframework.stereotype.Repository;
import javax.annotation.Resource;

import com.cafein.cafe.mapper.CafeMapper;

// 카페 DAO (담당 : 나규태, 손윤찬)
@Repository
public class CafeDAO {

    @Resource
    private CafeMapper cafeMapper;

    // cafeId로 단일 카페 조회
    public String findIntro(Long cafeId) {
        return cafeMapper.findIntro(cafeId);
    }

    // cafeId로 소개글 수정
    public int updateIntro(Long cafeId, String content) {
        // mapper에 @Param으로 받는 시그니처면 그대로 전달
        return cafeMapper.updateIntro(cafeId, content);
    }
}
