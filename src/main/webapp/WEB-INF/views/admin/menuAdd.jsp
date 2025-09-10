<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>메뉴 추가</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
  <%@ include file="/WEB-INF/views/common/head.jsp" %>

  <style>
    .menu-add-wrap {
      max-width: 560px;
      margin: 0 auto;
      padding: 24px;
    }

    .page-title {
      font-size: 20px;
      font-weight: bold;
      text-align: center;
      margin-bottom: 20px;
    }

    .form-top {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
      align-items: center;
    }

    .image-box {
      width: 100px;
      height: 100px;
      flex: 0 0 auto;
    }

    .image-label {
      display: inline-block;
      cursor: pointer;
    }

    .image-preview {
      width: 100px;
      height: 100px;
      border: 2px dashed #ccc;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #f5f5f5;
      overflow: hidden;
      flex-shrink: 0;
    }

    .image-preview span {
      font-size: 28px;
      color: #aaa;
    }

    .input-group {
      flex: 1 1 200px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .input-group input {
      padding: 10px;
      font-size: 14px;
      width: 100%;
      border: 1px solid #ccc;
      border-radius: 12px;
    }

    .desc-box {
      margin-top: 20px;
    }

    .desc-label {
      font-weight: bold;
      margin-bottom: 4px;
      display: block;
    }

    .desc-box textarea {
      width: 100%;
      height: 120px;
      padding: 10px;
      font-size: 14px;
      resize: none;
      border: 1px solid #ccc;
      border-radius: 12px;
    }

    .btn-wrap {
      display: flex;
      justify-content: center;
      margin: 24px 0 80px;
    }

    .submit-btn {
      padding: 14px 24px;
      font-size: 16px;
      background: #2e6cff;
      color: white;
      border: none;
      border-radius: 12px;
      width: 100%;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="phone">
  <!-- 헤더 include -->
  <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="backLink" value="${pageContext.request.contextPath}/admin/home" />
    <jsp:param name="title" value="메뉴 추가" />
    <jsp:param name="showOrderHistory" value="false" />
  </jsp:include>

  <main class="content">
    <form action="${pageContext.request.contextPath}/admin/menu/add" method="post" enctype="multipart/form-data">
      <div class="form-top">
        <!-- 이미지 업로드 박스 -->
        <div class="image-box">
          <label for="image" class="image-label">
            <div class="image-preview" id="imagePreview">
              <span>+</span>
            </div>
          </label>
          <input type="file" id="image" name="image" accept="image/*" style="display:none;" required />
        </div>

        <!-- 메뉴명, 가격 -->
        <div class="input-group">
          <input type="text" name="name" placeholder="메뉴이름" required />
          <input type="text" name="price" placeholder="메뉴가격" required oninput="formatPrice(this)" />
        </div>
      </div>

      <!-- 설명 -->
      <div class="desc-box">
        <label class="desc-label" for="content">설명</label>
        <textarea name="content" placeholder="메뉴설명" id="content" readonly onfocus="this.removeAttribute('readonly')"></textarea>
      </div>

      <!-- 제출 -->
      <div class="btn-wrap">
        <button type="submit" class="submit-btn">메뉴 추가하기</button>
      </div>
    </form>
  </main>

  <!-- 하단 내비게이션 include -->
  <jsp:include page="/WEB-INF/views/common/nav.jsp">
    <jsp:param name="active" value="home" />
  </jsp:include>
</div>

<script>
  function formatPrice(input) {
    let value = input.value.replace(/[^\d]/g, '');
    input.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }

  document.addEventListener("DOMContentLoaded", function () {
    const fileInput = document.getElementById("image");
    const preview = document.getElementById("imagePreview");

    fileInput.addEventListener("change", function () {
      const file = this.files[0];
      if (!file) {
        preview.innerHTML = '<span>+</span>';
        return;
      }

      const reader = new FileReader();
      reader.onload = function (e) {
        preview.innerHTML = "";
        const img = document.createElement("img");
        img.src = e.target.result;
        img.alt = "미리보기";
        img.style.width = "100%";
        img.style.height = "100%";
        img.style.objectFit = "cover";
        img.style.borderRadius = "6px";
        img.style.display = "block";
        preview.appendChild(img);
      };

      reader.readAsDataURL(file);
    });

    // ✅ 전송 전 콤마 제거
    const form = document.querySelector("form");
    form.addEventListener("submit", function () {
      const priceInput = form.querySelector("input[name='price']");
      priceInput.value = priceInput.value.replace(/[^\d]/g, ''); // 콤마 제거
    });
  });
</script>

</body>
</html>
