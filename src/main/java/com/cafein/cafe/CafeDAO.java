package com.cafein.cafe;

import org.springframework.stereotype.Repository;
import javax.annotation.Resource;

import com.cafein.cafe.mapper.CafeMapper;

@Repository
public class CafeDAO {

    @Resource
    private CafeMapper cafeMapper;

    public String findIntro(Long cafeId) {
        return cafeMapper.findIntro(cafeId);
    }

    public int updateIntro(Long cafeId, String content) {
        // mapper에 @Param으로 받는 시그니처면 그대로 전달
        return cafeMapper.updateIntro(cafeId, content);
    }
}
