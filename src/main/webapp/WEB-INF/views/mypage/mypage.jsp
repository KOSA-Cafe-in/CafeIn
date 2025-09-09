<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>마이페이지</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
  <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
    /* 정보 영역 */
    .section{padding:20px 20px 0 20px}
    .row{display:flex; align-items:center; justify-content:space-between; gap:12px; padding:14px 0}
    .label{font-size:18px; font-weight:700; margin-bottom:5px}
    .value{color:var(--muted)}
    .divider{height:1px; background:var(--line); margin:10px -20px}

    .btn-outline{
      display:inline-flex; align-items:center; gap:6px;
      padding:8px 12px; border:1px solid var(--line); border-radius:999px; background:#fff; cursor:pointer;
    }

    /* 스탬프 카드 */
    .stamp-wrap{padding:20px}
    .stamp-title{font-size:18px; font-weight:800; margin-bottom:6px}
    .stamp-sub{color:var(--muted); margin-bottom:14px}
    .card{
      background:var(--card);
      border-radius:28px;
      padding:24px;
      box-shadow: 0 6px 20px rgba(0,0,0,.06) inset;
    }
    .grid{
      display:grid;
      grid-template-columns: repeat(5, 1fr);
      gap:18px 16px;
    }

    /* 저장 버튼 (하단 고정) */
    .cta{
      position:fixed; left:0; right:0; bottom:74px; /* 탭바 위로 띄움 */
      display:flex; justify-content:center;
    }
    .btn{
      width:min(440px, 92%);
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
      <jsp:param name="title" value="마이페이지" />
      <jsp:param name="showOrderHistory" value="false" />
    </jsp:include>

    <!-- 본문 -->
    <main class="content">

      <!-- 닉네임 -->
	  <section class="section">
	    <div class="row">
	      <div>	        
	        <div class="label">
	          <c:out value="${user.nickname}"/>
	        </div>
	      </div>
	      <button class="btn-outline" onclick="location.href='/mypage/edit'">
	        🖊️ <span>변경</span>
	      </button>
	    </div>
	
	    <div class="row">
	      <div>
	        <div class="label">이메일</div>
	        <div class="value"><c:out value="${user.email}"/></div>
	      </div>
	    </div>

	    <div class="divider"></div>
	    
	      <!-- 스탬프 영역 -->
		  <section class="stamp-wrap">
		    <div class="stamp-title">스탬프</div>
		    <div class="stamp-sub">
		    	<c:out value="${cafe.name}"/>
		    </div>
				    
		  </section>
	  </section>

	  <!-- 저장 버튼 -->
	  <form action="/logout" method="get" class="cta">
	    <button type="submit" class="btn">로그아웃</button>
	  </form>

    </main>
    
    <!-- 하단 네비게이션 include -->
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
      <jsp:param name="active" value="mypage" />
    </jsp:include>

  </div>

	<script>

	</script>
</body>
</html>
