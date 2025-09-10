package com.cafein.order.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.cafein.order.OrderDTO;
import com.cafein.order.OrderItemDTO;

public interface OrderMapper {

    // 카페별 주문 목록
    List<OrderDTO> findRecentOrdersForCafe(@Param("cafeId") Long cafeId);

    // 주문별 아이템 목록
    List<OrderItemDTO> findItemsByOrderId(@Param("orderId") Long orderId);

    // 완료 처리 (status = 'Y')  → 영향 행 수 반환
    int markDone(@Param("orderId") Long orderId);
    
    void insertOrder(OrderDTO orderDTO);

    //List<Map<String, Object>> findMenuPricesByIds(@Param("list") List<Long> menuIds);
    
    Long findMenuUnitPriceById(Long menuId);
    
    void insertOrderItem(OrderItemDTO item);

}
