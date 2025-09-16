package com.cafein.board;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 게시글과 작성자 정보를 함께 조회하기 위한 DTO (담당 : 나규태)
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardWithUserDTO {
    private Long boardId;        // 게시글 ID
    private Long userId;         // 작성자 ID
    private Long cafeId;         // 카페 ID
    private String title;        // 제목
    private String content;      // 내용
    private String boardPictureUrl; // 이미지 URL
    private Date createdDate;    // 작성일
    private Date modifiedDate;   // 수정일
    
    // 작성자 정보 (조인)
    private String nickname;     // 작성자 닉네임
    private String email;        // 작성자 이메일
}