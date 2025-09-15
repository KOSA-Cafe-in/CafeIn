<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>로그인 - ${cafe.name}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
   <%@ include file="/WEB-INF/views/common/head.jsp" %>
      <style>                   
        .logo-section {
            margin-top: 120px;
            text-align: center;
        }
        
        .logo {
            border-radius: 50%;
        }
                        
        .cafe-name {
        	display:flex;
        	justify-content: center;
        	flex: 1;
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-top: 30px;
            margin-bottom: 200px;
            text-align: center;
        }
        
        .login-section {
            width: 100%;
            padding: 0 20px;
            margin-bottom: 20px;
        }
        
        .kakao-login-btn {
            width: 100%;
            height: 56px;
            background-color: #FEE500;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: bold;
            color: #000;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            transition: background-color 0.2s;
        }
        
        .kakao-login-btn:hover {
            background-color: #e6cf00;
        }
        
        .kakao-login-btn:active {
            transform: translateY(1px);
        }
        
        .app-name {
            text-align: center;
            font-size: 24px;
            color: #666;
            font-weight: normal;
            letter-spacing: 2px;
            margin-bottom: 20px;
        }              
    </style>
</head>
<body>
    <div class="phone">        
    
        <!-- 로고 섹션 -->
        <div class="logo-section">
           <img class="logo" src="${cafe.logoUrl}" alt="카페 로고">
        </div>
        <div class="cafe-name">${cafe.name}</div>
        
        <!-- 로그인 섹션 -->
        <div class="login-section">
                <button type="submit" class="kakao-login-btn">
                    카카오 소셜로그인
                </button>
        </div>
        
        <!-- 앱 이름 -->
        <div class="app-name">Cafe in</div>
    </div>

    <script>
    	// URL에서 파라미터를 읽는 함수
    	function getUrlParameter(name){
    		const urlParams = new URLSearchParams(window.location.search);
    		return urlParams.get(name);
    	}
    	
        // 카카오 로그인 버튼 클릭 이벤트
        document.querySelector('.kakao-login-btn').addEventListener('click', function(e) {
            e.preventDefault();
            
            // 현재 URL에서 cafeId 파라미터 읽기
            const cafeId = getUrlParameter('cafeId');
            
            // cafeId가 있으면 파라미터로 전달
            let loginUrl = '${pageContext.request.contextPath}/kakao/login';
            if(cafeId){
            	loginUrl +='?cafeId=' + cafeId ;
            }
            
            // 컨트롤러로 리다이렉트
    		window.location.href = loginUrl;            
        });
        
    </script>
</body>
</html>
