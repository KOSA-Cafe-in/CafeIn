package com.cafein.board;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

// 게시판 비즈니스 로직 인터페이스 (담당 : 나규태)
public interface BoardService {
	 // 기본 게시글 조회
    List<BoardDTO> findAllBoardList(Long cafeId);     // 카페별 전체 게시글 조회
    BoardDTO findBoardById(Long boardId);     // 게시글 ID로 단일 게시글 조회

	// 작성자 정보 포함 조회
    List<BoardWithUserDTO> findAllBoardListWithUser(Long cafeId);    // 카페별 전체 게시글 + 작성자 정보 조회
    BoardWithUserDTO findBoardByIdWithUser(Long boardId);    // 게시글 ID로 단일 게시글 + 작성자 정보 조회

	// 게시글 CUD 작업
	void createBoard(BoardDTO board, MultipartFile imageFile) throws Exception;	 // 게시글 작성
	void updateBoard(BoardDTO board, MultipartFile imageFile) throws Exception;	 // 게시글 수정
	void deleteBoard(Long boardId);	 // 게시글 삭제

	// 페이징 처리
	List<BoardWithUserDTO> findBoardListWithPaging(Long cafeId, int page, int size);	// 페이지별 조회
	int getTotalBoardCount(Long cafeId);	 // 전체 게시글 수 (페이지 계산용)
}