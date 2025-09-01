package com.cafein.security.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import com.cafein.domain.user.UserDTO;

import lombok.Getter;
import lombok.extern.log4j.Log4j;

@Log4j
@Getter
public class CustomUser  extends User{
	
	//Serialization
	private static final long serialVersionUID = 1L;
	
	private UserDTO user;
	
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}//end CustomUser...
	
	public CustomUser(UserDTO vo) {
		
		super("user"
	         ,"password"
			 ,vo.getAuthList()
			  .stream()
			  .map( auth -> new SimpleGrantedAuthority(auth.getAuth()))
			  .collect(Collectors.toList())				
		);//end super
		
		this.user = vo;
	    
		
		log.info(vo);
	}//end CustomUser

}//end class

