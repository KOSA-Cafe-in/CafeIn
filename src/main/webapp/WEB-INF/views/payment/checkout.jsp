<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>결제하기</title>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
<meta name="theme-color" content="#ffffff" />
<%@ include file="/WEB-INF/views/common/head.jsp"%>

<style>
:root{
  --bg:#f6f7fb;
  --card:#ffffff;
  --text:#111827;
  --muted:#6b7280;
  --primary:#2563eb;
  --primary-pressed:#1e40af;
  --line:#e5e7eb;
  --shadow:0 6px 16px rgba(0,0,0,.06);
}

*{ box-sizing:border-box; }

html, body{
  margin:0;
  padding:0;
  background:var(--bg);
  font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Apple SD Gothic Neo,Helvetica,Arial,"Noto Sans KR",sans-serif;
  color:var(--text);
}

/* phone frame */
.phone{
  max-width:420px;
  margin:0 auto;
  min-height:100dvh;
  display:flex;
  flex-direction:column;
  background:#fff;
}
@media (min-width:421px){
  .phone{ border-left:1px solid var(--line); border-right:1px solid var(--line); }
}

/* header (include에서 내려오는 구조용, 건드리지 않음) */
.header{
  display:flex;
  align-items:center;
  gap:10px;
  padding:14px 16px;
  border-bottom:1px solid var(--line);
  position:sticky;
  top:0;
  background:#fff;
  z-index:10;
}
.back{ font-size:20px; line-height:1; cursor:pointer; }
.title{ font-weight:700; font-size:18px; }

/* body */
.content{
  flex:1;
  overflow:auto;
  background:var(--bg);
  padding:16px 12px 140px;
}
.order-meta{
  padding:8px 0 12px;
  color:var(--muted);
  font-size:13px;
}
.cart{ display:block; }

/* 주문 요약 카드 */
.summary-card{
  background:var(--card);
  border:1px solid var(--line);
  border-radius:18px;
  box-shadow:var(--shadow);
  padding:12px;
}
.summary-header{
  display:flex; align-items:center; justify-content:space-between;
  padding:4px 6px 10px;
  border-bottom:1px dashed var(--line);
}
.summary-title{ font-weight:800; }
.summary-count{ font-size:12px; color:var(--muted); }

.summary-list{ list-style:none; margin:10px 0 0; padding:0; }
.summary-item{
  display:grid;
  grid-template-columns: 1fr auto;
  gap:10px;
  padding:10px 6px;
  border-bottom:1px solid var(--line);
}
.summary-item:last-child{ border-bottom:none; }
.si-name{
  font-weight:600; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
}
.si-meta{ margin-top:2px; font-size:12px; color:var(--muted); }
.si-price{ text-align:right; font-weight:700; }

