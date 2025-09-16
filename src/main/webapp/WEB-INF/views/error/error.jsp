<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page session="false" %> <%@
page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 에러페이지 (담당 : 나규태) -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>에러</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta name="theme-color" content="#ffffff" />
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
      .error-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 20px;
        text-align: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
      }

      .error-card {
        background: rgba(255, 255, 255, 0.95);
        color: #333;
        padding: 40px;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        max-width: 500px;
        width: 100%;
      }

      .error-icon {
        font-size: 80px;
        margin-bottom: 20px;
        color: #ff6b6b;
      }

      .error-title {
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #2c3e50;
      }

      .error-message {
        font-size: 16px;
        margin-bottom: 30px;
        color: #7f8c8d;
        line-height: 1.6;
      }

      .error-actions {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
      }

      .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        display: inline-block;
      }

      .btn-primary {
        background: #3498db;
        color: white;
      }

      .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
      }

      .btn-secondary {
        background: #95a5a6;
        color: white;
      }

      .btn-secondary:hover {
        background: #7f8c8d;
        transform: translateY(-2px);
      }

      .btn-home {
        background: #27ae60;
        color: white;
      }

      .btn-home:hover {
        background: #229954;
        transform: translateY(-2px);
      }

      /* 반응형 처리 */
      @media (max-width: 600px) {
        .error-card {
          padding: 30px 20px;
        }

        .error-icon {
          font-size: 60px;
        }

        .error-title {
          font-size: 24px;
        }

        .error-actions {
          flex-direction: column;
        }

        .btn {
          width: 100%;
        }
      }
    </style>
  </head>
  <body>
    <div class="phone">
      <div class="error-card">
        <div class="error-icon">🚫</div>
        <h1 class="error-title">접근이 제한되었습니다</h1>
        <p class="error-message">
          <c:out value="${errorMessage}" default="해당 페이지에 접근할 권한이 없습니다." />
          <br /><br />
          올바른 권한으로 로그인하거나 관리자에게 문의해주세요.
        </p>
      </div>
    </div>
  </body>
</html>
