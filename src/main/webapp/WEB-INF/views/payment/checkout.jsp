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
  --accent:#20c8c8;
  --pill:#f0f2f7;
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

.phone{
  max-width:420px;
  margin:0 auto;
  min-height:100dvh;
  display:flex;
  flex-direction:column;
  background:#fff;
}

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

.content{
  flex:1;
  overflow:auto;
  background:var(--bg);
  padding:12px 12px 120px;
}

.cart{ display:grid; gap:10px; margin:4px 0 8px; }

.item{
  background:var(--card);
  border-radius:18px;
  padding:14px 12px;
  box-shadow:var(--shadow);
  display:flex;
  align-items:center;
  justify-content:space-between;
}

.item-left{ min-width:0; }
.name{ font-weight:600; }
.desc{ margin-top:4px; color:var(--muted); font-size:13px; }
.price{ margin-top:6px; color:var(--muted); }
.remove{ margin-left:8px; border:none; background:transparent; font-size:18px; color:#9ca3af; cursor:pointer; }

.qty{ display:flex; align-items:center; gap:6px; }
.btn-qty{
  width:36px; height:36px; border-radius:12px;
  border:1px solid var(--line); background:#fff; font-size:20px; line-height:1; cursor:pointer;
}
.count{ min-width:24px; text-align:center; font-weight:700; }

.addmore{ display:block; text-align:center; margin:8px auto 16px; color:#2563eb; text-decoration:none; font-weight:700; }

.option-group{ display:grid; gap:10px; margin:10px 0 16px; }

.option{
  background:#fff; border:2px solid var(--line); border-radius:16px;
  padding:14px 12px; box-shadow:var(--shadow);
  display:flex; align-items:center; justify-content:space-between; cursor:pointer;
}
.option.active{ border-color:var(--accent); box-shadow:0 0 0 4px rgba(32,200,200,.12); }
.opt-title{ font-weight:700; }
.opt-sub{ font-size:12px; color:var(--muted); margin-left:6px; }
.radio{ width:22px; height:22px; border-radius:50%; border:2px solid var(--line); display:inline-block; }
.option.active .radio{ border-color:var(--accent); box-shadow:inset 0 0 0 5px var(--accent); }

.coupon-wrap{ margin:4px 0 16px; }
.coupon-label{ font-size:13px; color:var(--muted); margin-bottom:8px; }
.coupon-pill{
  display:flex; align-items:center; justify-content:space-between;
  background:var(--pill); border-radius:24px; padding:14px 16px; font-weight:700; cursor:pointer;
}
.coupon-check{
  width:26px; height:26px; border-radius:50%; border:2px solid var(--line);
  display:flex; align-items:center; justify-content:center; background:#fff; font-size:16px;
}
.coupon-pill.active .coupon-check{ border-color:#10b981; box-shadow:inset 0 0 0 1000px #10b981; color:#fff; }

.buttons{
  position:sticky; bottom:60px; z-index:30;
  background:linear-gradient(180deg, rgba(246,247,251,0) 0%, var(--bg) 40%, var(--bg) 100%);
  padding:14px 12px 12px;
}
.btn{ width:100%; height:48px; border-radius:14px; border:0; cursor:pointer; font-size:16px; font-weight:700; }
.btn-outline{ background:#e9eefb; color:#274472; margin-bottom:10px; }
.btn-primary{ display:flex; align-items:center; justify-content:center; gap:10px; background:var(--primary); color:#fff; }
.btn-primary:active{ background:var(--primary-pressed); }
.badge{ min-width:28px; height:28px; border-radius:999px; background:#fff; color:#2563eb; display:inline-flex; align-items:center; justify-content:center; font-weight:800; }

@media (min-width:421px){
  .phone{ border-left:1px solid var(--line); border-right:1px solid var(--line); }
}

.summary{ bottom:60px; }
.total .row span{ font-weight:600; }
.order-meta{ padding:8px 12px; color:var(--muted); font-size:13px; }
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
    <!-- 주문 정보 -->
    <div class="order-meta">주문번호: ${merchantUid}</div>

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
      var totalAmount = 0;
      var html = '<ul>';
      cartItems.forEach(function(item){
        var itemTotal = (item.price || 0) * (item.qty || 0);
        totalAmount += itemTotal;
        html += '<li>' + item.name + ' x ' + item.qty + '개 - ' + itemTotal.toLocaleString() + '원</li>';
      });
      console.log(totalAmount);
      html += '</ul>';
      html += '<p><strong>총 결제금액: ' + totalAmount.toLocaleString() + '원</strong></p>';
      document.getElementById('orderSummary').innerHTML = html;
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
      buyer_postcode: '06018'
    }, function(rsp){
    	console.log('테스트' + couponApplied);
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
