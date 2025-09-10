<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>토스 카페</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, viewport-fit=cover" />
<meta name="theme-color" content="#ffffff" />
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/cartUtils.jsp"%>
</head>
<body>
	<div class="phone">

		<!-- 헤더 include -->
<jsp:include page="/WEB-INF/views/common/header.jsp">
        	<jsp:param name="backLink" value="false" />
            <jsp:param name="title" value="메뉴" />
            <jsp:param name="showOrderHistory" value="false" />
        </jsp:include>


		<jsp:include page="/WEB-INF/views/common/cartBar.jsp" />

		<!-- 본문 -->
		<main class="content"> <!-- 공지 -->
		<section class="notice" aria-label="가게 공지">
			<span class="icon">🔔</span>
			<div class="msg">1인당 1메뉴 부탁드려요 :)</div>
			<span class="chev">▾</span>
		</section>

		<!-- 메뉴 목록 -->
		<h2 class="section-title">메뉴</h2>
		<div class="list">
			<c:forEach var="menu" items="${menuList}">
				<article class="card" onclick="goToMenuDetail(${menu.menuId})"
					style="cursor: pointer;">
					<div class="stack">
						<div class="name">${menu.name}</div>
						<div class="price">${menu.price}원</div>
						<p class="desc">${menu.content}</p>
					</div>
					<button class="plus" aria-label="${menu.name} 담기"
						onclick="event.stopPropagation();
           cartAdd({menuId:${menu.menuId}, name:'${menu.name}', price:${menu.price}, qty:1}); /* ★ price는 3500 처럼 숫자 */
           updateCartBar();">+</button>
				</article>
			</c:forEach>
		</div>

		</main>

		<!-- 하단 네비게이션 include -->
		<jsp:include page="/WEB-INF/views/common/nav.jsp">
			<jsp:param name="active" value="home" />
		</jsp:include>

	</div>

	<script>
    // 메뉴 상세페이지로 이동하는 함수
    function goToMenuDetail(menuId) {
      if (menuId !== undefined && menuId !== null) {
        window.location.href = '/menu/detail/' + menuId;
      }
    }

    // 장바구니에 담기 함수 (+ 버튼 클릭 시)
    function addToCart(menuId) {
      alert('장바구니에 담겼습니다. (메뉴 ID: ' + menuId + ')');
    }
  </script>
</body>
</html>
