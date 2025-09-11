<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    .stamp{
      width:100%; aspect-ratio:1/1;
      display:flex; align-items:center; justify-content:center;
      border-radius:12px;
      background:#fff;
      box-shadow:0 2px 8px rgba(0,0,0,.06);
      overflow:hidden;
    }
    .stamp img{
      width:128%; height:128%;   /* 2배 확대 */
      object-fit:contain;
      filter: grayscale(100%) brightness(0.8);
      opacity:.55;
      transition: filter .2s ease, opacity .2s ease, transform .2s ease;
    }
    .stamp.filled img{
      filter:none;
      opacity:1;
      transform: scale(1.02);
    }

    /* 쿠폰 정보 (스탬프 밑, 오른쪽 정렬, 검정 글씨) */
    .coupon-info{
      margin:10px 24px 0 0;
      text-align:right;
      font-size:13px;
      color:#000;
      font-weight:600;
    }

    /* 로그아웃 버튼 */
    .cta{
      position:fixed; left:0; right:0; bottom:74px;
      display:flex; justify-content:center;
    }
    .btn{
      width:min(380px, 86%);
      padding:12px 14px;
      border:none; border-radius:12px;
      font-size:15px; font-weight:700; cursor:pointer;
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

        <!-- ✅ 스탬프 영역 (CUSTOMER만 표시) -->
        <c:if test="${userCafe.role eq 'CUSTOMER'}">
	        <section class="stamp-wrap">
	          <!-- 컨트롤러에서 내려준 값 사용: stampCount(0~9), couponCount(정수) -->
	          <c:set var="filled" value="${empty stampCount ? 0 : stampCount}" />
	          <c:set var="coupons" value="${empty couponCount ? 0 : couponCount}" />
	
	          <div class="stamp-title">
	            스탬프 <span style="color:var(--muted); font-weight:600;">(<c:out value='${filled}'/>/10)</span>
	          </div>
	
	          <div class="card">
	            <div class="grid">
	              <c:forEach begin="1" end="10" var="i">
	                <div class="stamp ${i <= filled ? 'filled' : ''}">
	                  <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="stamp"/>
	                </div>
	              </c:forEach>
	            </div>
	          </div>
	
	          <!-- ✅ 스탬프 영역 아래, 오른쪽 정렬, 검정색 -->
	          <div class="coupon-info">쿠폰 총 갯수: <strong><c:out value='${coupons}'/></strong>개</div>
	        </section>
        </c:if>
      </section>

      <!-- 로그아웃 버튼 -->
      <form action="/logout" method="get" class="cta">
        <button type="submit" class="btn">로그아웃</button>
      </form>

    </main>
    
    <!-- 하단 네비게이션 include -->
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
      <jsp:param name="active" value="mypage" />
    </jsp:include>

  </div>
</body>
</html>
