package com.cafein.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.cafein.menu")  // 또는 "com.cafein"으로 전체 패키지 스캔
public class MyBatisConfig {
}
