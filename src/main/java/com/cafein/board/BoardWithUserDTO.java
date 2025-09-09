package com.cafein.board;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardWithUserDTO {
	private Long boardId;
	private Long userId;
	private Long cafeId;
	private String title;
	private String content;
	private String boardPictureUrl; // CLOB → String
	private Date createdDate;
	private Date modifiedDate;
	
	private String nickname;
	private String email;
}