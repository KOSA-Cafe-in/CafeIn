package com.cafein.user;

import java.sql.Date;

import lombok.Data;

@Data
public class UserDTO {
    private Long userId;
    private String socialProvider;
    private String socialId;
    private String nickname;
    private String email;
    private Date createdDate;
    private Date modifiedDate;
}