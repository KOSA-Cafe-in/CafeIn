package com.cafein.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import com.cafein.domain.user.UserDTO;
import com.cafein.mapper.UserMapper;
import com.cafein.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Setter(onMethod_ = {@Autowired})
	private UserMapper usermapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		log.warn("Load User By UserName :" +username);
		
		UserDTO dto = usermapper.read(username);		
		log.warn("Query by memebr maper :" + dto);
			
		//삼항식
		return  dto == null ? null 	: new CustomUser(dto) ;
	}//end loadUserByUsern...
	

}//end class

