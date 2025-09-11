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
	
	// 게시글 조회
    @GetMapping("/board")
    public String board(HttpSession session, Model model,
                       @RequestParam(defaultValue = "0") int page,
                       @RequestParam(defaultValue = "10") int size) {
    	// 세션에서 현재 로그인 사용자 정보 가져오기
    	Long userCafeId = (Long) session.getAttribute("userCafeId");
    	Long cafeId = (Long) session.getAttribute("cafeId");
    	int offset = page * size;

    	if(userCafeId == null) {
    		return "redirect:/login?cafeId=" + cafeId; // 로그인 안됨
    	}
    	    	
    	// userCafeId로 사용자 정보 조회
    	UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
    	UserDTO user = userService.findUserById(userCafe.getUserId());
    	CafeDTO cafe = cafeService.findCafeById(userCafe.getCafeId());
    	List<BoardWithUserDTO> boardList = boardService.findBoardListWithPaging(cafeId,offset,size);
    	
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