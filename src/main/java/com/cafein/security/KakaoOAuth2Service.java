package com.cafein.security;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@PropertySource("classpath:application.properties")
public class KakaoOAuth2Service {
	@Value("${kakao.client.id}")
    private String clientId;
	
	@Value("${kakao.client.secret}")
    private String clientSecret;
	
	@Value("${kakao.redirect.uri}")
    private String redirectUri;
	
	@Value("${kakao.auth.url}")
    private String authUrl;
	
	@Value("${kakao.token.url}")
    private String tokenUrl;
	
	@Value("${kakao.user.url}")
    private String userUrl;    
    
    public String getAuthorizationRedirectUrl(Long cafeId) {
    	String url = authUrl + "?client_id=" + clientId
                + "&redirect_uri=" + redirectUri
                + "&response_type=code"
                + "&scope=profile_nickname,account_email"
                + "&state=" + cafeId;
    	
        return url;
    }
    
    public Map<String, Object> getAccessToken(String code) {
        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);

        ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, new HttpEntity<>(params, new HttpHeaders()), Map.class);
        return response.getBody();
    }

    public Map<String, Object> getUserInfo(String accessToken) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        ResponseEntity<Map> response = restTemplate.exchange(userUrl, HttpMethod.GET, new HttpEntity<>(headers), Map.class);
        return response.getBody();
    }
}
