package com.cafein.cafe;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafein.cafe.mapper.CafeMapper;

// 카페 비즈니스 로직 구현 클래스 (담당 : 나규태, 손윤찬)
@Service
public class CafeServiceImpl implements CafeService{
	@Autowired
	private CafeMapper cafeMapper;
	
    // cafeId로 단일 카페 조회
	@Override
    public CafeDTO findCafeById(Long cafeId) {
    	return cafeMapper.findCafeById(cafeId);
    }

    // cafeId로 소개글 조회
    @Override
    public String findIntro(Long cafeId) {
        return cafeMapper.findIntro(cafeId);
    }

    // cafeId로 소개글 수정
    @Transactional
    @Override
    public void updateIntro(Long cafeId, String content) {
        // DB 컬럼이 VARCHAR2(3000)이므로 서버에서 3000으로 안전하게 자르기
        String safe = content == null ? "" : content;
        if (safe.length() > 3000) safe = safe.substring(0, 3000);
        cafeMapper.updateIntro(cafeId, safe);
    }
}