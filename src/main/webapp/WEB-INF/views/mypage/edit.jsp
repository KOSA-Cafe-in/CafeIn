<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회원정보 수정</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
  <%@ include file="/WEB-INF/views/common/head.jsp" %>
  <style>
  	:root{
      --paper:#ffffff;
      --line:#ececec;
      --text:#222;
      --muted:#9b9b9b;
      --accent:#b77448; /* 하단 마이 아이콘 색감 */
      --input-placeholder:#9c7a66;
    }
    /* 본문 */
    .content{ padding:22px 18px 120px; }
    .field-title{ font-size:22px; font-weight:800; margin:8px 0 16px; }

    .input-card{
      background:var(--paper);
      border-radius:18px;
      padding:14px 16px;
      box-shadow:0 1px 0 var(--line) inset;
      border:1px solid var(--line);
    }
    .input{
      width:100%; border:none; outline:none; font-size:18px; padding:10px 2px;
      background:transparent; color:var(--text);
    }
    .input::placeholder{ color:var(--input-placeholder); }

    /* 저장 버튼 (하단 고정) */
    .cta{
      position:fixed; left:0; right:0; bottom:74px; /* 탭바 위로 띄움 */
      display:flex; justify-content:center;
    }
    .btn{
      width:min(380px, 86%);
      padding:14px 16px; border:none; border-radius:14px;
      font-size:16px; font-weight:700; cursor:pointer;
      background:#222; color:#fff;
      box-shadow:0 4px 14px rgba(0,0,0,.12);
    }
    .btn:disabled{ opacity:.6; cursor:not-allowed }
    </style>
</head>
<body>
  <div class="phone">

    <!-- 헤더 include -->
    <jsp:include page="/WEB-INF/views/common/header.jsp">
      <jsp:param name="backLink" value="true" />
      <jsp:param name="title" value="회원정보 수정" />
      <jsp:param name="showOrderHistory" value="false" />
    </jsp:include>

    <!-- 본문 -->
    <main class="content">
		<h2 class="field-title">닉네임</h2>		
	    <form id="nicknameForm" method="post" action="/mypage/updateNickname">
	      <!-- Spring Security CSRF 사용 시 -->
	      <c:if test="${not empty _csrf}">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	      </c:if>
	
	      <div class="input-card">
	        <input
	          class="input"
	          type="text"
	          id="nickname"
	          name="nickname"
	          value="${user.nickname}"
	          placeholder="기존 닉네임"
	          maxlength="20"
	          autocomplete="off"
	          required
	        />
	      </div>
	      
		  <!-- 저장 버튼 -->
		  <div class="cta">
		    <button class="btn" form="nicknameForm" type="submit">수정 완료</button>
		  </div>
	    </form>
	  </section>
		<!-- 성공 메시지 표시 -->
		<c:if test="${param.success == 'true'}">
		    <div class="success-message">
		        프로필이 성공적으로 수정되었습니다!
		    </div>
		</c:if>

    </main>
  </div>

	<script>

	</script>
</body>
</html>
