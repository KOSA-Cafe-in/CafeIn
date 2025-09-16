<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>리틀리 - ${menu.name}</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, viewport-fit=cover" />
<%@ include file="/WEB-INF/views/common/head.jsp"%>
<%@ include file="/WEB-INF/views/common/cartUtils.jsp"%>
<style>
:root { -
	-tc-primary: #2563eb; -
	-tc-text: #111827; -
	-tc-muted: #6b7280; -
	-tc-line: #e5e7eb;
}

.md-phone {
	max-width: 420px;
	min-height: 100dvh;
	margin: 0 auto;
	background: #fff;
	display: flex;
	flex-direction: column
}
.md-content-wrapper {
    flex: 1; /* 또는 flex-grow: 1; */
}

/* 히어로 이미지 영역: 높이 고정 + 가운데 정렬 */
.md-hero{
  width:100%;
  height:350px;            /* 원하는 통일 규격 */
  background:#f3f4f6;
  display:flex;
  align-items:center;
  justify-content:center;
  overflow:hidden;         /* 안전장치 */
}
/* 카드 썸네일도 동일 규격(예: 정사각형 120px) */
.menu-img{
  width:120px;
  height:120px;
  object-fit:contain;      /* 썸네일까지 전체 보이게 */
  object-position:center;
  display:block;
  background:#f3f4f6;      /* 여백 배경색 */
  border-radius:8px;       /* 선택사항 */
}


.md-content {
	padding: 16px 16px 100px 16px /* 하단 패딩은 새로 추가된 CSS에서 처리 */
}

.md-title {
	font-size: 18px;
	font-weight: 800;
	margin: 6px 0 8px
}

.md-desc {
	font-size: 13px;
	color: var(- -tc-muted);
	line-height: 1.5;
	margin: 0 0 16px
}

.md-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px
}

.md-price {
	font-size: 18px;
	font-weight: 800;
	letter-spacing: .2px
}

.md-stepper {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	background: #f3f4f6;
	border-radius: 12px;
	padding: 4px
}

.md-stepper button {
	width: 36px;
	height: 36px;
	border: 0;
	border-radius: 10px;
	background: #fff;
	box-shadow: 0 1px 0 rgba(0, 0, 0, .04) inset;
	display: grid;
	place-items: center;
	font-size: 18px;
	cursor: pointer
}

.md-stepper .count {
	width: 28px;
	text-align: center;
	font-weight: 700
}

.md-back {
	position: absolute;
	top: 16px;
	left: 16px;
	width: 36px;
	height: 36px;
	background: rgba(255, 255, 255, 0.9);
	border: 0;
	border-radius: 50%;
	display: grid;
	place-items: center;
	cursor: pointer;
	backdrop-filter: blur(10px)
}

.md-category {
	display: inline-block;
	background: var(- -tc-primary);
	color: white;
	padding: 4px 8px;
	border-radius: 6px;
	font-size: 12px;
	font-weight: 600;
	margin-bottom: 8px
}

.btn {
	width: 100%;
	height: 52px;
	border-radius: 14px;
	border: 0;
	cursor: pointer;
	font-size: 16px;
	font-weight: 800;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px
}

.badge {
	min-width: 28px;
	height: 28px;
	border-radius: 999px;
	background: #fff;
	color: var(- -tc-primary);
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-weight: 900
}

.btn-primary {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: .5rem;
	min-height: 48px;
	padding: 0 16px;
	border-radius: 12px;
	font-weight: 700;
	font-size: 16px;
	line-height: 1;
	letter-spacing: .2px;
	background: #0064FF;
	color: #fff;
	border: none;
	cursor: pointer;
	/* 우선순위 확보 */
	background-color: #0064FF !important;
	color: #fff !important;
}


#addBtn {
	display: none; /* 처음에는 숨김 */
	transform: translateY(100%); /* 아래쪽에서 시작 */
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#addBtn.show {
	display: flex !important;
	transform: translateY(0); /* 원래 위치로 */
}

.btn-primary:disabled {
	opacity: .5;
	cursor: not-allowed;
}

