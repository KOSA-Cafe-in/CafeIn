<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>주문 내역</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <%@ include file="/WEB-INF/views/common/head.jsp" %>
  <style>
    .tabs { display:flex; gap:16px; padding:12px 16px; border-bottom:1px solid #e8e8e8;}
    .tab { position:relative; padding:8px 6px; cursor:pointer; color:#888;}
    .tab.active { color:#2e6cff; font-weight:700; }
    .badge { margin-left:6px; background:#eef2ff; color:#2e6cff; border-radius:12px; padding:2px 8px; font-size:12px;}

    .panel { padding:8px 12px; }
    .order-card {
      position: relative;
      border-top: 2px solid #2e6cff20;
      padding: 14px 12px 16px 12px;
      background:#fff;
    }
    .order-title { display:flex; justify-content:space-between; align-items:center; }
    .total-line { margin-top:6px; font-weight:700; }
    .item { margin-top:10px; }
    .item .name { font-weight:600; }
    .item .price { color:#8a8a8a; font-size:12px; margin-top:2px; }
    .circle-btn {
      position:absolute; right:12px; top:18px;
      width:56px; height:56px; border-radius:50%;
      display:flex; align-items:center; justify-content:center;
      color:#fff; border:none; cursor:pointer;
      background:#2e6cff;
      box-shadow:0 6px 16px rgba(46,108,255,.25);
    }
    .hidden { display:none; }
    .takeout { color:#2e6cff; font-weight:700; margin-right:6px; }
    .mute { color:#9a9a9a; font-size:12px; }
  </style>
</head>
<body>
<div class="phone">
  <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="주문 내역" />
    <jsp:param name="showOrderHistory" value="false" />
    <jsp:param name="backLink" value="${pageContext.request.contextPath}/admin/home" />
  </jsp:include>

  <!-- 콘텐츠를 공통 .content 안에 넣어 하단 내비가 바닥에 고정되도록 -->
  <main class="content">
    <div class="tabs">
      <div id="tab-pending" class="tab active">신규·처리중 <span id="cnt-pending" class="badge">0</span></div>
      <div id="tab-done" class="tab">완료 <span id="cnt-done" class="badge">0</span></div>
    </div>

    <!-- 처리중 패널 -->
    <div id="panel-pending" class="panel">
      <c:forEach var="o" items="${orders}">
        <c:if test="${o.status eq 'N'}">
          <div class="order-card" id="order-${o.orderId}" data-status="N">
            <div class="order-title">
              <div>
                <span class="takeout"><c:out value="${o.takeout eq 'Y' ? '포장' : '매장'}"/></span>
                <span class="mute"><fmt:formatDate value="${o.createdDate}" pattern="HH:mm"/></span>
              </div>
            </div>

            <!-- 총 수량 계산 -->
            <c:set var="sumCount" value="0" scope="page"/>
            <c:forEach var="it" items="${o.items}">
              <c:set var="sumCount" value="${sumCount + it.count}" scope="page"/>
            </c:forEach>

            <div class="total-line">총 <c:out value="${sumCount}"/>개 | <fmt:formatNumber value="${o.totalPrice}" type="number"/>원</div>

            <c:forEach var="it" items="${o.items}">
              <div class="item">
                <div class="name"><c:out value="${it.menuName}"/> × <c:out value="${it.count}"/></div>
                <div class="price"><fmt:formatNumber value="${it.unitPrice * it.count}" type="number"/>원</div>
              </div>
            </c:forEach>

            <!-- 라벨은 '완료' -->
            <button class="circle-btn js-done" data-id="${o.orderId}">완료</button>
          </div>
        </c:if>
      </c:forEach>
    </div>

    <!-- 완료 패널 -->
    <div id="panel-done" class="panel hidden">
      <c:forEach var="o" items="${orders}">
        <c:if test="${o.status eq 'Y'}">
          <div class="order-card" id="order-${o.orderId}" data-status="Y">
            <div class="order-title">
              <div>
                <span class="takeout"><c:out value="${o.takeout eq 'Y' ? '포장' : '매장'}"/></span>
                <span class="mute"><fmt:formatDate value="${o.createdDate}" pattern="HH:mm"/></span>
              </div>
            </div>

            <c:set var="sumCount" value="0" scope="page"/>
            <c:forEach var="it" items="${o.items}">
              <c:set var="sumCount" value="${sumCount + it.count}" scope="page"/>
            </c:forEach>

            <div class="total-line">총 <c:out value="${sumCount}"/>개 | <fmt:formatNumber value="${o.totalPrice}" type="number"/>원</div>

            <c:forEach var="it" items="${o.items}">
              <div class="item">
                <div class="name"><c:out value="${it.menuName}"/> × <c:out value="${it.count}"/></div>
                <div class="price"><fmt:formatNumber value="${it.unitPrice * it.count}" type="number"/>원</div>
              </div>
            </c:forEach>
            <!-- 완료 탭에는 버튼 없음 -->
          </div>
        </c:if>
      </c:forEach>
    </div>
  </main>

  <jsp:include page="/WEB-INF/views/common/nav.jsp">
    <jsp:param name="active" value="home" />
  </jsp:include>
</div>

<script>
  // 컨텍스트 경로
  var CTX = '<c:out value="${pageContext.request.contextPath}" />';

  var tabPending   = document.getElementById('tab-pending');
  var tabDone      = document.getElementById('tab-done');
  var panelPending = document.getElementById('panel-pending');
  var panelDone    = document.getElementById('panel-done');

  function setCounts() {
    var p = panelPending.querySelectorAll('.order-card').length;
    var d = panelDone.querySelectorAll('.order-card').length;
    document.getElementById('cnt-pending').innerText = p;
    document.getElementById('cnt-done').innerText = d;
  }
  setCounts();

  tabPending.addEventListener('click', function () {
    tabPending.classList.add('active'); tabDone.classList.remove('active');
    panelPending.classList.remove('hidden'); panelDone.classList.add('hidden');
  });

  tabDone.addEventListener('click', function () {
    tabDone.classList.add('active'); tabPending.classList.remove('active');
    panelDone.classList.remove('hidden'); panelPending.classList.add('hidden');
  });

  // 완료 처리 (AJAX)
  document.addEventListener('click', function (e) {
    var target = e.target;
    while (target && !(target.classList && target.classList.contains('js-done'))) {
      target = target.parentNode;
    }
    if (!target) return;

    var orderId = target.getAttribute('data-id');

    fetch(CTX + '/admin/orders/' + orderId + '/done', {
      method: 'POST',
      headers: { 'Accept': 'application/json' }
    })
    .then(function (res) {
      if (!res.ok) { throw new Error('HTTP ' + res.status); }
      return res.json();
    })
    .then(function (json) {
      if (!json || !json.ok) { throw new Error('update failed'); }

      var card = document.getElementById('order-' + orderId);
      if (card) {
        target.parentNode.removeChild(target);
        panelDone.insertBefore(card, panelDone.firstChild);
        setCounts();
      }
    })['catch'](function (err) {  // ✅ JSP 편집기의 .catch 경고 회피
      alert('상태 변경 중 오류가 발생했습니다.');
      if (window.console) console.error(err);
    });
  });

  // ✅ 페이지 진입 시 '본 것으로 처리' (세션 기준 리셋)
  (function markSeenOnEnter(){
    try { fetch(CTX + '/admin/order/markSeen', { method: 'POST' }); } catch(e) {}
  })();
</script>
</body>
</html>
