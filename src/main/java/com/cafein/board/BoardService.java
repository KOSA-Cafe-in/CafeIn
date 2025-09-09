package com.cafein.board;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface BoardService {
    List<BoardDTO> findAllBoardList(Long cafeId);    
    BoardDTO findBoardById(Long boardId);    
    List<BoardWithUserDTO> findAllBoardListWithUser(Long cafeId);    
    BoardWithUserDTO findBoardByIdWithUser(Long boardId);    
	void createBoard(BoardDTO board, MultipartFile imageFile) throws Exception;
	void updateBoard(BoardDTO board, MultipartFile imageFile) throws Exception;
	void deleteBoard(Long boardId);
}