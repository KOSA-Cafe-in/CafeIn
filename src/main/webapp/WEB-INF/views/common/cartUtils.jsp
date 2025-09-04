<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
/* =========================
   LocalStorage Cart Utility
   구조: { items: { [menuId]: { name, price, qty } } }
   ========================= */
const CART_KEY = 'cart:v1';

// 숫자 포맷 (원)
function won(n){ return (Number(n)||0).toLocaleString('ko-KR') + '원'; }

// 읽기/쓰기
function cartLoad(){
  try { return JSON.parse(localStorage.getItem(CART_KEY)) || { items:{} }; }
  catch(e){ return { items:{} }; }
}
function cartSave(cart){
  localStorage.setItem(CART_KEY, JSON.stringify(cart));
  // 다른 탭/창 동기화 트리거
  try { localStorage.setItem('cart:updated', Date.now().toString()); } catch(e){}
}

// 조작
function cartAdd({menuId, name, price, qty=1}){
  const c = cartLoad(), k = String(menuId);
  if(!c.items[k]) c.items[k] = { name, price: Number(price)||0, qty: 0 };
  c.items[k].qty += Number(qty)||0;
  if(c.items[k].qty <= 0) delete c.items[k];
  cartSave(c);
}
function cartSetQty(menuId, qty){
  const c = cartLoad(), k = String(menuId);
  if(!c.items[k]) return;
  if(Number(qty) <= 0) delete c.items[k]; else c.items[k].qty = Number(qty)||0;
  cartSave(c);
}
function cartRemove(menuId){
  const c = cartLoad(); delete c.items[String(menuId)]; cartSave(c);
}
function cartClear(){
  cartSave({ items:{} });
}

// 요약
function cartSummary(){
  const c = cartLoad(); let count = 0, amount = 0;
  Object.values(c.items).forEach(it=>{
    count += Number(it.qty)||0;
    amount += (Number(it.price)||0) * (Number(it.qty)||0);
  });
  return { count, amount, amountText: won(amount) };
}

/* =========================
   UI Helper (있으면 갱신, 없으면 무시)
   - 전역 떠있는 바: #cartBarCount, #cartBarAmount
   - 하단 공용 버튼:  #cartBadge, #cartTotalText
   ========================= */
function updateCartBar(){
  const s = cartSummary();
  const bar = document.getElementById('cartBar');
  const cEl = document.getElementById('cartBarCount');
  const aEl = document.getElementById('cartBarAmount');
  if(!bar || !cEl || !aEl) return;

  if(s.count > 0){
    cEl.textContent = s.count;
    aEl.textContent = `${s.amountText} 장바구니 보기`;
    bar.classList?.remove('hidden'); bar.classList?.add('show');
  } else {
    bar.classList?.remove('show');   bar.classList?.add('hidden');
  }
}

function refreshCartBadge(){
  const s = cartSummary();
  const b = document.getElementById('cartBadge');       // 개수 배지(공용 버튼용)
  const t = document.getElementById('cartTotalText');   // 합계 텍스트(공용 버튼용)
  if(b) b.textContent = s.count ?? 0;
  if(t) t.textContent = s.amountText ?? '0원';
}

// 초기화 & 동기화
document.addEventListener('DOMContentLoaded', ()=>{
  updateCartBar();
  refreshCartBadge();
});
window.addEventListener('storage', (e)=>{
  if(e.key === 'cart:updated'){
    updateCartBar();
    refreshCartBadge();
  }
});
</script>
