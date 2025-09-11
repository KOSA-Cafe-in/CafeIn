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
	
	// 페이지네이션을 위한 페이징 메서드
	List<BoardWithUserDTO> findBoardListWithPaging(@Param("cafeId") Long cafeId, @Param("offset") int offset, @Param("size") int size);
	int getTotalBoardCount(@Param("cafeId") Long cafeId);
}