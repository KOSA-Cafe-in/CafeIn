<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %> <%@ page session="false" %> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 관리자 홈 페이지 (담당 : 손윤찬) -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>리틀리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta name="theme-color" content="#ffffff" />
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
  </head>
  <body>
    <div class="phone">
      <!-- 헤더 include -->
      <jsp:include page="/WEB-INF/views/common/header.jsp">
        <jsp:param name="showOrderHistory" value="true" />
      </jsp:include>

      <main class="content">
        <h1 class="title">리틀리</h1>

        <!-- 소개글 영역 -->
        <div class="cafe-intro">
          <p
            id="intro-text"
            data-full="${fn:escapeXml(cafeIntro)}"
            data-empty="연필을 눌러 소개글을 수정하세요:)"
          ></p>

          <div class="intro-actions">
            <button id="btn-more" class="icon-button" style="display: none">더보기</button>
            <button id="btn-edit" class="icon-button" aria-label="소개글 수정">✏️</button>
          </div>

          <form
            id="intro-form"
            style="display: none"
            method="post"
            action="${pageContext.request.contextPath}/admin/home/updateIntro"
          >
            <textarea name="content" id="intro-textarea" rows="3" maxlength="3000">
${cafeIntro}</textarea
            >
            <div class="intro-counter"><span id="intro-count">0</span>/3000</div>
            <button type="submit">저장</button>
          </form>
        </div>

        <!-- 메뉴 추가 버튼 -->
        <div class="menu-actions">
          <a href="${pageContext.request.contextPath}/admin/menu/add" class="menu-add-btn"
            >메뉴 추가</a
          >
        </div>

        <!-- 메뉴 리스트 -->
        <div class="menu-list">
          <c:forEach var="menu" items="${menuList}">
            <div
              class="menu-item menu-clickable"
              onclick="location.href='${pageContext.request.contextPath}/admin/menu/${menu.menuId}/edit'"
            >
              <img src="${menu.menuPictureUrl}" alt="${menu.name}" class="menu-img" />
              <div class="menu-info">
                <h3>${menu.name}</h3>
                <p>${menu.content}</p>
                <strong><fmt:formatNumber value="${menu.price}" type="number" />원</strong>
              </div>
              <div class="menu-arrow" aria-hidden="true">
                <i class="fa-solid fa-angle-right"></i>
              </div>
            </div>
          </c:forEach>
        </div>
      </main>

      <!-- 하단 네비게이션 include -->
      <jsp:include page="/WEB-INF/views/common/nav.jsp">
        <jsp:param name="active" value="home" />
      </jsp:include>
    </div>

    <style>
      .home-wrap {
        max-width: 560px;
        margin: 0 auto;
        padding: 16px;
      }
      .title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 12px;
        text-align: center;
      }

      .cafe-intro {
        background: #f9f9f9;
        border-radius: 12px;
        padding: 12px;
        margin-bottom: 16px;
        position: relative;
      }
      #intro-text {
        font-size: 14px;
        margin: 0;
        white-space: pre-wrap;
      }

      .intro-actions {
        margin-top: 6px;
        display: flex;
        justify-content: flex-end;
        gap: 8px;
      }
      .icon-button {
        background: none;
        border: none;
        font-size: 14px;
        cursor: pointer;
      }

      .menu-actions {
        text-align: right;
        margin-bottom: 16px;
      }
      .menu-add-btn {
        padding: 8px 16px;
        background: #2e6cff;
        color: #fff;
        text-decoration: none;
        border-radius: 8px;
      }

      .menu-list {
        display: flex;
        flex-direction: column;
        gap: 12px;
      }
      .menu-item {
        display: flex;
        gap: 12px;
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 10px;
      }
      .menu-img {
        width: 72px;
        height: 72px;
        object-fit: cover;
        border-radius: 8px;
        background: #ddd;
      }
      .menu-info h3 {
        margin: 0;
        font-size: 16px;
      }
      .menu-info p {
        margin: 4px 0;
        font-size: 14px;
        color: #666;
      }

      .clamp-1 {
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      #intro-textarea {
        width: 100%;
        height: 84px;
        resize: none !important;
        overflow: auto;
        box-sizing: border-box;
      }
      .intro-counter {
        font-size: 12px;
        color: #999;
        text-align: right;
        margin: 4px 0 8px;
      }

      .menu-clickable {
        cursor: pointer;
        position: relative;
      }
      .menu-arrow {
        margin-left: auto;
        align-self: center;
        font-size: 18px;
        opacity: 0.7;
      }

      /* 헤더 오른쪽 아이콘에 붙는 뱃지 */
      .appbar .right {
        position: relative;
      }
      .order-badge {
        position: absolute;
        top: -6px;
        right: -8px;
        display: none;
        min-width: 18px;
        height: 18px;
        padding: 0 5px;
        border-radius: 999px;
        background: #ef4444;
        color: #fff;
        font-size: 11px;
        font-weight: 800;
        line-height: 18px;
        text-align: center;
        box-shadow: 0 2px 6px rgba(239, 68, 68, 0.35);
        transform: translate(50%, -50%);
      }
    </style>

    <script>
      document.addEventListener('DOMContentLoaded', function () {
        var CTX = '<c:out value="${pageContext.request.contextPath}" />';

        /* ===== 소개글 기존 로직 복원 ===== */
        var p = document.getElementById('intro-text');
        var moreBtn = document.getElementById('btn-more');
        var editBtn = document.getElementById('btn-edit');
        var form = document.getElementById('intro-form');
        var ta = document.getElementById('intro-textarea');
        var count = document.getElementById('intro-count');

        var full = (p.getAttribute('data-full') || '').trim();
        var emptyText = p.getAttribute('data-empty') || '';

        function firstLine(s) {
          return (s || '').split(/\r?\n/)[0];
        }

        function renderCollapsed() {
          var show = full && full.length > 0;
          p.textContent = show ? firstLine(full) : emptyText;
          p.classList.add('clamp-1');
          p.classList.remove('clamp-1');
          p.textContent = full || '';
          var fullHeight = p.scrollHeight;
          var lh = parseFloat(window.getComputedStyle(p).lineHeight) || 20;
          p.classList.add('clamp-1');
          p.textContent = show ? firstLine(full) : emptyText;
          var needMore = show && fullHeight > lh * 1.2;
          moreBtn.style.display = needMore ? 'inline-block' : 'none';
          moreBtn.textContent = '더보기';
          moreBtn.setAttribute('data-expanded', '0');
        }

        function renderExpanded() {
          p.classList.remove('clamp-1');
          p.textContent = full || emptyText;
          moreBtn.textContent = '접기';
          moreBtn.setAttribute('data-expanded', '1');
        }

        renderCollapsed();

        moreBtn.addEventListener('click', function () {
          var expanded = moreBtn.getAttribute('data-expanded') === '1';
          if (expanded) renderCollapsed();
          else renderExpanded();
        });

        editBtn.addEventListener('click', function () {
          var open = form.style.display === 'block';
          form.style.display = open ? 'none' : 'block';
          if (!open && ta) {
            ta.focus();
            ta.setSelectionRange(ta.value.length, ta.value.length);
          }
        });

        function updateCount() {
          if (!ta) return;
          if (ta.value.length > 3000) ta.value = ta.value.substring(0, 3000);
          count.textContent = ta.value.length;
        }
        updateCount();
        ta.addEventListener('input', updateCount);

        form.addEventListener('submit', function (e) {
          e.preventDefault();
          var val = (ta.value || '').substring(0, 3000);

          fetch(form.getAttribute('action'), {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
              Accept: 'application/json',
            },
            body: 'content=' + encodeURIComponent(val),
          })
            .then(function (r) {
              return r.json();
            })
            .then(function (json) {
              if (!json || !json.ok) {
                throw new Error('저장 실패');
              }
              full = (json.content || '').trim();
              renderCollapsed();
              form.style.display = 'none';
            })
            ['catch'](function (err) {
              alert('저장 중 오류가 발생했습니다.');
              if (window.console) console.error(err);
            });
        });

        /* ====== 주문내역 뱃지 폴링 + 신규! 힌트 ====== */
        var rightBox = document.querySelector('.appbar .right');
        var orderLink = rightBox ? rightBox.querySelector('a') : null;

        var badge = document.createElement('span');
        badge.id = 'order-badge';
        badge.className = 'order-badge';
        if (rightBox) rightBox.appendChild(badge);

        function showBadge(n) {
          if (!badge) return;
          if (n > 0) {
            badge.textContent = n > 99 ? '99+' : String(n);
            badge.style.display = 'inline-block';
          } else {
            badge.style.display = 'none';
            badge.textContent = '';
          }
        }

        function parseBadgeCount() {
          if (!badge || badge.style.display === 'none') return 0;
          var t = (badge.textContent || '').trim();
          if (t === '') return 0;
          if (t.indexOf('+') !== -1) t = t.replace('+', '');
          var num = parseInt(t, 10);
          return isNaN(num) ? 0 : num;
        }

        function pollBadge() {
          fetch(CTX + '/admin/order/pendingCount', { headers: { Accept: 'application/json' } })
            .then(function (r) {
              return r.json();
            })
            .then(function (j) {
              var n = j && typeof j.count === 'number' ? j.count : 0;
              showBadge(n);
            })
            ['catch'](function () {});
        }

        pollBadge();
        var pollTimer = setInterval(pollBadge, 3000);

        function prepareNewHintAndGo() {
          var current = parseBadgeCount();
          var lastShown = 0;
          try {
            lastShown = parseInt(sessionStorage.getItem('lastBadgeCountShown') || '0', 10) || 0;
          } catch (_) {}
          if (current > lastShown) {
            try {
              sessionStorage.setItem('newPendingHint', String(current - lastShown));
              sessionStorage.removeItem('newPendingShown');
              sessionStorage.setItem('lastBadgeCountShown', String(current));
            } catch (_) {}
          } else {
            try {
              sessionStorage.setItem('newPendingHint', '0');
            } catch (_) {}
          }
          window.location.href = CTX + '/admin/orders';
        }

        if (orderLink) {
          orderLink.addEventListener('click', function (e) {
            e.preventDefault();
            prepareNewHintAndGo();
          });
        }

        var navOrderLink = document.querySelector('a[href="/order"], a[href$="/order"]');
        if (navOrderLink) {
          navOrderLink.setAttribute('href', CTX + '/admin/orders');
          navOrderLink.addEventListener('click', function (e) {
            e.preventDefault();
            prepareNewHintAndGo();
          });
        }
      });
    </script>
  </body>
</html>
