package com.cafein.cafe;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafein.cafe.mapper.CafeMapper;

@Service
public class CafeServiceImpl implements CafeService{
	@Autowired
	private CafeMapper cafeMapper;
	
	@Override
    public CafeDTO findCafeById(Long cafeId) {
    	return cafeMapper.findCafeById(cafeId);
    }
    
}