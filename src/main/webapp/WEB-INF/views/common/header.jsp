<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="appbar">
  <div class="left">
    <c:if test="${param.backLink != null}">
      <a href="javascript:history.back()" style="color: var(--primary); font-weight: 700; font-size: 14px; text-decoration: none;">
        <i class="fa-solid fa-angle-left"></i>
      </a>
    </c:if>
  </div>
  
  <div class="title">${param.title != null ? param.title : ''}</div>
  
  <div class="right">
    <c:if test="${param.showOrderHistory != 'false'}">
      <a href="${pageContext.request.contextPath}/admin/order/history">주문내역</a>
    </c:if>
  </div>
</header>