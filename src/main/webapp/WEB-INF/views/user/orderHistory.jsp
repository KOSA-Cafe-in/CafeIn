<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>주문 내역</title>
    <style>
        .container { padding: 16px 18px 90px; }
        .page-title { font-size: 22px; font-weight: 800; margin: 8px 0 16px; }

        /* 카드 스타일 */
        .order-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .order-card:hover {
            background: #f9fafb;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }

        /* 헤더 */
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }
        .order-id {
            font-weight: 700;
            font-size: 16px;
            color: #111;
        }

        /* 상태 */
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            min-width: 70px;
            text-align: center;
        }
        .status-preparing { background: #FEF3C7; color: #D97706; }
        .status-complete  { background: #D1FAE5; color: #065F46; }

        /* 날짜 */
        .order-date {
            font-size: 13px;
            color: #6B7280;
            margin-top: 4px;
            display: block;
        }

        .empty {
            padding: 28px;
            text-align: center;
            color: #6B7280;
            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:12px;
        }
    </style>
</head>
<body>
<main class="phone">
    <!-- 공통 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp">
        <jsp:param name="backLink" value="true" />
        <jsp:param name="title" value="주문 내역" />
        <jsp:param name="showOrderHistory" value="false" />
    </jsp:include>

    <div class="content">
            <c:choose>
            <c:when test="${empty orders}">
                <div class="empty">주문 내역이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="o" items="${orders}">
                    <div class="order-card order-row"
                         data-order-id="${o.orderId}"
                         data-status="${o.status}"
                         onclick="location.href='${pageContext.request.contextPath}/orderHistoryDetail/${o.orderId}'">
                        <div class="order-header">
                            <span class="order-id">주문번호  ${o.orderId}번</span>
                            <span class="status-badge ${o.status == 'Y' ? 'status-complete' : 'status-preparing'}">
                                <c:choose>
                                    <c:when test="${o.status == 'Y'}">제조완료</c:when>
                                    <c:otherwise>준비중</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <span class="order-date">
                            <fmt:formatDate value="${o.createdDate}" pattern="yyyy-MM-dd HH:mm" />
                        </span>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 하단 네비 -->
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
        <jsp:param name="active" value="orders" />
    </jsp:include>
</main>

<!-- 🟢 상태 폴링 스크립트 (orderId 기반) -->
<script>
(function() {
  const ctx = '${pageContext.request.contextPath}';
  const rows = Array.from(document.querySelectorAll('.order-row'));
  if (!rows.length) return;

  const BASE_INTERVAL = 5000;  // 5초 간격
  const BG_INTERVAL   = 12000; // 백그라운드 시 12초
  let timer;

  async function fetchStatus(orderId) {
    try {
      if (!orderId) return null;
      const res = await fetch(ctx + '/order/status?orderId=' + encodeURIComponent(orderId), {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        cache: 'no-store'
      });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      return await res.json(); // {status:"Y"|"N"}
    } catch (e) {
      console.warn('[orderHistory] status fetch failed:', e);
      return null;
    }
  }

  function applyRowUI(row, status) {
    const badge = row.querySelector('.status-badge');
    if (!badge) return;
    if (status === 'Y') {
      badge.textContent = '제조완료';
      badge.classList.remove('status-preparing');
      badge.classList.add('status-complete');
      row.dataset.status = 'Y';
    } else {
      badge.textContent = '준비중';
      badge.classList.remove('status-complete');
      badge.classList.add('status-preparing');
      row.dataset.status = 'N';
    }
  }

  async function tick() {
    await Promise.all(rows.map(async (row) => {
      const orderId = row.dataset.orderId;
      const current = row.dataset.status || '';
      const data = await fetchStatus(orderId);
      if (data && typeof data.status === 'string') {
        const next = data.status.trim();
        if (next !== current) {
          applyRowUI(row, next);
        }
      }
    }));
    scheduleNext();
  }

  function scheduleNext() {
    const interval = document.hidden ? BG_INTERVAL : BASE_INTERVAL;
    timer = setTimeout(tick, interval);
  }

  document.addEventListener('visibilitychange', () => {
    if (!document.hidden) {
      clearTimeout(timer);
      tick(); // 탭 돌아오면 즉시 한 번 확인
    }
  });

  // 시작
  scheduleNext();
})();
</script>
</body>
</html>
