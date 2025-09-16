package com.cafein.board;

import java.util.Date;

import lombok.Data;

// 게시글 정보를 담는 DTO (담당 : 나규태)
@Data
public class BoardDTO {
    private Long boardId;           // 게시글 ID (PK)
    private Long userId;            // 작성자 ID (FK)
    private Long cafeId;            // 카페 ID (FK)
    private String title;           // 제목
    private String content;         // 내용
    private String boardPictureUrl; // 이미지 URL (S3)
    private Date createdDate;       // 작성일
    private Date modifiedDate;      // 수정일
}