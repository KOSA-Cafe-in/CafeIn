package com.cafein.order.mapper;

import com.cafein.order.OrderDTO;
import com.cafein.order.OrderItemDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;


public interface OrderMapper {

    // 카페별 주문 목록
    List<OrderDTO> findRecentOrdersForCafe(@Param("cafeId") Long cafeId);

    // 주문별 아이템 목록
    List<OrderItemDTO> findItemsByOrderId(@Param("orderId") Long orderId);

    // 완료 처리 (status = 'Y')  → 영향 행 수 반환
    int markDone(@Param("orderId") Long orderId);
    
    int countPendingForCafe(@Param("cafeId") Long cafeId);
    
    /** 유저+카페 기준, 주문 음료 총 개수(= OrderItem.count 합계) */
    int sumDrinkCountByUserAndCafe(@Param("userId") Long userId,
                                   @Param("cafeId") Long cafeId);

}
