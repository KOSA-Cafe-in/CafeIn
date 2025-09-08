<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
.cartbar-wrap {
	position: fixed;
	left: 0;
	right: 0;
	bottom: 84px;
	display: flex;
	justify-content: center;
	pointer-events: none;
	z-index: 999;
}

.cartbar {
	width: clamp(320px, 100%, 420px);
	padding: 0 12px;
	pointer-events: auto;
}

.cartbar-btn {
	width: 100%;
	height: 52px;
	border: 0;
	border-radius: 14px;
	background: #2563eb;
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	font-weight: 800;
	box-shadow: 0 8px 20px rgba(37, 99, 235, .25);
}

.cartbar-badge {
	min-width: 28px;
	height: 28px;
	border-radius: 999px;
	background: #fff;
	color: #2563eb;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-weight: 900;
}

.cartbar.hidden {
	transform: translateY(16px);
	opacity: 0;
	visibility: hidden;
	transition: .25s;
}

.cartbar.show {
	transform: translateY(0);
	opacity: 1;
	visibility: visible;
	transition: .25s;
}
</style>
<div class="cartbar-wrap">
	<div id="cartBar" class="cartbar hidden">
		<button class="cartbar-btn" type="button" onclick="goToCart()">
			<span class="cartbar-badge" id="cartBarCount">0</span> <span
				id="cartBarAmount"></span> <span>장바구니 보기</span>
		</button>
	</div>
</div>

<script>
function goToCart() {
    window.location.href = '<c:url value="/user/cart"/>';
}

  function updateCartBar(){
    const s = cartSummary(); // {count, amount, amountText}
    console.log(s);
    console.log(s.amountText);
    const bar = document.getElementById('cartBar');
    if(!bar) return;

    if (s.count > 0) {
      document.getElementById('cartBarCount').textContent = s.count;
    console.log(s.amount);
      document.getElementById('cartBarAmount').textContent = s.amountText; // ★ 합계 표시
      bar.classList.remove('hidden'); bar.classList.add('show');
    } else {
      bar.classList.remove('show'); bar.classList.add('hidden');
    }
  }
  document.addEventListener('DOMContentLoaded', updateCartBar);
  window.addEventListener('storage', (e)=>{ if(e.key==='cart:updated') updateCartBar(); });
</script>
