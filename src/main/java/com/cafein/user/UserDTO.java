package com.cafein.user;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class UserDTO {
    private Long userId;
    private Long cafeId;
    private String nickname;
    private String email;
    private Date createdDate;
    private Date modifiedDate;
    private List<AuthVO> authList;
}