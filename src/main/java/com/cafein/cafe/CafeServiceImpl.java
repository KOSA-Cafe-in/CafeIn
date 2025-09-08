package com.cafein.cafe;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafein.cafe.mapper.CafeMapper;

@Service
public class CafeServiceImpl implements CafeService {

    @Resource
    private CafeMapper cafeMapper;

    @Override
    public String findIntro(Long cafeId) {
        return cafeMapper.findIntro(cafeId);
    }

    @Transactional
    @Override
    public void updateIntro(Long cafeId, String content) {
        // DB 컬럼이 VARCHAR2(255)이므로 서버에서 255로 안전하게 자르기
        String safe = content == null ? "" : content;
        if (safe.length() > 255) safe = safe.substring(0, 255);
        cafeMapper.updateIntro(cafeId, safe);
    }
}
