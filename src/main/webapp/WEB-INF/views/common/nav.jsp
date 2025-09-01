<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="nav" aria-label="하단 내비게이션">
  <ul>
    <li class="${param.active == 'home' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/" style="color: inherit; text-decoration: none;">
        <span class="ico">🏠</span>홈
      </a>
    </li>
    <li class="${param.active == 'order' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/order" style="color: inherit; text-decoration: none;">
        <span class="ico">🧾</span>주문
      </a>
    </li>
    <li class="${param.active == 'notification' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/notification" style="color: inherit; text-decoration: none;">
        <span class="ico">🔔</span>알림
      </a>
    </li>
    <li class="${param.active == 'setting' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/setting" style="color: inherit; text-decoration: none;">
        <span class="ico">⚙️</span>설정
      </a>
    </li>
  </ul>
</nav>
