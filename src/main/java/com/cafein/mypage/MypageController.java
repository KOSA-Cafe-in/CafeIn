package com.cafein.mypage;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cafein.cafe.CafeDTO;
import com.cafein.cafe.CafeService;
import com.cafein.user.UserDTO;
import com.cafein.user.UserService;
import com.cafein.usercafe.UserCafeDTO;
import com.cafein.usercafe.UserCafeService;
import com.cafein.order.OrderService;   // ✅ 추가

@Controller
public class MypageController {

    @Autowired
    private UserCafeService userCafeService;

    @Autowired
    private UserService userService;

    @Autowired
    private CafeService cafeService;

    @Autowired
    private OrderService orderService;   // ✅ 추가: 음료 총 수량 계산용

    // 마이페이지 조회
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        // 세션에서 현재 로그인 사용자 정보 가져오기
        Long userCafeId = (Long) session.getAttribute("userCafeId");
        Long cafeId = (Long) session.getAttribute("cafeId");

        if (userCafeId == null) {
            return "redirect:/login?cafeId=" + cafeId; // 로그인 안됨
        }

        // userCafeId로 사용자 정보 조회
        UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
        UserDTO user = userService.findUserById(userCafe.getUserId());
        CafeDTO cafe = cafeService.findCafeById(userCafe.getCafeId());

        model.addAttribute("user", user);
        model.addAttribute("cafe", cafe);
        model.addAttribute("userCafe", userCafe);

        // ✅ 추가: 스탬프/쿠폰 계산 (총 음료수 = OrderItem.count 합계)
        // OrderService에 sumDrinkCountByUserAndCafe(userId, cafeId) 메서드가 존재해야 합니다.
        int totalDrinks = orderService.sumDrinkCountByUserAndCafe(user.getUserId(), cafe.getCafeId());
        int stampCount  = totalDrinks % 10;   // 현재 찍혀있는 스탬프(0~9)
        int couponCount = totalDrinks / 10;   // 누적 쿠폰 수(정수)

        model.addAttribute("stampCount", stampCount);
        model.addAttribute("couponCount", couponCount);

        return "mypage/mypage";
    }

    // 수정 페이지 조회
    @GetMapping("/mypage/edit")
    public String mypageEdit(HttpSession session, Model model) {
        Long userCafeId = (Long) session.getAttribute("userCafeId");
        Long cafeId = (Long) session.getAttribute("cafeId");

        if (userCafeId == null) {
            return "redirect:/login?cafeId=" + cafeId; // 로그인 안됨
        }

        UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
        UserDTO user = userService.findUserById(userCafe.getUserId());

        model.addAttribute("user", user);

        return "mypage/edit";
    }

    @PostMapping("/mypage/updateNickname")
    public String updateNickname(HttpSession session, @RequestParam("nickname") String nickname) {
        Long userCafeId = (Long) session.getAttribute("userCafeId");
        Long cafeId = (Long) session.getAttribute("cafeId");

        if (userCafeId == null) {
            return "redirect:/login?cafeId=" + cafeId; // 로그인 안됨
        }

        UserCafeDTO userCafe = userCafeService.findUserCafeById(userCafeId);
        userService.updateUserNickname(userCafe.getUserId(), nickname);

        return "redirect:/mypage";
    }
}
