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
			<jsp:param name="title" value="메뉴" />
			<jsp:param name="showOrderHistory" value="false" />
		</jsp:include>


		<jsp:include page="/WEB-INF/views/common/cartBar.jsp" />

		<!-- 본문 -->
		<main class="content"> <!-- 공지 -->
		<section class="notice" aria-label="가게 공지">
			<span class="icon">🔔</span>
			<div class="msg collapsed" id="noticeMsg">${content}</div>
			<div class="intro-actions">
		      <button id="btn-more" class="icon-button" onclick="toggleNotice()"><i class="fa-solid fa-angle-down"></i></button>
		    </div>
		</section>

		<!-- 메뉴 목록 -->
		<h2 class="section-title">메뉴</h2>
		<div class="list">
			<c:forEach var="menu" items="${menuList}">
				<article class="card" onclick="goToMenuDetail(${menu.menuId})"
					style="cursor: pointer;">
					<!-- 썸네일 -->
					<img src="${menu.menuPictureUrl}" alt="${menu.name}"
						class="menu-img" />
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

	<style>
.home-wrap {
	max-width: 560px;
	margin: 0 auto;
	padding: 16px;
}

.title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 12px;
	text-align: center;
}

.cafe-intro {
	background: #f9f9f9;
	border-radius: 12px;
	padding: 12px;
	margin-bottom: 16px;
	position: relative;
}

#intro-text {
	font-size: 14px;
	margin: 0;
	white-space: pre-wrap;
}

.intro-actions {
	margin-top: 6px;
	display: flex;
	justify-content: flex-end;
	gap: 8px;
}

.icon-button {
	background: none;
	border: none;
	font-size: 14px;
	cursor: pointer;
}

.menu-actions {
	text-align: right;
	margin-bottom: 16px;
}

.menu-add-btn {
	padding: 8px 16px;
	background: #2e6cff;
	color: #fff;
	text-decoration: none;
	border-radius: 8px;
}

.menu-list {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.menu-item {
	display: flex;
	gap: 12px;
	border: 1px solid #eee;
	border-radius: 10px;
	padding: 10px;
}

.menu-img {
	width: 72px;
	height: 72px;
	object-fit: cover;
	border-radius: 8px;
	background: #ddd;
}

.menu-info h3 {
	margin: 0;
	font-size: 16px;
}

.menu-info p {
	margin: 4px 0;
	font-size: 14px;
	color: #666;
}
.clamp-1 {
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.notice .msg {
	transition: all 0.3s ease;
}

.notice .msg.collapsed {
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.notice .msg.expanded {
	display: block;
}

#intro-textarea {
	width: 100%;
	height: 84px;
	resize: none !important;
	overflow: auto;
	box-sizing: border-box;
}

.intro-counter {
	font-size: 12px;
	color: #999;
	text-align: right;
	margin: 4px 0 8px;
}

.menu-clickable {
	cursor: pointer;
	position: relative;
}

.menu-arrow {
	margin-left: auto;
	align-self: center;
	font-size: 18px;
	opacity: .7;
}
</style>

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
    
    // 공지사항 더보기/접기 토글 함수
    function toggleNotice() {
      const noticeMsg = document.getElementById('noticeMsg');
      const btnMore = document.getElementById('btn-more');
      
      if (noticeMsg.classList.contains('collapsed')) {
        // 펼치기
        noticeMsg.classList.remove('collapsed');
        noticeMsg.classList.add('expanded');
        btnMore.innerHTML = '<i class="fa-solid fa-angle-up"></i>';
      } else {
        // 접기
        noticeMsg.classList.remove('expanded');
        noticeMsg.classList.add('collapsed');
        btnMore.innerHTML = '<i class="fa-solid fa-angle-down"></i>';
      }
    }
    
    // 페이지 로드 시 공지사항이 1줄을 넘는지 확인하고 더보기 버튼 표시 여부 결정
    document.addEventListener('DOMContentLoaded', function() {
      const noticeMsg = document.getElementById('noticeMsg');
      const btnMore = document.getElementById('btn-more');
      
      // 임시로 expanded 상태로 만들어서 실제 높이 측정
      noticeMsg.classList.remove('collapsed');
      noticeMsg.classList.add('expanded');
      const fullHeight = noticeMsg.scrollHeight;
      
      // 다시 collapsed 상태로 되돌림
      noticeMsg.classList.remove('expanded');
      noticeMsg.classList.add('collapsed');
      const collapsedHeight = noticeMsg.scrollHeight;
      
      btnMore.style.display = 'block';
     
    });
  </script>
</body>
</html>
