package com.cafein.board;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private Long boardId;
	private Long userId;
	private Long cafeId;
	private String title;
	private String content;
	private String pictureUrl; // CLOB → String
	private Date createdDate;
	private Date modifiedDate;
}