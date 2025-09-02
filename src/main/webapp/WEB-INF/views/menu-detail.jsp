<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>토스 카페 - ${menu.menuName}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <%@ include file="/WEB-INF/views/common/head.jsp" %>

  <style>
    /* 페이지 전용 스타일 (공통 head.css와 충돌 없게 접두어 사용) */
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
        <!-- 이미지 플레이스홀더 -->
        이미지 준비중
      </div>
      <button class="md-back" onclick="history.back()">←</button>
    </div>

    <div class="md-content">
      <span class="md-category">${menu.category}</span>
      <h1 class="md-title">${menu.menuName}</h1>
      <p class="md-desc">${menu.description}</p>

      <div class="md-row">
        <div class="md-price">
          <fmt:formatNumber value="${menu.price}" pattern="#,###"/>원
        </div>
        <div class="md-stepper">
          <button type="button" onclick="decrease()">-</button>
          <span class="count" id="quantity">1</span>
          <button type="button" onclick="increase()">+</button>
        </div>
      </div>
    </div>

    <div class="md-cta">
      <button class="btn" onclick="addToCart()">
        <span id="cartText">장바구니 담기</span>
        <span id="totalPrice">
          <fmt:formatNumber value="${menu.price}" pattern="#,###"/>원
        </span>
      </button>
    </div>
  </div>

  <script>
    let quantity = 1;
    const basePrice = ${menu.price};

    function increase() {
      if (quantity < 99) {
        quantity++;
        updateDisplay();
      }
    }

    function decrease() {
      if (quantity > 1) {
        quantity--;
        updateDisplay();
      }
    }

    function updateDisplay() {
      document.getElementById('quantity').textContent = quantity;
      const totalPrice = basePrice * quantity;
      document.getElementById('totalPrice').textContent =
        totalPrice.toLocaleString() + '원';
    }

    function addToCart() {
      alert('장바구니에 ' + quantity + '개가 추가되었습니다!');
      // 실제 구현시에는 서버로 데이터를 전송하는 로직 추가
    }
  </script>
</body>
</html>
