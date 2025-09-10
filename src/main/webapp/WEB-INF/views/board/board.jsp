<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%@ page session="false" %> <%@ page
language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta name="theme-color" content="#ffffff" />
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
      /* 기본 스타일 */
      body {
        font-family: 'Pretendard', sans-serif;
      }
      .container {
        max-width: 800px;
        margin: 0 auto;
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .board-container {
        background: #f2f4f6;
        border: none;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 10px;
      }
      .board-header {
        font-weight: bold;
      }
      .board-body {
        margin-top: 5px;
      }
      .board-input {
        width: 100%;
        background-color: #f2f4f6;
        border: none;
        word-wrap: break-word;
        word-break: break-all;
        white-space: pre-wrap;
        outline: none;
        resize: none; /* textarea 크기 조절 핸들 제거 */
        overflow: hidden; /* 스크롤바 숨김 */
        min-height: 20px; /* 최소 높이 */
        padding: 8px;
        font-family: inherit;
      }

      .board-input.title-input {
        height: auto;
        min-height: 20px;
      }

      .board-input.content-input {
        min-height: 80px;
        height: auto;
      }
      .board-btn {
        background-color: #1d4ed8;
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
        margin-right: 5px;
      }
      .board-btn:hover {
        background-color: #2563eb;
      }
      .board-footer {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px solid #e5e7eb;
      }
      .board-div {
        display: flex;
        flex-direction: column;
        padding: 5px 0;
      }
      .board-image {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        margin-top: 10px;
        border: 1px solid #e5e7eb;
      }
      .board-image-container {
        margin-top: 10px;
        text-align: center;
      }

      .action-buttons {
        display: flex;
        gap: 10px;
      }

      .action-btn {
        background: none;
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 5px;
        padding: 5px 10px;
        border-radius: 5px;
        color: #6b7280;
        font-size: 14px;
      }

      .action-btn:hover {
        background-color: #f3f4f6;
        color: #374151;
      }

      .submit-btn {
        background-color: #1d4ed8;
        color: white;
        padding: 8px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 500;
      }

      .submit-btn:hover {
        background-color: #2563eb;
      }

      .submit-btn:disabled {
        background-color: #d1d5db;
        cursor: not-allowed;
      }

      /* 파일 입력 숨김 */
      .file-input {
        display: none;
      }

      /* 이미지 미리보기 */
      .image-preview {
        margin-top: 10px;
        max-width: 100%;
      }

      .preview-image {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
      }

      .remove-image {
        margin-top: 5px;
        background: #ef4444;
        color: white;
        border: none;
        padding: 2px 8px;
        border-radius: 3px;
        font-size: 12px;
        cursor: pointer;
      }

      /* 게시글 헤더 레이아웃 */
      .board-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: bold;
        position: relative; /* 드롭다운 위치 기준점 */
      }

      /* 메뉴 버튼 */
      .menu-button {
        background: none;
        border: none;
        cursor: pointer;
        padding: 5px;
        border-radius: 50%;
        color: #6b7280;
        font-size: 18px;
        line-height: 1;
        position: relative;
      }

      .menu-button:hover {
        background-color: #f3f4f6;
        color: #374151;
      }

      /* 드롭다운 메뉴 */
      .dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        min-width: 120px;
        z-index: 1000;
        display: none;
      }

      .dropdown-menu.active {
        display: block;
      }

      .dropdown-item {
        display: block;
        width: 100%;
        padding: 8px 16px;
        text-align: left;
        border: none;
        background: none;
        cursor: pointer;
        font-size: 14px;
        color: #374151;
        text-decoration: none;
      }

      .dropdown-item:hover {
        background-color: #f3f4f6;
      }

      .dropdown-item:first-child {
        border-radius: 8px 8px 0 0;
      }

      .dropdown-item:last-child {
        border-radius: 0 0 8px 8px;
      }

      .dropdown-item.delete {
        color: #ef4444;
      }

      .dropdown-item.delete:hover {
        background-color: #fef2f2;
      }

      /* 수정 모드 스타일 */
      .edit-mode {
        border: 2px solid #3b82f6;
        border-radius: 12px;
        background-color: #f8fafc;
      }

      .edit-buttons {
        margin-top: 10px;
        display: flex;
        gap: 10px;
        justify-content: flex-end;
      }

      .edit-buttons .board-btn {
        padding: 6px 16px;
        font-size: 14px;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        color: white;
        font-weight: 500;
      }

      .edit-buttons .board-btn:hover {
        opacity: 0.9;
      }

      .edit-buttons .board-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
      }
    </style>
  </head>
  <body>
    <div class="phone">
      <!-- 헤더 include -->
      <jsp:include page="/WEB-INF/views/common/header.jsp">
        <jsp:param name="backLink" value="true" />
        <jsp:param name="title" value="게시판" />
        <jsp:param name="showOrderHistory" value="false" />
      </jsp:include>

      <!-- 본문 -->
      <main class="content">
        <div class="board-container">
          <div class="board-header">
            <input class="board-input title-input" placeholder="제목" id="titleInput" />
          </div>
          <div class="board-body">
            <textarea
              class="board-input content-input"
              placeholder="내용"
              id="contentInput"
            ></textarea>

            <!-- 이미지 미리보기 -->
            <div class="image-preview" id="imagePreview" style="display: none">
              <img class="preview-image" id="previewImg" src="" alt="미리보기" />
              <button class="remove-image" onclick="removeImage()">이미지 제거</button>
            </div>
          </div>

          <!-- 액션 버튼들 -->
          <div class="board-footer">
            <div class="action-buttons">
              <!-- 사진 추가 버튼 -->
              <button class="action-btn" onclick="triggerFileInput()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z" />
                  <path
                    d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093L8.71 9.58l-2.84-2.84a.5.5 0 0 0-.707 0L1.002 10.914V3a1 1 0 0 1 1-1h12z"
                  />
                </svg>
                사진
              </button>
            </div>

            <!-- 등록 버튼 -->
            <button class="submit-btn" onclick="submitBoard()" id="submitBtn">등록</button>
          </div>

          <!-- 숨겨진 파일 입력 -->
          <input
            type="file"
            class="file-input"
            id="fileInput"
            accept="image/*"
            onchange="handleFileSelect(event)"
          />
        </div>

        <!-- 게시글 섹션 -->
        <div class="boards-container">
          <c:forEach var="board" items="${board}" varStatus="status">
            <div class="board-div">
              <div class="board-header">
                <span
                  >${board.nickname} ·
                  <fmt:formatDate value="${board.createdDate}" pattern="yyyy년 M월 d일 HH시 mm분"
                /></span>
                <!-- 메뉴 버튼 -->
                <button class="menu-button" onclick="toggleDropdown('${status.index}')">⋯</button>
                <!-- 드롭다운 메뉴 -->
                <div class="dropdown-menu" id="dropdown-${status.index}">
                  <button class="dropdown-item" onclick="editBoard('${board.boardId}')">
                    수정
                  </button>
                  <button class="dropdown-item delete" onclick="deleteBoard('${board.boardId}')">
                    삭제
                  </button>
                </div>
              </div>
              <div class="board-body">
                <p style="font-weight: 800">${board.title}</p>
                <p>${board.content}</p>
                <!-- 이미지가 있으면 표시 -->
                <c:if test="${not empty board.boardPictureUrl}">
                  <div class="board-image-container">
                    <img
                      src="${board.boardPictureUrl}"
                      alt="게시글 이미지"
                      class="board-image"
                      onerror="this.style.display='none'"
                    />
                  </div>
                </c:if>
              </div>
            </div>
            <hr />
          </c:forEach>
        </div>
      </main>
      <!-- 하단 네비게이션 include -->
      <jsp:include page="/WEB-INF/views/common/nav.jsp">
        <jsp:param name="active" value="board" />
      </jsp:include>
    </div>

    <script>
      // textarea 자동 크기 조절 함수
      function autoResize(textarea) {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
      }

      // 파일 선택 트리거
      function triggerFileInput() {
        document.getElementById('fileInput').click();
      }

      // 파일 선택 처리
      function handleFileSelect(event) {
        const file = event.target.files[0];
        if (file) {
          // 이미지 파일인지 확인
          if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function (e) {
              const previewImg = document.getElementById('previewImg');
              const imagePreview = document.getElementById('imagePreview');

              previewImg.src = e.target.result;
              imagePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
          } else {
            alert('이미지 파일만 업로드 가능합니다.');
            event.target.value = ''; // 파일 선택 초기화
          }
        }
      }

      // 이미지 제거
      function removeImage() {
        const imagePreview = document.getElementById('imagePreview');
        const fileInput = document.getElementById('fileInput');

        imagePreview.style.display = 'none';
        fileInput.value = ''; // 파일 선택 초기화
      }

      // 게시글 등록
      function submitBoard() {
        const title = document.getElementById('titleInput').value.trim();
        const content = document.getElementById('contentInput').value.trim();
        const fileInput = document.getElementById('fileInput');

        // 유효성 검사
        if (!title) {
          alert('제목을 입력해주세요.');
          document.getElementById('titleInput').focus();
          return;
        }

        if (!content) {
          alert('내용을 입력해주세요.');
          document.getElementById('contentInput').focus();
          return;
        }

        // 버튼 비활성화
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = '등록 중...';

        // 폼 데이터 준비
        const formData = new FormData();
        formData.append('title', title);
        formData.append('content', content);

        // 이미지 파일이 있으면 추가
        if (fileInput.files[0]) {
          formData.append('pictureFile', fileInput.files[0]);
        }

        // 서버로 전송
        submitBoardToServer(formData)
          .then((response) => {
            if (response.success) {
              alert('게시글이 등록되었습니다.');
              // 폼 초기화
              clearForm();
              // 게시글 목록 새로고침 (추후 구현)
              location.reload();
            } else {
              alert('게시글 등록에 실패했습니다: ' + response.message);
            }
          })
          .catch((error) => {
            console.error('등록 오류:', error);
            alert('게시글 등록 중 오류가 발생했습니다.');
          })
          .finally(() => {
            // 버튼 재활성화
            submitBtn.disabled = false;
            submitBtn.textContent = '등록';
          });
      }

      // 서버 전송 함수 (통합 처리)
      async function submitBoardToServer(formData) {
        console.log('전송할 데이터:');
        console.log('title:', formData.get('title'));
        console.log('content:', formData.get('content'));

        const pictureFile = formData.get('pictureFile');
        console.log('pictureFile:', pictureFile);

        try {
          const submitFormData = new FormData();
          submitFormData.append('title', formData.get('title'));
          submitFormData.append('content', formData.get('content'));

          // 이미지 파일이 있으면 추가
          if (pictureFile && pictureFile instanceof File && pictureFile.size > 0) {
            submitFormData.append('image', pictureFile);
            console.log('이미지 파일 포함해서 전송');
          } else {
            console.log('이미지 없이 전송');
          }

          // 한 번의 요청으로 모든 것 처리
          const response = await fetch('/api/board', {
            method: 'POST',
            headers: {
              Accept: 'application/json',
              // Content-Type 설정하지 않음 (FormData 사용 시 브라우저가 자동 설정)
            },
            body: submitFormData,
          });

          console.log('응답 상태:', response.status);

          if (!response.ok) {
            const errorText = await response.text();
            console.error('서버 오류 응답:', errorText);
            throw new Error(`HTTP error! status: ${response.status}`);
          }

          const result = await response.json();
          console.log('서버 응답:', result);
          return result;
        } catch (error) {
          console.error('서버 요청 오류:', error);
          throw error;
        }
      }

      // 폼 초기화
      function clearForm() {
        document.getElementById('titleInput').value = '';
        document.getElementById('contentInput').value = '';
        removeImage();
        autoResize(document.getElementById('contentInput'));
      }

      // 페이지 로드 후 이벤트 리스너 추가
      document.addEventListener('DOMContentLoaded', function () {
        const contentInput = document.getElementById('contentInput');

        if (contentInput) {
          // 입력할 때마다 크기 자동 조절
          contentInput.addEventListener('input', function () {
            autoResize(this);
          });

          // 초기 크기 설정
          autoResize(contentInput);
        }

        // 전체 화면 클릭 시 드롭다운 닫기
        document.addEventListener('click', function (event) {
          if (!event.target.closest('.menu-button')) {
            closeAllDropdowns();
          }
        });
      });

      // 드롭다운 토글
      function toggleDropdown(index) {
        const dropdown = document.getElementById('dropdown-' + index);
        const isActive = dropdown.classList.contains('active');

        // 모든 드롭다운 닫기
        closeAllDropdowns();

        // 현재 드롭다운만 토글
        if (!isActive) {
          dropdown.classList.add('active');
        }
      }

      // 모든 드롭다운 닫기
      function closeAllDropdowns() {
        const dropdowns = document.querySelectorAll('.dropdown-menu');
        dropdowns.forEach((dropdown) => {
          dropdown.classList.remove('active');
        });
      }

      // 게시글 수정 (인라인 수정 모드)
      function editBoard(boardId) {
        closeAllDropdowns();

        // 현재 수정 모드인 게시글이 있으면 취소
        const existingEditForm = document.querySelector('.edit-mode');
        if (existingEditForm) {
          cancelEdit();
        }

        // 이벤트 객체를 통해 클릭된 버튼 찾기
        const clickedButton = event.target;
        const boardDiv = clickedButton.closest('.board-div');

        if (!boardDiv) {
          console.error('게시글을 찾을 수 없습니다.');
          return;
        }

        const titleElement = boardDiv.querySelector('.board-body p[style="font-weight: 800"]');
        const allParagraphs = boardDiv.querySelectorAll('.board-body p');
        const contentElement = allParagraphs[1]; // Second paragraph is content

        if (!titleElement || !contentElement) {
          console.error(
            '제목 또는 내용 요소를 찾을 수 없습니다.',
            'titleElement:',
            titleElement,
            'contentElement:',
            contentElement
          );
          return;
        }

        const currentTitle = titleElement.textContent.trim();
        const currentContent = contentElement.textContent.trim();

        // 원본 텍스트 저장 (취소 시 복원용)
        boardDiv.setAttribute('data-original-title', currentTitle);
        boardDiv.setAttribute('data-original-content', currentContent);
        boardDiv.setAttribute('data-board-id', boardId);

        // HTML 이스케이프 함수
        function escapeHtml(text) {
          const div = document.createElement('div');
          div.textContent = text;
          return div.innerHTML;
        }

        // 제목을 입력창으로 변경
        const titleInput = document.createElement('input');
        titleInput.type = 'text';
        titleInput.className = 'board-input title-input edit-title';
        titleInput.value = currentTitle;
        titleInput.style.cssText = 'font-weight: 800; width: 100%;';
        titleElement.innerHTML = '';
        titleElement.appendChild(titleInput);

        // 내용을 텍스트영역으로 변경
        const contentTextarea = document.createElement('textarea');
        contentTextarea.className = 'board-input content-input edit-content';
        contentTextarea.value = currentContent;
        contentTextarea.style.cssText = 'width: 100%; min-height: 80px;';
        contentElement.innerHTML = '';
        contentElement.appendChild(contentTextarea);

        // 버튼 영역 추가
        const buttonArea = document.createElement('div');
        buttonArea.className = 'edit-buttons';
        buttonArea.style.cssText =
          'margin-top: 10px; display: flex; gap: 10px; justify-content: flex-end;';
        buttonArea.innerHTML = `
          <button onclick="saveEditFromButton(this)" class="board-btn" style="background-color: #10b981;">저장</button>
          <button onclick="cancelEdit()" class="board-btn" style="background-color: #6b7280;">취소</button>
        `;

        // 게시글 본문 끝에 버튼 추가
        const boardBody = boardDiv.querySelector('.board-body');
        boardBody.appendChild(buttonArea);

        // 수정 모드 표시
        boardDiv.classList.add('edit-mode');

        // 텍스트영역 자동 크기 조절
        const textarea = boardDiv.querySelector('.edit-content');
        autoResize(textarea);
        textarea.addEventListener('input', function () {
          autoResize(this);
        });
      }

      // 저장 버튼에서 boardId 찾아서 saveEdit 호출
      function saveEditFromButton(button) {
        const boardDiv = button.closest('.board-div');
        const boardId = boardDiv.getAttribute('data-board-id');
        saveEdit(boardId);
      }

      // 수정 저장
      function saveEdit(boardId) {
        const boardDiv = document.querySelector('.edit-mode');
        const titleInput = boardDiv.querySelector('.edit-title');
        const contentTextarea = boardDiv.querySelector('.edit-content');

        const newTitle = titleInput.value.trim();
        const newContent = contentTextarea.value.trim();

        if (!newTitle || !newContent) {
          alert('제목과 내용을 모두 입력해주세요.');
          return;
        }

        // 저장 버튼 비활성화
        const saveBtn = boardDiv.querySelector('button[onclick*="saveEdit"]');
        saveBtn.disabled = true;
        saveBtn.textContent = '저장 중...';

        // 서버에 수정 요청
        const formData = new FormData();
        formData.append('title', newTitle);
        formData.append('content', newContent);

        fetch('/api/board/' + boardId, {
          method: 'PATCH',
          headers: {
            Accept: 'application/json',
          },
          body: formData,
        })
          .then((response) => response.json())
          .then((result) => {
            if (result.success) {
              // 성공 시 수정 모드 해제하고 새 내용으로 업데이트
              exitEditMode(boardDiv, newTitle, newContent);
              alert('게시글이 수정되었습니다.');
            } else {
              alert('게시글 수정에 실패했습니다: ' + result.message);
              // 버튼 재활성화
              saveBtn.disabled = false;
              saveBtn.textContent = '저장';
            }
          })
          .catch((error) => {
            console.error('수정 오류:', error);
            alert('게시글 수정 중 오류가 발생했습니다.');
            // 버튼 재활성화
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
          });
      }

      // 수정 취소
      function cancelEdit() {
        const boardDiv = document.querySelector('.edit-mode');
        if (!boardDiv) return;

        const originalTitle = boardDiv.getAttribute('data-original-title');
        const originalContent = boardDiv.getAttribute('data-original-content');

        exitEditMode(boardDiv, originalTitle, originalContent);
      }

      // 수정 모드 종료 (공통 함수)
      function exitEditMode(boardDiv, title, content) {
        const titleElement = boardDiv.querySelector('p[style="font-weight: 800"]');
        const contentElement = boardDiv.querySelector('p:not([style="font-weight: 800"])');

        // 원래 텍스트로 복원
        titleElement.textContent = title;
        contentElement.textContent = content;

        // 버튼 영역 제거
        const buttonArea = boardDiv.querySelector('.edit-buttons');
        if (buttonArea) {
          buttonArea.remove();
        }

        // 수정 모드 해제
        boardDiv.classList.remove('edit-mode');
        boardDiv.removeAttribute('data-original-title');
        boardDiv.removeAttribute('data-original-content');
        boardDiv.removeAttribute('data-board-id');
      }

      // 게시글 삭제
      function deleteBoard(boardId) {
        closeAllDropdowns();
        if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
          // DELETE 요청 보내기
          fetch('/api/board/' + boardId, {
            method: 'DELETE',
            headers: {
              Accept: 'application/json',
            },
          })
            .then((response) => response.json())
            .then((result) => {
              if (result.success) {
                alert('게시글이 삭제되었습니다.');
                location.reload(); // 페이지 새로고침
              } else {
                alert('게시글 삭제에 실패했습니다: ' + result.message);
              }
            })
            .catch((error) => {
              console.error('삭제 오류:', error);
              alert('게시글 삭제 중 오류가 발생했습니다.');
            });
        }
      }
    </script>
  </body>
</html>
