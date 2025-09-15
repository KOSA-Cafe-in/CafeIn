<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp"%>
    <title>주문 완료</title>
    <style>
        /* 필요 시 공통 CSS로 이동하세요 */
        .content{padding:16px 18px 90px;}
        .success-icon{ text-align:center; padding:20px 0; }
        .success-icon svg{ width:80px; height:80px; fill:#10B981; }
        .success-title{ text-align:center; font-size:24px; font-weight:700; color:#111; margin:10px 0; }
        .success-subtitle{ text-align:center; font-size:16px; color:#6B7280; margin-bottom:30px; }
        .order-info,.menu-list{ background:#fff; border-radius:12px; border:1px solid #e5e7eb; padding:20px; margin-bottom:16px; }
        .info-row,.menu-item{ display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid #f1f3f4; }
        .info-row:last-child,.menu-item:last-child{ border-bottom:none; }
        .info-label{ font-weight:600; color:#374151; }
        .info-value{ color:#111; font-weight:500; }
        .status-badge{ display:inline-block; padding:4px 8px; border-radius:6px; font-size:12px; font-weight:600; }
        .status-preparing{ background:#FEF3C7; color:#D97706; }
        .status-complete{ background:#D1FAE5; color:#065F46; }
        .menu-title{ font-size:18px; font-weight:700; margin-bottom:16px; color:#111; }
        .menu-name{ font-weight:600; color:#111; }
        .menu-qty{ color:#6B7280; font-size:14px; margin-left:8px; }
        .menu-price{ font-weight:600; color:#111; }
        .total-section{ background:#F9FAFB; border-radius:12px; padding:20px; margin-bottom:20px; }
        .total-row{ display:flex; justify-content:space-between; padding:8px 0; }
        .total-final{ border-top:2px solid #E5E7EB; padding-top:12px; margin-top:12px; font-size:18px; font-weight:700; }
    </style>
</head>
<body>
    <main class="phone">
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/common/header.jsp">
            <jsp:param name="backLink" value="true" />
            <jsp:param name="title" value="주문 완료" />
            <jsp:param name="showOrderHistory" value="false" />
        </jsp:include>

        <div class="content">
            <!-- 성공 아이콘 -->
            <div class="success-icon">
                <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>

            <div class="success-title">주문이 완료되었습니다!</div>
            <div class="success-subtitle">제조가 완료되면 상태가 자동으로 변경됩니다.</div>

            <!-- 주문 정보 -->
            <div class="order-info">
                <div class="info-row">
                    <span class="info-label">주문번호</span>
                    <span class="info-value">${payment.merchantUid}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">결제수단</span>
                    <span class="info-value">${payment.paymentMethod}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">주문시간</span>
                    <span class="info-value">
                        <fmt:formatDate value="${order.createdDate}" pattern="yyyy-MM-dd HH:mm"/>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">주문상태</span>
                    <span class="info-value">
                        <span id="status-badge"
                              class="status-badge ${order.status == 'Y' ? 'status-complete' : 'status-preparing'}">
                            <c:choose>
                                <c:when test="${order.status == 'Y'}">제조완료</c:when>
                                <c:otherwise>준비중</c:otherwise>
                            </c:choose>
                        </span>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">매장/포장</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.takeout == 'Y'}">포장</c:when>
                            <c:otherwise>매장</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- 메뉴 리스트 -->
            <div class="menu-list">
                <div class="menu-title">주문 내역</div>
                <c:forEach var="item" items="${order.items}">
                    <div class="menu-item">
                        <div>
                            <span class="menu-name">${item.menuName}</span>
                            <span class="menu-qty">x ${item.count}</span>
                        </div>
                        <span class="menu-price">
                            <fmt:formatNumber value="${item.unitPrice * item.count}" pattern="#,###"/>원
                        </span>
                    </div>
                </c:forEach>
            </div>

            <!-- 결제 금액 -->
            <div class="total-section">
                <div class="total-row">
                    <span>상품금액</span>
                    <span><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>원</span>
                </div>
                <c:if test="${order.couponUse == 'Y'}">
                    <div class="total-row">
                        <span>쿠폰할인</span>
                        <span style="color:#DC2626;">-2,000원</span>
                    </div>
                </c:if>
                <div class="total-row total-final">
                    <span>총 결제금액</span>
                    <span><fmt:formatNumber value="${payment.amount}" pattern="#,###"/>원</span>
                </div>
            </div>
        </div>

        <!-- Bottom Navigation -->
        <jsp:include page="/WEB-INF/views/common/nav.jsp">
            <jsp:param name="active" value="cart" />
        </jsp:include>
    </main>

    <!-- 장바구니 초기화 -->
    <script>
      try { localStorage.removeItem("cart:v1"); } catch(e) {}
    </script>

    <!-- 상태 폴링 (1~3초 랜덤 간격, JSON /order/status) -->
    <script>
      (function(){
        var CTX = '<c:out value="${pageContext.request.contextPath}" />';
        var ORDER_KEY = '<c:out value="${payment.merchantUid}" />';
        var stopped = false;

        function randInt(min, max){ return Math.floor(Math.random()*(max-min+1))+min; }

        function applyBadge(isDone){
          var badge = document.getElementById('status-badge');
          if (!badge) return;
          if (isDone){
            badge.classList.remove('status-preparing');
            badge.classList.add('status-complete');
            badge.textContent = '제조완료';
          } else {
            badge.classList.remove('status-complete');
            badge.classList.add('status-preparing');
            badge.textContent = '준비중';
          }
        }

        function scheduleNext(){
          if (stopped) return;
          setTimeout(pollOnce, randInt(1000, 3000)); // 1~3초 랜덤
        }

        function pollOnce(){
          if (stopped) return;
          var url = CTX + '/order/status?merchantUid=' + encodeURIComponent(ORDER_KEY) + '&t=' + new Date().getTime();
          // Java 8 서버 호환과는 무관하지만, 캐시 방지를 위해 timestamp를 붙입니다.
          fetch(url, { headers: { 'Accept':'application/json' }, cache: 'no-store' })
            .then(function(r){ if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
            .then(function(data){
              var done = (data && data.status === 'Y');
              applyBadge(done);
              if (done) { stopped = true; return; }
              scheduleNext();
            })
            .catch(function(){ scheduleNext(); });
        }

        scheduleNext();
        window.addEventListener('beforeunload', function(){ stopped = true; });
      })();
      console.log(order.status);
    </script>
</body>
</html>
