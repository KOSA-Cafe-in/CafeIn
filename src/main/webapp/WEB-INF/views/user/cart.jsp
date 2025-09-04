<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>장바구니</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff" />
  <%@ include file="/WEB-INF/views/common/head.jsp" %>
  <style>
    :root{
      --bg:#f6f7fb; --card:#ffffff; --text:#111827; --muted:#6b7280; --primary:#2563eb;
      --primary-pressed:#1e40af; --line:#e5e7eb; --accent:#20c8c8; --pill:#f0f2f7;
      --shadow:0 6px 16px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box;}
    html,body{margin:0;padding:0;background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Apple SD Gothic Neo,Helvetica,Arial,"Noto Sans KR",sans-serif;color:var(--text);}
    .phone{max-width:420px;margin:0 auto;min-height:100dvh;display:flex;flex-direction:column;background:#fff}
    .header{display:flex;align-items:center;gap:10px;padding:14px 16px;border-bottom:1px solid var(--line);position:sticky;top:0;background:#fff;z-index:10}
    .back{font-size:20px;line-height:1;cursor:pointer}
    .title{font-weight:700;font-size:18px}
    .content{flex:1;overflow:auto;background:var(--bg);padding:12px 12px 120px}
    .cart{display:grid;gap:10px;margin:4px 0 8px}
    .item{background:var(--card);border-radius:18px;padding:14px 12px;box-shadow:var(--shadow);display:flex;align-items:center;justify-content:space-between}
    .item-left{min-width:0}
    .name{font-weight:600}
    .desc{margin-top:4px;color:var(--muted);font-size:13px}
    .price{margin-top:6px;color:var(--muted)}
    .remove{margin-left:8px;border:none;background:transparent;font-size:18px;color:#9ca3af;cursor:pointer}
    .qty{display:flex;align-items:center;gap:6px}
    .btn-qty{width:36px;height:36px;border-radius:12px;border:1px solid var(--line);background:#fff;font-size:20px;line-height:1;cursor:pointer}
    .count{min-width:24px;text-align:center;font-weight:700}
    .addmore{display:block;text-align:center;margin:8px auto 16px;color:#2563eb;text-decoration:none;font-weight:700}
    .option-group{display:grid;gap:10px;margin:10px 0 16px}
    .option{background:#fff;border:2px solid var(--line);border-radius:16px;padding:14px 12px;box-shadow:var(--shadow);display:flex;align-items:center;justify-content:space-between;cursor:pointer}
    .option.active{border-color:var(--accent);box-shadow:0 0 0 4px rgba(32,200,200,.12)}
    .opt-title{font-weight:700}
    .opt-sub{font-size:12px;color:var(--muted);margin-left:6px}
    .radio{width:22px;height:22px;border-radius:50%;border:2px solid var(--line);display:inline-block}
    .option.active .radio{border-color:var(--accent);box-shadow:inset 0 0 0 5px var(--accent)}
    .coupon-wrap{margin:4px 0 16px}
    .coupon-label{font-size:13px;color:var(--muted);margin-bottom:8px}
    .coupon-pill{display:flex;align-items:center;justify-content:space-between;background:var(--pill);border-radius:24px;padding:14px 16px;font-weight:700;cursor:pointer}
    .coupon-check{width:26px;height:26px;border-radius:50%;border:2px solid var(--line);display:flex;align-items:center;justify-content:center;background:#fff;font-size:16px}
    .coupon-pill.active .coupon-check{border-color:#10b981;box-shadow:inset 0 0 0 1000px #10b981;color:#fff}
    .buttons{position:sticky;bottom:0;background:linear-gradient(180deg, rgba(246,247,251,0) 0%, var(--bg) 40%, var(--bg) 100%);padding:14px 12px 12px}
    .btn{width:100%;height:48px;border-radius:14px;border:0;cursor:pointer;font-size:16px;font-weight:700}
    .btn-outline{background:#e9eefb;color:#274472;margin-bottom:10px}
    .btn-primary{display:flex;align-items:center;justify-content:center;gap:10px;background:var(--primary);color:#fff}
    .btn-primary:active{background:var(--primary-pressed)}
    .badge{min-width:28px;height:28px;border-radius:999px;background:#fff;color:#2563eb;display:inline-flex;align-items:center;justify-content:center;font-weight:800}
    .nav{position:sticky;bottom:0;background:#fff;border-top:1px solid var(--line);display:flex;justify-content:space-around;padding:8px 0}
    .nav .dot{width:24px;height:24px;border-radius:8px;background:#e5e7eb}
    @media (min-width:421px){ .phone{border-left:1px solid var(--line);border-right:1px solid var(--line)} }
  </style>
</head>
<body>
<div class="phone">
  <!-- 헤더 -->
  <header class="header">
    <div class="back" onclick="history.back()">‹</div>
    <div class="title">장바구니</div>
  </header>

  <!-- 본문 -->
  <main class="content">
    <!-- 장바구니 아이템: 서버에서 menuId로 menufindID 쿼리로 조회한 결과를 cartItems로 전달 -->
    <!-- cartItems: List<CartItemDTO> (menuId, name, price, quantity, content 등) -->
    <section class="cart" id="cart">
      <c:forEach var="item" items="${cartItems}">
        <article class="item" data-price="${item.price}" data-menu-id="${item.menuId}">
          <div class="item-left">
            <div class="name">${item.name}</div>
            <c:if test="${not empty item.content}">
              <div class="desc">${item.content}</div>
            </c:if>
            <div class="price">
              <fmt:formatNumber value="${item.price}" type="number" />원
            </div>
          </div>
          <div class="qty">
            <button class="btn-qty" onclick="updateQty('${item.menuId}','DEC')">−</button>
            <div class="count">${item.quantity}</div>
            <button class="btn-qty" onclick="updateQty('${item.menuId}','INC')">+</button>
            <button class="remove" aria-label="삭제" onclick="removeItem('${item.menuId}')">✕</button>
          </div>
        </article>
      </c:forEach>
    </section>

    <a class="addmore" href="<c:url value='/menu/list'/>">메뉴 더 추가 +</a>

    <!-- 주문 유형: '픽업' 대신 '포장'으로 표시 -->
    <section class="option-group" id="orderType">
      <label class="option ${orderType eq 'TAKEOUT' ? 'active' : ''}" data-type="TAKEOUT">
        <div><span class="opt-title">포장</span><span class="opt-sub">12~14분</span></div>
        <span class="radio" aria-hidden="true"></span>
      </label>
      <label class="option ${orderType eq 'DINEIN' ? 'active' : ''}" data-type="DINEIN">
        <div><span class="opt-title">매장</span><span class="opt-sub">12~14분</span></div>
        <span class="radio" aria-hidden="true"></span>
      </label>
    </section>

    <!-- 쿠폰 -->
    <section class="coupon-wrap">
      <div class="coupon-label">쿠폰</div>
      <div class="coupon-pill ${couponApplied ? 'active' : ''}" id="couponPill" role="button" tabindex="0">
        <span>아메리카노 1잔 무료</span>
        <span class="coupon-check">✓</span>
      </div>
    </section>
  </main>

  <!-- 하단 버튼 -->
  <div class="buttons">
    <button class="btn btn-outline" type="button" onclick="applyCoupon()">쿠폰 사용</button>
    <form id="checkoutForm" action="<c:url value='/order/checkout'/>" method="post">
      <input type="hidden" name="orderType" id="orderTypeInput" value="${orderType != null ? orderType : 'TAKEOUT'}"/>
      <input type="hidden" name="couponApplied" id="couponAppliedInput" value="${couponApplied ? 'true' : 'false'}"/>
      <button class="btn btn-primary" type="submit" id="orderBtn">
        <span class="badge" id="itemCount">0</span>
        <span id="orderText">0원 주문하기</span>
      </button>
    </form>
  </div>

  <!-- 바텀 네비(목업) -->
  <nav class="nav" aria-label="하단 네비게이션">
    <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
  </nav>
</div>

<!-- 서버 액션용 숨은 폼들 -->
<form id="updateForm" action="<c:url value='/cart/update'/>" method="post" style="display:none">
  <input type="hidden" name="menuId" id="updMenuId"/>
  <input type="hidden" name="action" id="updAction"/> <!-- INC | DEC -->
</form>
<form id="removeForm" action="<c:url value='/cart/remove'/>" method="post" style="display:none">
  <input type="hidden" name="menuId" id="rmMenuId"/>
</form>

<script>
  // 천단위 포맷
  const fmt = n => (n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  // 합계/개수 갱신
  function refreshTotals(){
    const items = Array.from(document.querySelectorAll('.item'));
    let total = 0, cnt = 0;
    items.forEach(it=>{
      const price = Number(it.dataset.price||0);
      const q = Number(it.querySelector('.count').textContent||0);
      total += price*q; cnt += q;
    });
    document.getElementById('itemCount').textContent = cnt;
    document.getElementById('orderText').textContent = fmt(total)+'원 주문하기';
  }
  refreshTotals();

  // 수량 업데이트: 서버로 POST (/cart/update)
  function updateQty(menuId, action){
    document.getElementById('updMenuId').value = menuId;
    document.getElementById('updAction').value = action; // INC or DEC
    document.getElementById('updateForm').submit();
  }
  // 삭제: 서버로 POST (/cart/remove)
  function removeItem(menuId){
    document.getElementById('rmMenuId').value = menuId;
    document.getElementById('removeForm').submit();
  }

  // 주문 유형 (포장/매장) 토글 → hidden input 반영
  document.getElementById('orderType').addEventListener('click',(e)=>{
    const opt = e.target.closest('.option'); if(!opt) return;
    document.querySelectorAll('#orderType .option').forEach(o=>o.classList.remove('active'));
    opt.classList.add('active');
    document.getElementById('orderTypeInput').value = opt.dataset.type; // TAKEOUT | DINEIN
  });

  // 쿠폰 토글 → hidden input 반영
  const couponPill = document.getElementById('couponPill');
  function applyCoupon(){
    couponPill.classList.toggle('active');
    document.getElementById('couponAppliedInput').value =
      couponPill.classList.contains('active') ? 'true' : 'false';
  }
  couponPill.addEventListener('click', applyCoupon);
  couponPill.addEventListener('keydown', (e)=>{ if(e.key==='Enter'||e.key===' '){ e.preventDefault(); applyCoupon(); } });
</script>
</body>
</html>
