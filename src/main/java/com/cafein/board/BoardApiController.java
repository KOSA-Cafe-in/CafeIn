package com.cafein.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/board")
public class BoardApiController {
	
	@Autowired
	private BoardService boardService;	
	
	// 카페 게시글 전체 조회 (GET /api/board?cafeId=1)
    @GetMapping
    public ResponseEntity<Map<String,Object>> getBoardList(@RequestParam Long cafeId){
    	Map<String, Object> response = new HashMap<>();
    	
    	try {
    		List<BoardDTO> boardList = boardService.findAllBoardList(cafeId);
    		response.put("success", true);
    		response.put("data", boardList);
    		response.put("count", boardList.size());
    	} catch(Exception e) {
    		response.put("success", false);
            response.put("message", "게시글 목록을 불러오는데 실패했습니다.");
            response.put("error", e.getMessage());
    	}
    	
    	return ResponseEntity.ok(response);
    }
    
    // 게시글 상세 조회	(GET /api/board/1)
    @GetMapping("/{boardId}")
    public ResponseEntity<Map<String,Object>> getBoardDetail(@PathVariable Long boardId){
    	Map<String, Object> response = new HashMap<>();
    	
        try {
            BoardDTO board = boardService.findBoardById(boardId);
            
            if (board != null) {
                response.put("success", true);
                response.put("data", board);
            } else {
                response.put("success", false);
                response.put("message", "게시글을 찾을 수 없습니다.");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "게시글을 불러오는데 실패했습니다.");
            response.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // 게시글 작성 (POST /api/board)
    @PostMapping
    public ResponseEntity<Map<String, Object>> createBoard(
    		@RequestParam("title") String title,
    		@RequestParam("content") String content,
    		@RequestParam(value = "image", required = false) MultipartFile imageFile, 
    		HttpSession session) {
    	Map<String,Object> response = new HashMap<>();
    	
    	try {
    		// 세션에서 사용자 정보 가져오기
    		Long userId = (Long) session.getAttribute("userId");
    		Long cafeId = (Long) session.getAttribute("cafeId");
    		
    		if(userId == null || cafeId == null) {
    			response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(401).body(response);
    		}
    		
    		// BoardDTO 객체 생성 및 설정
    		BoardDTO board = new BoardDTO();
    		board.setTitle(title);
    		board.setContent(content);
    		board.setUserId(userId);
    		board.setCafeId(cafeId);
    		
    		boardService.createBoard(board,imageFile);
    		
    		response.put("success", true);
    		response.put("message", "게시글을 작성되었습니다.");
    	} catch (Exception e){
            response.put("success", false);
            response.put("message", "게시글을 작성에 실패했습니다.");
            response.put("error", e.getMessage());
    	}
    	
    	return ResponseEntity.ok(response);
    }
    
    // 게시글 수정 (PATCH /api/board/1)
    @PatchMapping("/{boardId}")
    public ResponseEntity<Map<String, Object>> updateBoard(
            @PathVariable Long boardId,     		
            @RequestParam("title") String title,
    		@RequestParam("content") String content,
    		@RequestParam(value = "image", required = false) MultipartFile imageFile,
            HttpSession session) {
    	Map<String,Object> response = new HashMap<>();
    	
    	try {
    		// 권한 체크 : 작성자 본인만 수정 가능
    		Long userId = (Long) session.getAttribute("userId");
    		
    		if(userId == null) {
    			response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(401).body(response);
    		}
    		
    		// 기존 게시글 조회
    		BoardDTO existingBoard = boardService.findBoardById(boardId);
    		
            if (existingBoard == null) {
                response.put("success", false);
                response.put("message", "게시글을 찾을 수 없습니다.");
                return ResponseEntity.status(404).body(response);
            }
            
            // 작성자 권한 체크
            if (!existingBoard.getUserId().equals(userId)) {
                response.put("success", false);
                response.put("message", "수정 권한이 없습니다.");
                return ResponseEntity.status(403).body(response);
            }
            
            // 수정할 BoardDTO 객체 생성
            BoardDTO board = new BoardDTO();
            board.setBoardId(boardId);
            board.setTitle(title);
            board.setContent(content);

            boardService.updateBoard(board, imageFile);

    		response.put("success", true);
    		response.put("message", "게시글을 수정되었습니다.");
    	} catch (Exception e){
            response.put("success", false);
            response.put("message", "게시글 수정에 실패했습니다.");
            response.put("error", e.getMessage());
    	}
    	
    	return ResponseEntity.ok(response);
    }
    
    // 게시글 삭제 (DELETE /api/board/1)
    @DeleteMapping("/{boardId}")
    public ResponseEntity<Map<String, Object>> deleteBoard(@PathVariable Long boardId, HttpSession session) {
    	Map<String,Object> response = new HashMap<>();
    	
    	try {
    		// 권한 체크 : 작성자 본민만 삭제 가능
    		Long userId = (Long) session.getAttribute("userId");
    		String role = (String) session.getAttribute("role");
    		
    		if(userId == null) {
    			response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(401).body(response);
    		}
    		
    		// 기존 게시글 조회
    		BoardDTO existingBoard = boardService.findBoardById(boardId);
    		
            if (existingBoard == null) {
                response.put("success", false);
                response.put("message", "게시글을 찾을 수 없습니다.");
                return ResponseEntity.status(404).body(response);
            }
            
            // 권한 체크 : 작성자 본인이거나 관리자
            if (!existingBoard.getUserId().equals(userId) && !role.equals("MANAGER")) {
                response.put("success", false);
                response.put("message", "삭제 권한이 없습니다.");
                return ResponseEntity.status(403).body(response);
            }
            
            boardService.deleteBoard(boardId);
            
    		response.put("success", true);
    		response.put("message", "게시글이 삭제되었습니다.");
    	} catch (Exception e){
            response.put("success", false);
            response.put("message", "게시글을 삭제에 실패했습니다.");
            response.put("error", e.getMessage());
    	}
    	
    	return ResponseEntity.ok(response);
    }
}