/* 하단 고정 버튼 영역 */
.buttons {
	position: fixed;
	bottom: 70px;
	left: 50%;
	transform: translateX(-50%);
	width: 100%;
	max-width: 400px;
	background: none;
	z-index: 1000;
}

</style>
</head>
	<!-- 메뉴 정보는 data-* 속성으로 노출(스크립트에서 안전하게 참조) -->
<body>
	<div class="md-phone" id="page" data-menu-id="${menu.menuId}"
		data-menu-name="${menu.name}" data-menu-price="${menu.price}">

		<!-- ================================================== -->
		<!-- 이 div를 추가하여 네비게이션을 제외한 모든 요소를 감쌉니다. -->
		<div class="md-content-wrapper"> 
			<div style="position: relative">
				<div class="md-hero">
					<c:choose>
						<c:when test="${not empty menu.menuPictureUrl}">
							<img src="${menu.menuPictureUrl}" alt="${menu.name}"
								style="width: 100%; height: 100%; object-fit: cover;" />
						</c:when>
						<c:otherwise>이미지 준비중</c:otherwise>
					</c:choose>
				</div>
				<button class="md-back" onclick="history.back()">←</button>
			</div>
	
			<div class="md-content">
				<span class="md-category">메뉴</span>
				<h1 class="md-title">${menu.name}</h1>
				<p class="md-desc">${menu.content}</p>
	
				<div class="md-row">
					<span class="md-price"><fmt:formatNumber
							value="${menu.price}" type="number" pattern="#,###" />원</span>
					<div class="md-stepper">
						<button type="button" onclick="changeQuantity(-1)">−</button>
						<span class="count" id="quantity">0</span>
						<button type="button" onclick="changeQuantity(1)">+</button>
					</div>
				</div>
			</div>
			<div class="buttons">
				<button type="button" class="btn btn-primary" id="addBtn"
					onclick="addCurrent()">
					<span class="badge" id="cartBadge">0</span> <span id="totalPrice"></span>
				</button>
			</div>
		</div>
		<!-- ================================================== -->
		
		<!-- 하단 네비게이션 include -->
		<jsp:include page="/WEB-INF/views/common/nav.jsp">
			<jsp:param name="active" value="home" />
		</jsp:include>
	</div>
	
	<!-- ... 스크립트 ... -->
</body>
	
	

	<script>
	  function changeQuantity(delta){
		const qtyEl = document.getElementById('quantity');
		const page = document.getElementById('page');
		const unit  = Number(page?.dataset?.menuPrice) || 0;
	    let qty = parseInt(qtyEl.textContent, 10) || 0;
	    qty = Math.max(0, Math.min(99, qty + delta));
	    qtyEl.textContent = qty;
	    const total = unit*(qty);
	    document.getElementById('cartBadge').textContent =  qty;
	    document.getElementById('totalPrice').textContent =  total + '원 담기';

	    // 스테퍼 버튼 enable/disable
	    const stepper = qtyEl.closest('.md-stepper');
	    if (stepper) {
	      const buttons = stepper.querySelectorAll('button');
	      const minus = buttons[0], plus = buttons[1] || buttons[2]; // 구조 보호
	      if (minus) minus.disabled = (qty <= 0);
	      if (plus)  plus.disabled  = (qty >= 99);
	    }
	    const addBtn = document.getElementById('addBtn');
	    if(qty != 0) {
	    	addBtn.style.display = 'flex'; // 먼저 표시
	    	setTimeout(() => addBtn.classList.add('show'), 10); // 약간의 지연 후 애니메이션
	    } else {
	    	addBtn.classList.remove('show');
	    	setTimeout(() => addBtn.style.display = 'none', 300); // 애니메이션 완료 후 숨김
	    }
	  }

	  function addCurrent(){
		  const page = document.getElementById('page');
		  const menuId = page?.dataset?.menuId;
		  const name   = page?.dataset?.menuName;
		  const price  = Number(page?.dataset?.menuPrice) || 0;
		  const qty    = parseInt(document.getElementById('quantity').textContent, 10) || 1;

		  if (typeof cartAdd === 'function') {
		    cartAdd({ menuId, name, price, qty });
		  }
		  // 담기 후 user/home으로 이동
		  window.location.href = '/user/home';
		}
	
	</script>
</html>
