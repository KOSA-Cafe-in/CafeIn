package com.cafein.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;  // ✅ 추가

import com.cafein.board.BoardDTO;
import com.cafein.board.BoardWithUserDTO;

// 게시판 MyBatis 매퍼 인터페이스 (담당 : 나규태)
@Mapper
public interface BoardMapper {
    // 기본 게시글 조회
    List<BoardDTO> findAllBoardList(@Param("cafeId") Long cafeId);           // 카페별 전체 게시글
    BoardDTO findBoardById(@Param("boardId") Long boardId);                  // 게시글 ID로 단일 조회

	// 작성자 정보 포함 조회 (JOIN)
    List<BoardWithUserDTO> findAllBoardListWithUser(@Param("cafeId") Long cafeId);     // 카페별 전체 (작성자 정보 포함)
    BoardWithUserDTO findBoardByIdWithUser(@Param("boardId") Long boardId);            // 단일 조회 (작성자 정보 포함)

	// 게시글 CUD 작업
	void createBoard(BoardDTO board);
	void updateBoard(BoardDTO board);
	void deleteBoard(@Param("boardId") Long boardId);
    
    // 페이징 처리
    List<BoardWithUserDTO> findBoardListWithPaging(   // 페이지별 게시글 조회
        @Param("cafeId") Long cafeId, 
        @Param("offset") int offset,    // 시작 위치
        @Param("size") int size         // 페이지 크기
    );
	int getTotalBoardCount(@Param("cafeId") Long cafeId);	// 카페별 전체 게시글 수
}
}