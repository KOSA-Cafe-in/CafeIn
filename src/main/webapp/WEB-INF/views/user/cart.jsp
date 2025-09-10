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
    .buttons{position:sticky;bottom:60px; z-index:30; background:linear-gradient(180deg, rgba(246,247,251,0) 0%, var(--bg) 40%, var(--bg) 100%);padding:14px 12px 12px}
    .btn{width:100%;height:48px;border-radius:14px;border:0;cursor:pointer;font-size:16px;font-weight:700}
    .btn-outline{background:#e9eefb;color:#274472;margin-bottom:10px}
    .btn-primary{display:flex;align-items:center;justify-content:center;gap:10px;background:var(--primary);color:#fff}
    .btn-primary:active{background:var(--primary-pressed)}
    .badge{min-width:28px;height:28px;border-radius:999px;background:#fff;color:#2563eb;display:inline-flex;align-items:center;justify-content:center;font-weight:800}
    @media (min-width:421px){ .phone{border-left:1px solid var(--line);border-right:1px solid var(--line)} }
  </style>
</head>
<body>
<div class="phone">
<!-- 헤더 include -->
        <jsp:include page="/WEB-INF/views/common/header.jsp">
        	<jsp:param name="backLink" value="true" />
            <jsp:param name="title" value="장바구니" />
            <jsp:param name="showOrderHistory" value="false" />
        </jsp:include>


  <!-- 본문 -->
  <main class="content">
    <section class="cart" id="cart"></section>

    <a class="addmore" href="<c:url value='/user/home'/>">메뉴 더 추가 +</a>

    <!-- 주문 유형: '픽업' 대신 '포장'으로 표시 -->
    <section class="option-group" id="orderType">
      <label class="option ${orderType eq 'Y' ? 'active' : ''}" data-type="Y">
        <div><span class="opt-title">포장하기</span></div>
        <span class="radio" aria-hidden="true"></span>
      </label>
      <label class="option ${orderType eq 'N' ? 'active' : ''}" data-type="N">
        <div><span class="opt-title">먹고가기</span></div>
        <span class="radio" aria-hidden="true"></span>
      </label>
    </section>

    <!-- 쿠폰 -->
    <section class="coupon-wrap">
      <div class="coupon-label">쿠폰</div>
      <div class="coupon-pill ${couponApplied ? 'active' : ''}" id="couponPill" role="button" tabindex="0">
        <span>2000원 할인 쿠폰</span>
        <span class="coupon-check">✓</span>
      </div>
    </section>
  </main>

  <!-- 하단 버튼 -->
<div class="buttons">
  <form id="checkoutForm" action="<c:url value='/payment/checkout'/>" method="post">
    <input type="hidden" name="orderType" id="orderTypeInput" value="${orderType != null ? orderType : 'Y'}"/>
    <input type="hidden" name="couponApplied" id="couponAppliedInput" value="${couponApplied ? 'Y' : 'N'}"/>
    <input type="hidden" name="cart" id="cartJson"/>
    <button class="btn btn-primary" type="submit" id="orderBtn">
      <span class="badge" id="itemCount">0</span>
      <span id="orderText">0원 주문하기</span>
    </button>
  </form>
</div>

<!-- 하단 네비게이션 include -->
<jsp:include page="/WEB-INF/views/common/nav.jsp">
  <jsp:param name="active" value="cart" />
</jsp:include>

</div>
<script>
/* === LocalStorage Cart Utils === */
// cart 구조 : { items: { [menuId]: {name, price, qty} } }
const CART_KEY = 'cart:v1';

function cartLoad(){
  try {
    const data = localStorage.getItem(CART_KEY);
    console.log('Raw localStorage data:', data); // 디버깅 로그 추가

    if (!data) {
      console.log('No cart data found, returning empty cart');
      return { items:{} };
    }

    const parsed = JSON.parse(data);
    console.log('Parsed cart data:', parsed); // 디버깅 로그 추가
    return parsed;
  }
  catch(e){
    console.error('장바구니 데이터 파싱 오류:', e);
    console.error('문제가 된 데이터:', localStorage.getItem(CART_KEY));
    // 손상된 데이터 제거
    localStorage.removeItem(CART_KEY);
    return { items:{} };
  }
}

function cartSave(c){
  localStorage.setItem(CART_KEY, JSON.stringify(c));
  try { localStorage.setItem('cart:updated', Date.now().toString()); } catch(e){}
}

/* 메뉴 담기: key가 곧 menuId */
function cartAdd({ menuId, name, price, qty = 1 }){
  const cart = cartLoad();
  const k = String(menuId);
  const it = cart.items[k] || { name: name || '', price: Number(price)||0, qty: 0 };
  it.qty += Number(qty)||0 || 1;
  it.price = Number(price)||it.price||0;
  it.name = it.name || name || '';
  if (it.qty <= 0) { delete cart.items[k]; } else { cart.items[k] = it; }
  cartSave(cart);
}

function fmt(n){ return (n||0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','); }

function toNStrict(v) {
  if (typeof v === 'number') return v;
  const s = String(v ?? '').trim().replace(/[^\d.-]/g, '').replace(/(?!^)-/g, '');
  const n = Number(s);
  return Number.isFinite(n) ? n : 0;
}

function renderCart(){
  const wrap = document.getElementById('cart');
  const { items } = cartLoad();
  const entries = Object.entries(items); // [ [menuId, {name,price,qty}], ... ]

  if(entries.length === 0){
    wrap.innerHTML =
      '<article class="item" style="justify-content:center">' +
        '<div class="name">장바구니가 비어 있어요 ☕</div>' +
      '</article>';
    refreshTotals();
    return;
  }

  wrap.innerHTML = entries.map(([menuId, it])=>{
    const priceN = Number(it.price)||0;
    const qtyN   = Number(it.qty)||0;
    const nameHtml = escapeHtml(it.name||'');
    return ''
      + '<article class="item" data-menu-id="'+menuId+'" data-price="'+priceN+'">'
        + '<div class="item-left">'
          + '<div class="name">'+nameHtml+'</div>'
          + '<div class="price">'+fmt(priceN)+'원</div>'
        + '</div>'
        + '<div class="qty">'
          + '<button type="button" class="btn-qty" data-act="dec" aria-label="수량감소">−</button>'
          + '<div class="count">'+qtyN+'</div>'
          + '<button type="button" class="btn-qty" data-act="inc" aria-label="수량증가">+</button>'
          + '<button type="button" class="remove" data-act="remove" aria-label="삭제">✕</button>'
        + '</div>'
      + '</article>';
  }).join('');

  refreshTotals();
}

/* XSS 대비 간단 이스케이프 */
function escapeHtml(s){
  return String(s).replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
}

/* === 합계/개수 === */
function refreshTotals(){
  const items = Array.from(document.querySelectorAll('.item'));
  let total = 0, cnt = 0;
  items.forEach(it=>{
    const price = Number(it.dataset.price||0);
    const q = Number(it.querySelector('.count')?.textContent||0);
    total += price*q; cnt += q;
  });
  document.getElementById('itemCount').textContent = cnt;

  // 쿠폰 적용 여부 확인
  const couponApplied = document.getElementById('couponPill').classList.contains('active');
  if(couponApplied && total >= 2000){
    total -= 2000;
    document.getElementById('orderText').textContent = fmt(total)+'원 주문하기 (쿠폰 적용)';
  } else {
    document.getElementById('orderText').textContent = fmt(total)+'원 주문하기';
  }
}

function updateQty(menuId, delta){
  const cart = cartLoad();
  const k = String(menuId);
  const it = cart.items[k];
  if(!it) return;

  const next = Math.max(0, Math.min(99, (Number(it.qty)||0) + delta));
  if(next === 0) delete cart.items[k];
  else cart.items[k].qty = next;

  cartSave(cart);
  renderCart();
}

function removeItem(menuId){
  const cart = cartLoad();
  delete cart.items[String(menuId)];
  cartSave(cart);
  renderCart();
}

const cartEl = document.getElementById('cart');
cartEl.addEventListener('click', (e)=>{
  const t = e.target instanceof Element ? e.target : e.target && e.target.parentElement;
  if(!t) return;

  const btn = t.closest('button');
  if(!btn) return;

  const itemEl = t.closest('.item');
  if(!itemEl) return;

  const menuId = itemEl.dataset.menuId;
  const act = btn.dataset.act;

  if (act === 'inc')      updateQty(menuId, +1);
  else if (act === 'dec') updateQty(menuId, -1);
  else if (act === 'remove') removeItem(menuId);
});

/* === 주문 유형 토글 → hidden input 반영 === */
document.getElementById('orderType').addEventListener('click',(e)=>{
  const opt = e.target.closest('.option');
  if(!opt) return;
  document.querySelectorAll('#orderType .option').forEach(o=>o.classList.remove('active'));
  opt.classList.add('active');
  document.getElementById('orderTypeInput').value = opt.dataset.type; // Y | N

});

/* === 쿠폰 토글 → hidden input 반영 === */
const couponPill = document.getElementById('couponPill');

function applyCoupon(){
  couponPill.classList.toggle('active');
  document.getElementById('couponAppliedInput').value =
    couponPill.classList.contains('active') ? 'Y' : 'N';
  refreshTotals(); // 쿠폰 적용 시 합계 다시 계산
}

couponPill.addEventListener('click', applyCoupon);
couponPill.addEventListener('keydown', (e)=>{
  if(e.key==='Enter'||e.key===' '){
    e.preventDefault();
    applyCoupon();
  }
});

/* === 체크아웃: cart JSON 담아서 서버로 전송 === */
document.getElementById('checkoutForm').addEventListener('submit', (e)=>{
  const { items } = cartLoad();
  const entries = Object.entries(items);

  if(entries.length === 0){
    e.preventDefault();
    alert('장바구니가 비어있습니다.');
    return;
  }

  const couponApplied = document.getElementById('couponAppliedInput').value === 'Y';

  const rows = entries.map(([menuId, it])=>({
    menuId: Number(menuId),
    name: it.name,
    price: Number(it.price)||0,
    qty: Number(it.qty)||0
  }));

  console.log('장바구니 데이터:', rows);
  document.getElementById('cartJson').value = JSON.stringify(rows);
});

// 페이지 로드 시 장바구니 렌더링
document.addEventListener('DOMContentLoaded', function() {
  renderCart();
});

</script>
</body>
</html>
