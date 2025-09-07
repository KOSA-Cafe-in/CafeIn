package com.cafein.login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login(@RequestParam("cafeId") Long cafeId) {
	    System.out.println("카페 ID: " + cafeId);
	 // cafeId 값이 있으면 처리, 없으면 null
    	return "login"; // /WEB-INF/views/login.jsp
    }
}