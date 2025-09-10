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
  <meta name="theme-color" content="#ffffff"/>
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

<<<<<<< HEAD
=======
    /* ✅ 신규 표시 배지 (오른쪽 아래) */
>>>>>>> stash
    .badge-new {
      position:absolute; right:14px; bottom:8px;
      background:#ef4444; color:#fff;
      padding:2px 6px; font-size:11px; font-weight:700;
      border-radius:6px;
      box-shadow:0 2px 6px rgba(0,0,0,.15);
    }
  </style>
</head>
<body>
<div class="phone">
  <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="주문 내역" />
    <jsp:param name="showOrderHistory" value="false" />
    <jsp:param name="backLink" value="${pageContext.request.contextPath}/admin/home" />
  </jsp:include>

  <main class="content">
    <div class="tabs">
      <div id="tab-pending" class="tab active">신규·처리중 <span id="cnt-pending" class="badge">0</span></div>
      <div id="tab-done" class="tab">완료 <span id="cnt-done" class="badge">0</span></div>
    </div>

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
<<<<<<< HEAD
=======

>>>>>>> stash
            <button class="circle-btn js-done" data-id="${o.orderId}">완료</button>
          </div>
        </c:if>
      </c:forEach>
    </div>

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

  // ✅ 더 이상 여기에서 clearNewBadges()를 호출하지 않습니다.
  tabPending.addEventListener('click', function () {
    tabPending.classList.add('active'); tabDone.classList.remove('active');
    panelPending.classList.remove('hidden'); panelDone.classList.add('hidden');
  });

  tabDone.addEventListener('click', function () {
    tabDone.classList.add('active'); tabPending.classList.remove('active');
    panelDone.classList.remove('hidden'); panelPending.classList.add('hidden');
  });

  // ✅ 최초 입장 시 home.jsp에서 넘겨준 신규 건수 표시 (한 번만)
  function markInitialNewFromHint() {
    if (sessionStorage.getItem('newPendingShown') === '1') return;

    var raw = null, n = 0;
    try {
      raw = sessionStorage.getItem('newPendingHint');
      if (raw != null) n = parseInt(raw, 10) || 0;
    } catch(_) {}
    if (n <= 0) return;

    var cards = Array.prototype.slice.call(panelPending.querySelectorAll('.order-card'));
    cards.sort(function(a,b){
      var ai = parseInt((a.id||'').replace('order-',''),10)||0;
      var bi = parseInt((b.id||'').replace('order-',''),10)||0;
      return bi - ai;
    });
    for (var i=0; i<cards.length && i<n; i++) {
      if (!cards[i].querySelector('.badge-new')) {
        var badge = document.createElement('span');
        badge.className = 'badge-new';
        badge.textContent = '신규!';
        cards[i].appendChild(badge);
      }
    }

    try {
      sessionStorage.setItem('newPendingShown','1');
      sessionStorage.removeItem('newPendingHint');
    } catch(_) {}
  }
  markInitialNewFromHint();

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
    .then(function (res) { return res.json(); })
    .then(function (json) {
      if (!json || !json.ok) throw new Error('update failed');
      var card = document.getElementById('order-' + orderId);
      if (card) {
        var btn = card.querySelector('.js-done');
        if (btn) btn.parentNode.removeChild(btn);
        panelDone.insertBefore(card, panelDone.firstChild);
        setCounts();
      }
    })['catch'](function (err) {
<<<<<<< HEAD
=======
      alert('상태 변경 중 오류가 발생했습니다.');
>>>>>>> stash
      if (window.console) console.error(err);
    });
  });

