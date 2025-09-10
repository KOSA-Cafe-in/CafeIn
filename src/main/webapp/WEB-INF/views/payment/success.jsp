<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp"%>
    <title>주문 완료</title>
    <style>
        .content{padding:16px 18px 90px;}
        .success-icon {
            text-align: center;
            padding: 20px 0;
        }
        .success-icon svg {
            width: 80px;
            height: 80px;
            fill: #10B981;
        }
        .success-title {
            text-align: center;
            font-size: 24px;
            font-weight: 700;
            color: #111;
            margin: 10px 0;
        }
        .success-subtitle {
            text-align: center;
            font-size: 16px;
            color: #6B7280;
            margin-bottom: 30px;
        }
        .order-info {
            background: #fff;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            padding: 20px;
            margin-bottom: 16px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f1f3f4;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #374151;
        }
        .info-value {
            color: #111;
            font-weight: 500;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-preparing {
            background: #FEF3C7;
            color: #D97706;
        }
        .status-complete {
            background: #D1FAE5;
            color: #065F46;
        }
        .menu-list {
            background: #fff;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            padding: 20px;
            margin-bottom: 16px;
        }
        .menu-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 16px;
            color: #111;
        }
        .menu-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f3f4;
        }
        .menu-item:last-child {
            border-bottom: none;
        }
        .menu-name {
            font-weight: 600;
            color: #111;
        }
        .menu-qty {
            color: #6B7280;
            font-size: 14px;
            margin-left: 8px;
        }
        .menu-price {
            font-weight: 600;
            color: #111;
        }
        .total-section {
            background: #F9FAFB;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }
        .total-final {
            border-top: 2px solid #E5E7EB;
            padding-top: 12px;
            margin-top: 12px;
            font-size: 18px;
            font-weight: 700;
        }
        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: #3B82F6;
            color: white;
        }
        .btn-secondary {
            background: #F3F4F6;
            color: #374151;
            border: 1px solid #D1D5DB;
        }
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
                <svg viewBox="0 0 24 24">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>

            <h1 class="success-title">주문이 완료되었습니다!</h1>
            <p class="success-subtitle">주문하신 음료를 준비 중입니다.</p>

            <!-- 주문 정보 -->
            <div class="order-info">
                <div class="info-row">
                    <span class="info-label">주문번호</span>
                    <span class="info-value">${payment.merchantUid}</span>
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
                        <c:choose>
                            <c:when test="${order.status == 'Y'}">
                                <span class="status-badge status-complete">제조완료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-preparing">준비중</span>
                            </c:otherwise>
                        </c:choose>
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
                <div class="info-row">
                    <span class="info-label">결제수단</span>
                    <span class="info-value">${payment.paymentMethod}</span>
                </div>
            </div>

            <!-- 주문 메뉴 -->
            <div class="menu-list">
                <h3 class="menu-title">주문 메뉴</h3>
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
                        <span class="text-red-600">-할인금액원</span>
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
</body>
</html>