.summary-total{
  margin-top:12px;
  background:#f9fafb;
  border:1px dashed var(--line);
  border-radius:14px;
  padding:12px;
}
.total-row{
  display:flex; align-items:center; justify-content:space-between;
  padding:6px 0;
}
.total-row.discount{ color:#10b981; }
.total-row.final{
  font-weight:900; font-size:18px;
  border-top:1px solid var(--line); margin-top:6px; padding-top:12px;
}

/* 쿠폰 배지 */
.badge-pill{
  display:inline-flex; align-items:center; gap:6px;
  padding:4px 10px; border-radius:999px;
  background:#ecfeff; color:#0e7490; font-weight:700; font-size:12px;
}

/* 빈 상태 */
.empty{
  text-align:center; color:var(--muted);
  background:var(--card); border:1px dashed var(--line);
  border-radius:18px; padding:24px 12px;
}

/* 하단 버튼 영역 - 기존 디자인 유지 + 뱃지/금액 정렬 */
.buttons{
  position:sticky; bottom:60px; z-index:30;
  background:linear-gradient(180deg, rgba(246,247,251,0) 0%, var(--bg) 40%, var(--bg) 100%);
  padding:14px 12px 12px;
}
.btn{
  width:100%; height:48px;
  border-radius:14px; border:0; cursor:pointer;
  font-size:16px; font-weight:700;
}
.btn:disabled{ opacity:.6; cursor:not-allowed; }

/* 파란 버튼(기존 색/둥근 모서리 유지) + 안쪽 레이아웃 */
.btn-primary{
  display:flex; align-items:center; justify-content:center; gap:10px;
  background:var(--primary); color:#fff;
}
.btn-primary:active{ background:var(--primary-pressed); }

/* 버튼 안의 동그란 뱃지(수량) */
.btn-primary .badge{
  min-width:28px; height:28px;
  border-radius:999px;
  background:#fff; color:var(--primary);
  display:inline-flex; align-items:center; justify-content:center;
  font-weight:800; font-size:13px;
}

/* 여백 보정 */
@media (min-width:380px){
  .summary-card{ padding:16px; }
}
</style>


<!-- jQuery & PortOne -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
</head>

<body>
<div class="phone">
  <!-- Header -->
  <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="backLink" value="true" />
    <jsp:param name="title" value="결제하기" />
    <jsp:param name="showOrderHistory" value="false" />
  </jsp:include>

  <main class="content">
    <!-- 주문 요약 -->
    <section class="cart" id="orderSummary"></section>
  </main>

  <!-- 결제 버튼 -->
  <div class="buttons">
    <button id="paymentBtn" class="btn btn-primary">결제하기</button>
  </div>

  <!-- Bottom Navigation -->
  <jsp:include page="/WEB-INF/views/common/nav.jsp">
    <jsp:param name="active" value="cart" />
  </jsp:include>
</div>

<!-- cart JSON을 안전하게 주입 -->
<script type="application/json" id="cartJson"><c:out value="${orderData.cart}"/></script>

<script>
  // HTML 엔티티 디코딩 함수
  function decodeHtmlEntities(text) {
    var textArea = document.createElement('textarea');
    textArea.innerHTML = text;
    return textArea.value;
  }

  // PortOne 초기화
  var IMP = window.IMP;
  IMP.init('${portoneImpCode}');

  // 서버에서 내려온 주문 메타
  var merchantUid = '${merchantUid}';
  var orderType   = '${orderData.orderType}';      // "Y" | "N"
  var couponApplied = '${orderData.couponApplied}'; // "Y" | "N" 
  console.log('teststest/' + orderType);
  // cart 파싱
  var cartItems = [];
  try {
    const rawCartData = document.getElementById('cartJson').textContent;
    console.log('Raw cart JSON from server:', rawCartData); // 디버깅 로그 추가
    console.log('Type of raw data:', typeof rawCartData); // 타입 확인

    if (!rawCartData || rawCartData.trim() === '') {
      console.warn('Empty cart data received from server');
      cartItems = [];
    } else {
      // HTML 엔티티 디코딩
      const decodedData = decodeHtmlEntities(rawCartData);
      console.log('Decoded cart data:', decodedData);

      cartItems = JSON.parse(decodedData);
      console.log('Successfully parsed cart items:', cartItems);
    }
  } catch (e) {
    console.error('장바구니 데이터 파싱 오류:', e);
    console.error('문제가 된 raw data:', document.getElementById('cartJson').textContent);
    cartItems = [];
  }

  
  // 주문 요약 표시
(function renderSummary(){
  try {
    var subtotal = 0;
    var totalQty = 0; // ✅ 총 수량 합계

    if (!Array.isArray(cartItems) || cartItems.length === 0) {
      document.getElementById('orderSummary').innerHTML =
        '<div class="empty">장바구니가 비어 있습니다.</div>';
      return;
    }

    var listHtml = cartItems.map(function(item){
      var qty = Number(item.qty || 0);
      var price = Number(item.price || 0);
      var line = price * qty;

      subtotal += line;
      totalQty += qty; // ✅ 수량 합산

      var safeName = (item.name || '').replace(/</g,'&lt;').replace(/>/g,'&gt;');
      return (
        '<li class="summary-item">' +
          '<div>' +
            '<div class="si-name">' + safeName + '</div>' +
            '<div class="si-meta">수량 ' + qty + ' · 단가 ' + price.toLocaleString() + '원</div>' +
          '</div>' +
          '<div class="si-price">' + line.toLocaleString() + '원</div>' +
        '</li>'
      );
    }).join('');

    var discount = (couponApplied === 'Y') ? 2000 : 0;
    var finalAmount = Math.max(0, subtotal - discount);

    var html =
      '<div class="summary-card">' +
        '<div class="summary-header">' +
          '<div class="summary-title">주문 요약</div>' +
          // 원하시면 여기 개수도 totalQty로 바꿀 수 있어요
          '<div class="summary-count">총 ' + totalQty + '개</div>' +
        '</div>' +
        '<ul class="summary-list">' + listHtml + '</ul>' +
        '<div class="summary-total">' +
          '<div class="total-row"><span>상품 합계</span><strong>' + subtotal.toLocaleString() + '원</strong></div>' +
          (discount > 0
            ? '<div class="total-row discount"><span><span class="badge-pill">쿠폰 적용</span></span><strong>-' + discount.toLocaleString() + '원</strong></div>'
            : ''
          ) +
          '<div class="total-row final"><span>최종 결제금액</span><span>' + finalAmount.toLocaleString() + '원</span></div>' +
        '</div>' +
        '<div class="order-meta" style="margin-top:10px; font-size:12px; text-align:right;">주문번호: ' + merchantUid + '</div>' +
      '</div>';

    document.getElementById('orderSummary').innerHTML = html;

    // ✅ 버튼 라벨: 총 수량 사용
    var btn = document.getElementById('paymentBtn');
    btn.innerHTML =
      '</span> ' +
      finalAmount.toLocaleString() + '원 결제하기' +
      (discount > 0 ? ' (쿠폰 적용)' : '');

  } catch (e) {
    console.error(e);
    document.getElementById('orderSummary').innerHTML = '<p>주문 정보를 불러올 수 없습니다.</p>';
  }
})();



  // 결제 버튼 클릭
  document.getElementById('paymentBtn').addEventListener('click', function(){
    var totalAmount = cartItems.reduce(function(sum, item){
      return sum + ((item.price || 0) * (item.qty || 0));
    }, 0);
    if(couponApplied == 'Y') {totalAmount -= 2000;}
    console.log('최종 결제 금액 테스트' + totalAmount);

    var productName = '';
    if (cartItems.length > 0) {
      productName = cartItems.length > 1
        ? (cartItems[0].name + ' 외 ' + (cartItems.length - 1) + '개')
        : cartItems[0].name;
    }

    // PortOne 결제 요청
    IMP.request_pay({
      pg: 'kakaopay.TC0ONETIME',
      pay_method: 'card',
      merchant_uid: merchantUid,
      name: productName || '주문',
      amount: totalAmount,
      buyer_email: 'customer@example.com',
      buyer_name: '고객',
      buyer_tel: '010-0000-0000',
      buyer_addr: '서울특별시 강남구',
      buyer_postcode: '06018',
      m_redirect_url: "http://192.168.1.203:8080/payment/complete"
    }, function(rsp){
    	if (rsp.success) {
        $.ajax({
          url: '<c:url value="/payment/complete"/>',
          method: 'POST',
          contentType: 'application/json; charset=UTF-8',
          dataType: 'json',
          data: JSON.stringify({
            imp_uid: rsp.imp_uid,
            merchant_uid: rsp.merchant_uid,
            takeOut: orderType,                  // DOM 대신 서버 값 사용
            coupon: couponApplied,
            items: cartItems.map(it => ({
                menuId: it.menuId,   // 장바구니에 menuId가 있어야 함
                qty: it.qty,
                menuName: it.name
                // unitPrice: it.price // 서버에서 다시 조회할 것(보안성)
              }))
          }),
          success: function(data){
            if (data && data.success) {
              alert('결제가 완료되었습니다.');
              location.href = '<c:url value="/payment/success"/>';
            } else {
              alert('결제 검증에 실패했습니다: ' + (data && data.message ? data.message : '응답 형식 오류'));
            }
          },
          error: function(jqXHR){
            console.error("[DEBUG] ajax error:", jqXHR.responseText);
            alert('결제 검증 중 오류가 발생했습니다.');
          }
        });
      } else {
        alert('결제에 실패하였습니다: ' + rsp.error_msg);
        location.href = '<c:url value="/payment/fail"/>?error_msg=' + encodeURIComponent(rsp.error_msg);
      }
    });
  });
</script>
</body>
</html>
