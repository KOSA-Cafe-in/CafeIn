package com.cafein.board;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.cafe.CafeDTO;
import com.cafein.cafe.CafeService;
import com.cafein.user.UserDTO;
import com.cafein.user.UserService;
import com.cafein.usercafe.UserCafeDTO;
import com.cafein.usercafe.UserCafeService;

// 게시판 컨트롤러 (담당 : 나규태)
@Controller
public class BoardController {
	@Autowired
	private UserCafeService userCafeService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CafeService cafeService;
	
	@Autowired
	private BoardService boardService;
	
	/**
     * 게시판 메인 페이지
     * @param session 사용자 세션
     * @param model 뷰에 전달할 데이터
     * @param page 페이지 번호 (기본값: 0)
     * @param size 페이지 크기 (기본값: 10)
     * @return 게시판 JSP 페이지
     */
    @GetMapping("/board")
    public String board(HttpSession session, Model model,
                       @RequestParam(defaultValue = "0") int page,
                       @RequestParam(defaultValue = "10") int size) {
    	// 세션에서 현재 로그인 사용자 정보 가져오기
    	Long userCafeId = (Long) session.getAttribute("userCafeId");
    	Long cafeId = (Long) session.getAttribute("cafeId");
    	int offset = page * size;	// 페이지 오프셋 계산

		// 로그인 체크
    	if(userCafeId == null) {
    		return "redirect:/login?cafeId=" + cafeId; // 로그인 안됨
    	}
    	    	
    	// 사용자, 카페, 게시글 정보 조회
    	UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
    	UserDTO user = userService.findUserById(userCafe.getUserId());
    	CafeDTO cafe = cafeService.findCafeById(userCafe.getCafeId());
    	List<BoardWithUserDTO> boardList = boardService.findBoardListWithPaging(cafeId,offset,size);
    	
		// 뷰에 데이터 전달
    	model.addAttribute("user", user);
    	model.addAttribute("cafe", cafe);
    	model.addAttribute("userCafe", userCafe);
    	model.addAttribute("board", boardList);
    	model.addAttribute("cafeId", cafeId);
    	model.addAttribute("currentPage", page);
    	model.addAttribute("pageSize", size);
    
    	return "board/board"; 
    }    
}