package com.cafein.domain.board;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class BoardDTO {
    private Long boardId;
    private Long userId;
    private Long cafeId;
    private String title;
    private String content;
    private String pictureUrl; // CLOB → String
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
}