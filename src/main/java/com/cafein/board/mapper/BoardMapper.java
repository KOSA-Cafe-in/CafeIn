package com.cafein.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;  // ✅ 추가

import com.cafein.board.BoardDTO;
import com.cafein.board.BoardWithUserDTO;

@Mapper
public interface BoardMapper {
	List<BoardDTO> findAllBoardList(@Param("cafeId") Long cafeId);
	BoardDTO findBoardById(@Param("boardId") Long boardId);
    List<BoardWithUserDTO> findAllBoardListWithUser(@Param("cafeId") Long cafeId);
    BoardWithUserDTO findBoardByIdWithUser(@Param("boardId") Long boardId);
	void createBoard(BoardDTO board);
	void updateBoard(BoardDTO board);
	void deleteBoard(@Param("boardId") Long boardId);
}