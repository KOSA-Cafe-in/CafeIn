<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 메뉴 정보 수정 페이지 (담당 : 손윤찬) -->
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>메뉴 정보 수정</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#ffffff"/>
  <%@ include file="/WEB-INF/views/common/head.jsp" %>

  <style>
    .menu-add-wrap { max-width: 560px; margin: 0 auto; padding: 24px; }
    .page-title { font-size: 20px; font-weight: bold; text-align: center; margin-bottom: 20px; }
    .form-top { display: flex; flex-wrap: wrap; gap: 16px; align-items: center; }
    .image-box { width: 100px; height: 100px; flex: 0 0 auto; }
    .image-label { display: inline-block; cursor: pointer; }
    .image-preview { width: 100px; height: 100px; border: 2px dashed #ccc; display: flex;
                     align-items: center; justify-content: center; background: #f5f5f5;
                     overflow: hidden; flex-shrink: 0; border-radius: 6px; }
    .image-preview img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .image-preview span { font-size: 28px; color: #aaa; }
    .input-group { flex: 1 1 200px; display: flex; flex-direction: column; gap: 8px; }
    .input-group input { padding: 10px; font-size: 14px; width: 100%; border: 1px solid #ccc; border-radius: 12px; }
    .desc-box { margin-top: 20px; }
    .desc-label { font-weight: bold; margin-bottom: 4px; display: block; }
    .desc-box textarea { width: 100%; height: 120px; padding: 10px; font-size: 14px; resize: none;
                         border: 1px solid #ccc; border-radius: 12px; }

    /* 버튼 영역 */
    .btn-wrap {
      display: flex;
      flex-direction: column;
      gap: 10px;              /* 버튼 간격 조금 */
      margin: 20px 0 8px;     /* 하단 여백 줄여서 삭제 버튼과 더 붙게 */
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
    .danger-btn {
      padding: 14px 24px;
      font-size: 16px;
      background: #e63f2a;
      color: white;
      border: none;
      border-radius: 12px;
      width: 100%;           /* 수정하기와 동일 너비 */
      cursor: pointer;
    }

    /* 삭제 폼을 수정 폼과 같은 폭/패딩으로 맞춤 */
    #deleteForm {
      max-width: 560px;
      margin: 8px auto 80px; /* 위쪽 살짝 붙이고 아래는 페이지 하단 여백 */
      padding: 0 24px;       /* 수정 폼(menu-add-wrap)의 좌우 패딩과 동일 */
    }

    .hint { font-size: 12px; color: #888; margin-top: 6px; }
  </style>
</head>
<body>
<div class="phone">
  <!-- 헤더 -->
  <jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="backLink" value="${pageContext.request.contextPath}/admin/home" />
    <jsp:param name="title" value="메뉴정보 수정" />
    <jsp:param name="showOrderHistory" value="false" />
  </jsp:include>

  <main class="content">
    <!-- 수정 폼 -->
    <form id="updateForm" class="menu-add-wrap"
          action="${pageContext.request.contextPath}/admin/menu/update"
          method="post" enctype="multipart/form-data">

      <!-- id 전송 -->
      <input type="hidden" name="menuId" value="${menu.menuId}" />

      <div class="form-top">
        <!-- 이미지 업로드 -->
        <div class="image-box">
          <label for="image" class="image-label">
            <div class="image-preview" id="imagePreview">
              <c:choose>
                <c:when test="${not empty menu.menuPictureUrl}">
                  <img src="${menu.menuPictureUrl}" alt="이미지 미리보기">
                </c:when>
                <c:otherwise>
                  <span>+</span>
                </c:otherwise>
              </c:choose>
            </div>
          </label>
          <input type="file" id="image" name="image" accept="image/*" style="display:none;" />
        </div>

        <!-- 이름, 가격 -->
        <div class="input-group">
          <input type="text" name="name" placeholder="메뉴이름" value="${menu.name}" required />
          <input type="text" name="price" placeholder="메뉴가격"
                 value="<c:out value='${menu.price}'/>"
                 required oninput="formatPrice(this)" />
        </div>
      </div>

      <!-- 설명 -->
      <div class="desc-box">
        <label class="desc-label" for="content">설명</label>
        <textarea name="content" id="content" maxlength="1000"
                  placeholder="메뉴설명">${menu.content}</textarea>
      </div>

      <div class="btn-wrap">
        <button type="submit" class="submit-btn">수정하기</button>
      </div>
    </form>

    <!-- ✅ 삭제 폼은 updateForm 밖으로 분리 (시각적으로는 붙여 보이게) -->
    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/menu/delete"
          method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
      <input type="hidden" name="id" value="${menu.menuId}" />
      <button type="submit" class="danger-btn">삭제하기</button>
    </form>
  </main>

  <jsp:include page="/WEB-INF/views/common/nav.jsp">
    <jsp:param name="active" value="home" />
  </jsp:include>
</div>

<script>
  // 가격 입력 포맷
  function formatPrice(input) {
    var v = (input.value || '').replace(/[^\d]/g, '');
    input.value = v.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }

  document.addEventListener('DOMContentLoaded', function () {
    var priceInput = document.querySelector("input[name='price']");
    if (priceInput) {
      // 1) 초기 표시를 콤마로 포맷
      priceInput.value = (priceInput.value || '').replace(/[^\d]/g, '')
                         .replace(/\B(?=(\d{3})+(?!\d))/g, ',');

      // 2) 입력 시 포맷
      priceInput.addEventListener('input', function(){ formatPrice(priceInput); });

      // 3) 제출 전 콤마 제거
      var form = priceInput.form;
      form.addEventListener('submit', function(){
        priceInput.value = priceInput.value.replace(/[^\d]/g, '');
      });
    }
  });
</script>

</body>
</html>
