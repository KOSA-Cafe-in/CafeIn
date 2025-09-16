package com.cafein.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cafein.board.mapper.BoardMapper;
import com.cafein.menu.S3Uploader;

// 게시판 비즈니스 로직 구현 클래스 (담당 : 나규태)
@Service
public class BoardServiceImpl implements BoardService{
	@Autowired
	private BoardMapper boardMapper;
	
	@Autowired
	private S3Uploader s3Uploader;	// S3 파일 업로드 서비스

	// 카페별 전체 게시글 조회
	@Override
    public List<BoardDTO> findAllBoardList(Long cafeId) {
        return boardMapper.findAllBoardList(cafeId);
    }

	// 게시글 ID로 단일 게시글 조회
	@Override
    public BoardDTO findBoardById(Long boardId) {
        return boardMapper.findBoardById(boardId);
    }
	
	// 카페별 전체 게시글 + 작성자 정보 조회
	@Override
	public List<BoardWithUserDTO> findAllBoardListWithUser(Long cafeId) {
		return boardMapper.findAllBoardListWithUser(cafeId);
	}
	
	// 게시글 ID로 단일 게시글 + 작성자 정보 조회
	@Override
	public BoardWithUserDTO findBoardByIdWithUser(Long boardId) {
		return boardMapper.findBoardByIdWithUser(boardId);
	}

	// 게시글 작성
	@Override
	public void createBoard(BoardDTO board, MultipartFile imageFile) throws Exception{
		if(imageFile != null && !imageFile.isEmpty()) {
			String imageUrl = s3Uploader.upload(imageFile, "board");
			board.setBoardPictureUrl(imageUrl);
		}
		
		boardMapper.createBoard(board);
	}

	// 게시글 수정
	@Override
	public void updateBoard(BoardDTO board, MultipartFile imageFile) throws Exception{
		if(imageFile != null && !imageFile.isEmpty()) {
			String imageUrl = s3Uploader.upload(imageFile, "board");
			board.setBoardPictureUrl(imageUrl);
		}
		
		boardMapper.updateBoard(board);
	}

	// 게시글 삭제
	@Override
	public void deleteBoard(Long boardId) {
		// 게시글 정보 조회해서 이미지 URL 확보
		BoardDTO board = boardMapper.findBoardById(boardId);
		String boardPictureUrl = board.getBoardPictureUrl();
		
		// DB 삭제
		boardMapper.deleteBoard(boardId);
				
		// 이미지가 있으면 S3에서도 삭제
		if(board != null && boardPictureUrl != null && !boardPictureUrl.isEmpty()) {
			try {
				// S3Uploader 가 URL을 받아 내부에서 key 추출 후 삭제함
				s3Uploader.delete(boardPictureUrl);
			}catch (Exception e){
                // 이미지가 남아도 서비스 동작엔 영향 없게 로그만
                System.err.println("S3 이미지 삭제 실패: " + e.getMessage());
			}
		}
	}
	
	// 페이징 처리된 카페별 게시글 목록 조회
	@Override
	public List<BoardWithUserDTO> findBoardListWithPaging(Long cafeId, int page, int size) {
		int offset = page * size;
		return boardMapper.findBoardListWithPaging(cafeId, offset, size);
	}
	
	// 카페별 전체 게시글 수 조회
	@Override
	public int getTotalBoardCount(Long cafeId) {
		return boardMapper.getTotalBoardCount(cafeId);
	}
}