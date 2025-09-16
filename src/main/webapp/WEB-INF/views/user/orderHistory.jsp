<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
  <%@ include file="/WEB-INF/views/common/head.jsp"%>
  <title>주문 내역</title>
  <style>
    :root{
      /* home.jsp와 같은 프레임 비율/톤으로 맞춤 */
      --phone-w: 9;   /* 필요 시 home.jsp 값으로 교체 */
      --phone-h: 16;

      --bg:#f9fafb; --card:#ffffff; --text:#0f172a; --muted:#6b7280; --border:#e5e7eb;
      --accent:#2563eb;
      --ok-bg:#ecfdf5; --ok:#065f46;
      --ing-bg:#eef2ff; --ing:#3730a3;
    }

    /* Phone frame (home.jsp와 동일 컨셉) */
    .phone { max-width:430px; }
    .phone-shell{
      position:relative; border:1px solid var(--border); border-radius:28px;
      background:var(--card); box-shadow:0 12px 30px rgba(0,0,0,.08); overflow:hidden;
      aspect-ratio: calc(var(--phone-w) / var(--phone-h));
    }
    @supports not (aspect-ratio: 1/1){
      .phone-shell::before{ content:""; display:block; padding-top:calc(var(--phone-h)/var(--phone-w)*100%); }
    }
    .phone-inner{ position:absolute; inset:0; display:flex; flex-direction:column; background:var(--bg); }

    /* 본문(리스트) */
    .content{ flex:1 1 auto; overflow:auto; padding:8px 8px 12px; }
    .empty{ text-align:center; color:#9ca3af; padding:36px 0; }

    .list{ display:flex; flex-direction:column; }
    a.row{
      display:flex; align-items:center; gap:12px; text-decoration:none; color:inherit;
      padding:14px 12px; border-bottom:1px solid var(--border); background:transparent;
    }
    a.row:active{ background:#f3f4f6; }
    .info{ flex:1; min-width:0; }
    .title{ font-weight:800; font-size:15px; margin-bottom:2px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .meta{ font-size:12px; color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .dot{ margin:0 6px; }
    .status{ font-size:12px; padding:4px 10px; border-radius:999px; border:1px solid transparent; flex:0 0 auto; }
    .done{ background:var(--ok-bg); color:var(--ok); }
    .ing { background:var(--ing-bg); color:var(--ing); }

    /* 하단 탭(nav) — home.jsp 구조 재현 */
    .tabbar{
      flex:0 0 auto;
      background:var(--card); border-top:1px solid var(--border);
      display:grid; grid-template-columns:repeat(4,1fr); gap:4px; padding:8px 6px;
    }
    .tab{ text-align:center; font-size:11px; color:#6b7280; text-decoration:none; padding:6px 4px; }
    .tab .ico{ font-size:20px; display:block; margin-bottom:4px; }
    .tab.active{ color:var(--accent); font-weight:700; }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="phone">
		<!-- 헤더 include -->
		<jsp:include page="/WEB-INF/views/common/header.jsp">
            <jsp:param name="backLink" value="true" />
			<jsp:param name="title" value="메뉴" />
			<jsp:param name="showOrderHistory" value="false" />
		</jsp:include>

      <!-- ✅ main: 주문 정보 + 상태만 노출 -->
      <main class="content">
        <c:if test="${empty orders}">
          <div class="empty">주문 내역이 없습니다.</div>
        </c:if>

        <div class="list">
          <c:forEach var="o" items="${orders}">
            <a class="row" href="${ctx}/orderHistoryDetail/${o.orderId}" data-merchant-uid="${o.merchantUid}">
              <div class="info">
                <div class="title">주문 #${o.orderId}</div>
                <div class="meta">
                  <fmt:formatDate value="${o.createdDate}" pattern="yyyy-MM-dd HH:mm"/>
                  <span class="dot">·</span>
                  <fmt:formatNumber value="${o.totalPrice}" type="number"/>원
                </div>
              </div>
              <span class="status ${o.status == 'Y' ? 'done' : 'ing'}">
                <c:choose>
                  <c:when test="${o.status == 'Y'}">제조완료</c:when>
                  <c:otherwise>제조중</c:otherwise>
                </c:choose>
              </span>
            </a>
          </c:forEach>
        </div>
      </main>

		<!-- 하단 네비게이션 include -->
		<jsp:include page="/WEB-INF/views/common/nav.jsp">
			<jsp:param name="active" value="home" />
		</jsp:include>
</div>

<script>
  setInterval(function(){
    document.querySelectorAll('[data-merchant-uid]').forEach(function(row){
      var uid = row.getAttribute('data-merchant-uid');
      if(!uid) return;
      fetch('${ctx}/order/status?merchantUid=' + encodeURIComponent(uid))
        .then(r => r.ok ? r.json() : null)
        .then(d => {
          if(!d) return;
          var badge = row.querySelector('.status');
          var done = d.status === 'Y';
          badge.textContent = done ? '제조완료' : '제조중';
          badge.classList.toggle('done', done);
          badge.classList.toggle('ing', !done);
        }).catch(()=>{});
    });
  }, 10000);
</script>
</body>
</html>
