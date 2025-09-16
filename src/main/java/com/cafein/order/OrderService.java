package com.cafein.order;

import java.util.List;

import com.cafein.payment.PaymentDTO;

public interface OrderService {
    // 카페별 최신 주문 리스트
    List<OrderDTO> findRecentOrdersForCafe(Long cafeId);
    
    List<OrderDTO> findAllOrderHistory(Long userCafeId);

    // 주문 완료 처리 (status: 'Y') → 영향 행 수 반환
    int markDone(Long orderId);
    
    OrderDTO createOrder(PaymentDTO paymentDTO, String orderType, String couponUse,  Long userCafeId, List<OrderItemDTO> items);

    int countPendingForCafe(Long cafeId);
    
    int sumDrinkCountByUserAndCafe(Long userId, Long cafeId);

    int sumOrderItemCountByOrderId(long orderId);
    
    public String getCurrentStatusByMerchantUid(String merchantUid);

    OrderDTO findOrderById(Long orderId);

    PaymentDTO findPaymentByOrderId(Long orderId);
    
	List<OrderItemDTO> findItemsByOrderId(Long orderId);
}
