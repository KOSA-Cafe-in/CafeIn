package com.cafein.domain.user;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class UserDTO {
    private Long userId;
    private Long cafeId;
    private String nickname;
    private String email;
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
}