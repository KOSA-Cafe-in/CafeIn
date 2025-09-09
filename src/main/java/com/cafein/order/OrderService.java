package com.cafein.order;

import java.util.List;

public interface OrderService {
    // 카페별 최신 주문 리스트
    List<OrderDTO> findRecentOrdersForCafe(Long cafeId);

    // 주문 완료 처리 (status: 'Y') → 영향 행 수 반환
    int markDone(Long orderId);
    
    int countPendingForCafe(Long cafeId);

}
