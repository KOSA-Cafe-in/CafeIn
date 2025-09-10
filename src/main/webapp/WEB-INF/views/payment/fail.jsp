<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>결제 실패</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff" />
  <%@ include file="/WEB-INF/views/common/head.jsp"%>
  <style>

    :root {
      --bg: #f6f7fb;
      --card: #ffffff;
      --text: #111827;
      --muted: #6b7280;
      --primary: #2563eb;
      --primary-pressed: #1e40af;
      --line: #e5e7eb;
      --accent: #20c8c8;
      --pill: #f0f2f7;
      --shadow: 0 6px 16px rgba(0, 0, 0, .06);
    }
    * { box-sizing: border-box; }
    html, body {
      margin: 0;
      padding: 0;
      background: var(--bg);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
                   Apple SD Gothic Neo, Helvetica, Arial, "Noto Sans KR", sans-serif;
      color: var(--text);
    }
    a { color: inherit; }
    .phone {
      max-width: 420px;
      margin: 0 auto;
      min-height: 100dvh;
      display: flex;
      flex-direction: column;
      background: #fff;
      box-shadow: var(--shadow);
    }
    .header {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 14px 16px;
      border-bottom: 1px solid var(--line);
      position: sticky;
      top: 0;
      background: #fff;
      z-index: 10;
    }
    .header-title {
      font-size: 16px;
      font-weight: 700;
    }
    .content {
      padding: 20px 16px 24px;
      display: flex;
      flex-direction: column;
      gap: 16px;
      flex: 1 1 auto;
      background: var(--bg);
    }
    .card {
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 18px;
    }
    .title {
      margin: 0 0 6px 0;
      font-size: 20px;
      font-weight: 800;
      letter-spacing: -0.3px;
    }
    .muted { color: var(--muted); }
    .btn-row {
      display: flex;
      gap: 10px;
      margin-top: 8px;
    }
    .btn {
      flex: 1 1 0;
      padding: 12px 16px;
      text-align: center;
      border-radius: 10px;
      text-decoration: none;
      font-weight: 700;
      border: 1px solid var(--line);
      background: #fff;
    }
    .btn-primary {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
    }
    .btn-primary:active { background: var(--primary-pressed); }
    .big-emoji {
      font-size: 42px;
      line-height: 1;
    }
    .info-list { margin: 0; padding: 0; list-style: none; }
    .info-list li { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dashed var(--line); }
    .info-list li:last-child { border-bottom: 0; }
    .safe-bottom { height: env(safe-area-inset-bottom); }

  </style>
</head>
<body>
  <div class="phone">
        <!-- Header -->
    <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="backLink" value="true" />
      <jsp:param name="title" value="결제하기" />
      <jsp:param name="showOrderHistory" value="false" />
    </jsp:include>
    
    <div class="content">
      <div class="card" style="text-align:center;">
        <div class="big-emoji">⚠️</div>
        <h1 class="title">결제를 완료하지 못했어요</h1>
        <p class="muted">아래 사유를 확인하시고 다시 시도해 주세요.</p>
      </div>

      <c:if test="${not empty errorMsg}">
        <div class="card">
          <h3 style="margin:0 0 10px 0;">실패 사유</h3>
          <p class="muted">${errorMsg}</p>
        </div>
      </c:if>

      <div class="btn-row">
        <a href="<c:url value='/user/home'/>" class="btn">홈으로</a>
        <a href="<c:url value='/user/cart'/>" class="btn btn-primary">장바구니로 돌아가기</a>
      </div>
    </div>

    <div class="safe-bottom"></div>
    <jsp:include page="/WEB-INF/views/common/nav.jsp">
      <jsp:param name="active" value="cart" />
      <jsp:param name="showOrderHistory" value="false" />
    </jsp:include>
  </div>
</body>
</html>
