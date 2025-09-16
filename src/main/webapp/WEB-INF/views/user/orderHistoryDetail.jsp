<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<title>주문 완료</title>
<style>
.content { padding: 16px 18px 90px; }

/* 공통 아이콘 */
.success-icon { text-align: center; padding: 20px 0; }
.success-icon svg { width: 80px; height: 80px; }

/* 상태별 아이콘 색 */
.icon-preparing { fill: #F59E0B; }   /* 노랑 */
.icon-done { fill: #10B981; }        /* 초록 */

.success-title { text-align: center; font-size: 24px; font-weight: 700; margin: 10px 0; }
.success-subtitle { text-align: center; font-size: 16px; margin-bottom: 30px; color: #6B7280; }

.order-info, .menu-list {
    background: #fff; border-radius: 12px; border: 1px solid #e5e7eb;
    padding: 20px; margin-bottom: 16px;
}

.info-row, .menu-item {
    display: flex; justify-content: space-between; align-items: center;
    padding: 12px 0; border-bottom: 1px solid #f1f3f4;
}
.info-row:last-child, .menu-item:last-child { border-bottom: none; }

.info-label { font-weight: 600; color: #374151; }
.info-value { color: #111; font-weight: 500; }

.status-badge { display: inline-block; padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 600; }
.status-preparing { background: #FEF3C7; color: #D97706; }
.status-complete { background: #D1FAE5; color: #065F46; }

.menu-title { font-size: 18px; font-weight: 700; margin-bottom: 16px; color: #111; }
.menu-name { font-weight: 600; color: #111; }
.menu-qty { color: #6B7280; font-size: 14px; margin-left: 8px; }
.menu-price { font-weight: 600; color: #111; }

.total-section { background: #F9FAFB; border-radius: 12px; padding: 20px; margin-bottom: 20px; }
.total-row { display: flex; justify-content: space-between; padding: 8px 0; }
.total-final { border-top: 2px solid #E5E7EB; padding-top: 12px; margin-top: 12px; font-size: 18px; font-weight: 700; }

/* 제조완료 전용 픽업 안내 */
.pickup-panel {
  background:#fff; border:1px solid #D1FAE5; border-radius:12px;
  padding:16px; margin:16px 0;
}
.pickup-title { font-weight:700; color:#065F46; margin-bottom:8px; }
.pickup-row { display:flex; justify-content:space-between; padding:6px 0; }
.pickup-row .label { color:#6B7280; }
.pickup-row .value { font-weight:700; color:#111; }

/* 하단 버튼 */
.actions { display:flex; gap:8px; margin-top:16px; }
.btn { display:inline-block; flex:1; padding:10px 14px; border-radius:10px; text-align:center; font-weight:700; }
.btn.primary { background:#111; color:#fff; }
.btn.ghost { background:#fff; color:#111; border:1px solid #E5E7EB; }
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

    <c:set var="isDone" value="${order.status == 'Y'}" />

    <div class="content">
        <!-- 성공 아이콘 -->
        <div class="success-icon">
            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"
                 class="${isDone ? 'icon-done' : 'icon-preparing'}">
                <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>

        <!-- 타이틀/서브타이틀 -->
        <div class="success-title">
            <c:choose>
                <c:when test="${isDone}">제조가 완료되었습니다!</c:when>
                <c:otherwise>주문이 완료되었습니다!</c:otherwise>
            </c:choose>
        </div>
        <div class="success-subtitle">
            <c:choose>
                <c:when test="${isDone}">
                    음료를 수령해주세요.
                </c:when>
                <c:otherwise>
                    잠시만 기다려주세요.
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 제조완료 전용 픽업 안내 -->
        <c:if test="${isDone}">
            <div class="pickup-panel">
                <div class="pickup-title">픽업 안내</div>
                <div class="pickup-row">
                    <span class="label">수령 위치</span>
                    <span class="value">카운터 / 픽업존</span>
                </div>
            </div>
        </c:if>

        <!-- 주문 정보 -->
        <div class="order-info">
            <div class="info-row">
                <span class="info-label">주문번호</span>
                <span class="info-value">${payment.merchantUid}</span>
            </div>
            <div class="info-row">
                <span class="info-label">주문시간</span>
                <span class="info-value">
                    <fmt:formatDate value="${order.createdDate}" pattern="yyyy-MM-dd HH:mm" />
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">주문상태</span>
                <span class="info-value">
                    <span class="status-badge ${isDone ? 'status-complete' : 'status-preparing'}">
                        <c:choose>
                            <c:when test="${isDone}">제조완료</c:when>
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
                        <fmt:formatNumber value="${item.unitPrice * item.count}" pattern="#,###" />원
                    </span>
                </div>
            </c:forEach>
        </div>

        <!-- 결제 금액 -->
        <div class="total-section">
            <div class="total-row">
                <span>상품금액</span>
                <span><fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원</span>
            </div>
            <c:if test="${order.couponUse == 'Y'}">
                <div class="total-row">
                    <span>쿠폰할인</span>
                    <span style="color: #DC2626;">-2,000원</span>
                </div>
            </c:if>
            <div class="total-row total-final">
                <span>총 결제금액</span>
                <c:choose>
                    <c:when test="${order.couponUse == 'Y'}">
                        <span><fmt:formatNumber value="${order.totalPrice - 2000}" pattern="#,###" />원</span>
                    </c:when>
                    <c:otherwise>
                        <span><fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Bottom Navigation -->
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
        <jsp:param name="active" value="cart" />
    </jsp:include>
</main>
</body>
</html>