<<<<<<< HEAD
  // 폴링 (동일)
  function pollOrdersDOM(){
    fetch(CTX + '/admin/orders', { headers: { 'X-Requested-With':'fetch' }})
      .then(function(r){ return r.text(); })
      .then(function(html){
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var newPendingCards = doc.querySelectorAll('#panel-pending .order-card');
        var newDoneCards    = doc.querySelectorAll('#panel-done .order-card');
        var newPendingIds = {}; newPendingCards.forEach(function(c){ newPendingIds[c.id]=c; });
        var newDoneIds = {}; newDoneCards.forEach(function(c){ newDoneIds[c.id]=c; });
        newPendingCards.forEach(function(card){
          var id = card.id;
          if (!document.getElementById(id)) {
            var imported = document.importNode(card, true);
            var badge = document.createElement('span');
            badge.className = 'badge-new';
            badge.textContent = '신규!';
            imported.appendChild(badge);
            panelPending.insertBefore(imported, panelPending.firstChild);
          }
        });
        Array.prototype.slice.call(panelPending.querySelectorAll('.order-card')).forEach(function(cur){
          var id = cur.id;
          if (!newPendingIds[id] && newDoneIds[id]) {
            var importedDone = document.importNode(newDoneIds[id], true);
            panelDone.insertBefore(importedDone, panelDone.firstChild);
            cur.parentNode.removeChild(cur);
          }
        });
        newDoneCards.forEach(function(card){
          var id = card.id;
          if (!document.getElementById(id)) {
            var imported = document.importNode(card, true);
            panelDone.insertBefore(imported, panelDone.firstChild);
          }
        });
        setCounts();
      })['catch'](function(){});
  }
  var _pollTimer = setInterval(pollOrdersDOM, 3000);

  // ✅ 페이지 이탈 시: 화면에 붙은 배지 제거만 (표시여부 플래그는 유지!)
  window.addEventListener('beforeunload', function(){
    document.querySelectorAll('.badge-new').forEach(function(el){ el.remove(); });
    // sessionStorage.removeItem('newPendingShown');  // ← 삭제하지 않음!
  });
=======
  /* ============================
     신규/상태 변경 폴링 (DOM 머지)
  ============================ */
  function pollOrdersDOM(){
    fetch(CTX + '/admin/orders', { headers: { 'X-Requested-With':'fetch' }})
      .then(function(r){ return r.text(); })
      .then(function(html){
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');

        var newPendingCards = doc.querySelectorAll('#panel-pending .order-card');
        var newDoneCards    = doc.querySelectorAll('#panel-done .order-card');

        var newPendingIds = {};
        newPendingCards.forEach(function(c){ newPendingIds[c.id] = c; });

        var newDoneIds = {};
        newDoneCards.forEach(function(c){ newDoneIds[c.id] = c; });

        // 1) 신규·처리중: 새 카드 추가 + '신규!'
        newPendingCards.forEach(function(card){
          var id = card.id;
          if (!document.getElementById(id)) {
            var imported = document.importNode(card, true);
            var badge = document.createElement('span');
            badge.className = 'badge-new';
            badge.textContent = '신규!';
            imported.appendChild(badge);
            panelPending.insertBefore(imported, panelPending.firstChild);
          }
        });

        // 2) 다른 곳에서 완료로 바뀐 건 이동
        Array.prototype.slice.call(panelPending.querySelectorAll('.order-card')).forEach(function(cur){
          var id = cur.id;
          if (!newPendingIds[id] && newDoneIds[id]) {
            var importedDone = document.importNode(newDoneIds[id], true);
            panelDone.insertBefore(importedDone, panelDone.firstChild);
            cur.parentNode.removeChild(cur);
          }
        });

        // 3) 완료 탭 새 카드 추가
        newDoneCards.forEach(function(card){
          var id = card.id;
          if (!document.getElementById(id)) {
            var imported = document.importNode(card, true);
            panelDone.insertBefore(imported, panelDone.firstChild);
          }
        });

        setCounts();
      })['catch'](function(e){
        // 네트워크 오류는 조용히 무시
      });
  }
  var _pollTimer = setInterval(pollOrdersDOM, 3000);

  // '신규!' 배지 제거 — 페이지 이탈 시에만 제거
  function clearNewBadges(){
    var list = document.querySelectorAll('.badge-new');
    for (var i=0;i<list.length;i++) list[i].parentNode.removeChild(list[i]);
  }
  window.addEventListener('beforeunload', clearNewBadges);

  // 페이지 진입 시 '본 것으로 처리' (헤더 뱃지 초기화용)
  (function markSeenOnEnter(){
    try { fetch(CTX + '/admin/order/markSeen', { method: 'POST' }); } catch(e) {}
  })();
>>>>>>> stash
</script>
</body>
</html>
