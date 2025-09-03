<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />


  <title>토스 카페 - ${menu.name}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <%@ include file="/WEB-INF/views/common/head.jsp" %>

  <style>
    /* 페이지 전용 스타일 */
    :root{
      --tc-primary:#2f76ff;
      --tc-text:#111827;
      --tc-muted:#6b7280;
      --tc-line:#e5e7eb;
    }
    .md-phone{max-width:420px;min-height:100dvh;margin:0 auto;background:#fff;display:flex;flex-direction:column}
    .md-hero{width:100%;aspect-ratio:16/10;background:#f3f4f6;display:flex;align-items:center;justify-content:center;color:var(--tc-muted);font-size:14px}
    .md-content{padding:16px}
    .md-title{font-size:18px;font-weight:800;margin:6px 0 8px}
    .md-desc{font-size:13px;color:var(--tc-muted);line-height:1.5;margin:0 0 16px}
    .md-row{display:flex;align-items:center;justify-content:space-between;gap:12px}
    .md-price{font-size:18px;font-weight:800;letter-spacing:.2px}
    .md-stepper{display:inline-flex;align-items:center;gap:8px;background:#f3f4f6;border-radius:12px;padding:4px}
    .md-stepper button{width:36px;height:36px;border:0;border-radius:10px;background:#fff;box-shadow:0 1px 0 rgba(0,0,0,.04) inset;display:grid;place-items:center;font-size:18px;cursor:pointer}
    .md-stepper button:disabled{opacity:.45;cursor:not-allowed}
    .md-stepper .count{width:28px;text-align:center;font-weight:700}
    .md-cta{position:sticky;bottom:0;z-index:20;padding:12px 16px calc(12px + env(safe-area-inset-bottom));background:linear-gradient(180deg,rgba(255,255,255,0),rgba(255,255,255,1) 40%);margin-top:8px}
    .md-cta .btn{width:100%;height:52px;border:0;border-radius:14px;background:var(--tc-primary);color:#fff;font-weight:800;font-size:16px;display:flex;align-items:center;justify-content:center;gap:10px;box-shadow:0 6px 12px rgba(47,118,255,.22);cursor:pointer}
    .md-back{position:absolute;top:16px;left:16px;width:36px;height:36px;background:rgba(255,255,255,0.9);border:0;border-radius:50%;display:grid;place-items:center;cursor:pointer;backdrop-filter:blur(10px)}
    .md-category{display:inline-block;background:var(--tc-primary);color:white;padding:4px 8px;border-radius:6px;font-size:12px;font-weight:600;margin-bottom:8px}
  </style>
</head>
<body>
  <div class="md-phone">
    <div style="position:relative">
      <div class="md-hero">
        <c:choose>
          <c:when test="${not empty menu.menuPictureUrl}">
            <img src="${menu.menuPictureUrl}" alt="${menu.name}" style="width:100%;height:100%;object-fit:cover;" />
          </c:when>
          <c:otherwise>
            이미지 준비중
          </c:otherwise>
        </c:choose>
      </div>
      <button class="md-back" onclick="history.back()">←</button>
    </div>

    <div class="md-content">
      <span class="md-category">메뉴</span>
      <h1 class="md-title">${menu.name}</h1>
      <p class="md-desc">${menu.content}</p>

      <div class="md-row">
        <span class="md-price"><fmt:formatNumber value="${menu.price}" type="number" pattern="#,###" />원</span>
        <div class="md-stepper">
          <button type="button" onclick="changeQuantity(-1)">−</button>
          <span class="count" id="quantity">1</span>
          <button type="button" onclick="changeQuantity(1)">+</button>
        </div>
      </div>
    </div>

    <div class="md-cta">
      <button class="btn" onclick="addToCart()">
        <span id="totalPrice"><fmt:formatNumber value="${menu.price}" type="number" pattern="#,###" />원</span>
        담기
      </button>
    </div>
  </div>

  <script>
    let quantity = 1;
    const menuPrice = ${menu.price};

    function changeQuantity(delta) {
      const newQuantity = quantity + delta;
      if (newQuantity >= 1 && newQuantity <= 99) {
        quantity = newQuantity;
        document.getElementById('quantity').textContent = quantity;
        updateTotalPrice();
      }
    }

    function updateTotalPrice() {
      const totalPrice = menuPrice * quantity;
      document.getElementById('totalPrice').textContent =
        new Intl.NumberFormat('ko-KR').format(totalPrice) + '원';
    }

    function addToCart() {
      alert(`${quantity}개가 장바구니에 담겼습니다.`);
      // 여기에 실제 장바구니 추가 로직 구현
    }
  </script>
</body>
</html>
