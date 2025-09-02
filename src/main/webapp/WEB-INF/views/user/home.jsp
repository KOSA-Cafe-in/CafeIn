<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>토스 카페</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
  <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>
  <div class="phone">

    <!-- 헤더 include -->
    <jsp:include page="/WEB-INF/views/common/header.jsp">
      <jsp:param name="title" value="메뉴" />
      <jsp:param name="showOrderHistory" value="true" />
    </jsp:include>

    <!-- 본문 -->
    <main class="content">

      <!-- 공지 -->
      <section class="notice" aria-label="가게 공지">
        <span class="icon">🔔</span>
        <div class="msg">1인당 1메뉴 부탁드려요 :)</div>
        <span class="chev">▾</span>
      </section>

      <!-- 이벤트 -->
      <h2 class="section-title">이벤트</h2>
      <article class="card">
        <div class="stack">
          <span class="eyebrow">네이버 리뷰 이벤트</span>
          <div class="name">리뷰쓰고 마카롱 1개 받기</div>
          <div class="price">0원</div>
          <p class="desc">이벤트에 참여해주시면 직원이 리뷰작성용 영수증을 가져다드려요.</p>
        </div>
        <button class="plus" aria-label="이벤트 담기">+</button>
      </article>

      <!-- 샌드위치 -->
      <h2 class="section-title">샌드위치</h2>
      <div class="list">

        <article class="card">
          <div class="stack">
            <div class="badges">
              <span class="badge best">인기</span>
            </div>
            <div class="name">루꼴라 크로와상 샌드위치</div>
            <div class="price">7,500원</div>
            <p class="desc">크림치즈, 햄, 토마토, 루꼴라, 로메인이 들어간 건강한 샌드위치</p>
          </div>
          <button class="plus" aria-label="루꼴라 크로와상 샌드위치 담기">+</button>
        </article>

        <article class="card">
          <div class="stack">
            <div class="badges">
              <span class="badge hot">신규</span>
            </div>
            <div class="name">햄치즈 통밀 샌드위치</div>
            <div class="price">7,000원</div>
            <p class="desc">건강한 통밀빵에 햄, 치즈, 신선한 야채가 듬뿍 들어간 담백한 샌드위치</p>
          </div>
          <button class="plus" aria-label="햄치즈 통밀 샌드위치 담기">+</button>
        </article>

      </div>

      <div class="divider"></div>

      <!-- 커피 -->
      <h2 class="section-title">커피</h2>
      <article class="card">
        <div class="stack">
          <div class="name">메뉴 준비중</div>
          <p class="desc">커피 메뉴가 곧 업데이트 됩니다.</p>
        </div>
        <button class="plus" aria-label="담기">+</button>
      </article>

    </main>
    
    <!-- 하단 네비게이션 include -->
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
      <jsp:param name="active" value="home" />
    </jsp:include>

  </div>

  <script>
    // 데모용: + 버튼 클릭 시 알림
    document.querySelectorAll('.plus').forEach(btn=>{
      btn.addEventListener('click', ()=> alert('장바구니에 담겼습니다. (데모)'));
    });
  </script>
</body>
</html>
