<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>토스 카페</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta name="theme-color" content="#ffffff"/>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* 홈페이지 전용 스타일 */
        :root{
            --tc-primary:#2f76ff;
            --tc-text:#111827;
            --tc-muted:#6b7280;
            --tc-line:#e5e7eb;
        }

        .home-container {
            max-width: 420px;
            min-height: 100dvh;
            margin: 0 auto;
            background: #fff;
            padding: 16px;
        }

        .home-title {
            font-size: 24px;
            font-weight: 800;
            margin: 20px 0;
            color: var(--tc-text);
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-top: 20px;
        }

        .menu-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
            border: none;
            padding: 0;
            width: 100%;
        }

        .menu-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }

        .menu-image {
            width: 100%;
            height: 120px;
            background: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: var(--tc-muted);
        }

        .menu-info {
            padding: 12px;
            text-align: left;
        }

        .menu-name {
            font-size: 16px;
            font-weight: 700;
            margin: 0 0 4px 0;
            color: var(--tc-text);
        }

        .menu-description {
            font-size: 12px;
            color: var(--tc-muted);
            margin: 0 0 8px 0;
            line-height: 1.4;
        }

        .menu-price {
            font-size: 14px;
            font-weight: 700;
            color: var(--tc-primary);
        }

        .category-badge {
            display: inline-block;
            background: var(--tc-primary);
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 600;
            margin-bottom: 8px;
        }
    </style>
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
      <article class="card" onclick="goToMenuDetail(0)" style="cursor: pointer;">
        <div class="stack">
          <span class="eyebrow">네이버 리뷰 이벤트</span>
          <div class="name">리뷰쓰고 마카롱 1개 받기</div>
          <div class="price">0원</div>
          <p class="desc">이벤트에 참여해주시면 직원이 리뷰작성용 영수증을 가져다드려요.</p>
        </div>
        <button class="plus" aria-label="이벤트 담기" onclick="event.stopPropagation(); addToCart(0);">+</button>
      </article>

      <!-- 샌드위치 -->
      <h2 class="section-title">샌드위치</h2>
      <div class="list">

        <article class="card" onclick="goToMenuDetail(1)" style="cursor: pointer;">
          <div class="stack">
            <div class="badges">
              <span class="badge best">인기</span>
            </div>
            <div class="name">루꼴라 크로와상 샌드위치</div>
            <div class="price">7,500원</div>
            <p class="desc">크림치즈, 햄, 토마토, 루꼴라, 로메인이 들어간 건강한 샌드위치</p>
          </div>
          <button class="plus" aria-label="루꼴라 크로와상 샌드위치 담기" onclick="event.stopPropagation(); addToCart(1);">+</button>
        </article>

        <article class="card" onclick="goToMenuDetail(2)" style="cursor: pointer;">
          <div class="stack">
            <div class="badges">
              <span class="badge hot">신규</span>
            </div>
            <div class="name">햄치즈 통밀 샌드위치</div>
            <div class="price">7,000원</div>
            <p class="desc">건강한 통밀빵에 햄, 치즈, 신선한 야채가 듬뿍 들어간 담백한 샌드위치</p>
          </div>
          <button class="plus" aria-label="햄치즈 통밀 샌드위치 담기" onclick="event.stopPropagation(); addToCart(2);">+</button>
        </article>

      </div>

      <div class="divider"></div>

      <!-- 커피 -->
      <h2 class="section-title">커피</h2>
      <article class="card" onclick="goToMenuDetail(3)" style="cursor: pointer;">
        <div class="stack">
          <div class="name">메뉴 준비중</div>
          <p class="desc">커피 메뉴가 곧 업데이트 됩니다.</p>
        </div>
        <button class="plus" aria-label="담기" onclick="event.stopPropagation(); addToCart(3);">+</button>
      </article>

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
        window.location.href = '/menu/' + menuId;
      }
    }

    // 장바구니에 담기 함수 (+ 버튼 클릭 시)
    function addToCart(menuId) {
      alert('장바구니에 담겼습니다. (데모)');
      // 실제 구현시에는 여기서 서버로 장바구니 추가 요청을 보낼 수 있습니다.
      console.log('메뉴 ID ' + menuId + '가 장바구니에 추가되었습니다.');
    }
  </script>
</body>
</html>
