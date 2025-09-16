package com.cafein.user;

import java.util.Date;

import lombok.Data;

// 사용자 정보를 담는 DTO (담당 : 나규태)
@Data
public class UserDTO {
    private Long userId;    // 사용자 ID (PK)
    private String socialProvider; // 소셜 로그인 제공자
    private String socialId; // 소셜 로그인 ID
    private String nickname; // 사용자 닉네임
    private String email; // 사용자 이메일
    private Date createdDate; // 생성일
    private Date modifiedDate; // 수정일
}