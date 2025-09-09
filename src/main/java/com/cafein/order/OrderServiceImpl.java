package com.cafein.order;

import com.cafein.order.mapper.OrderMapper;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderServiceImpl implements OrderService {

    @Resource
    private OrderMapper orderMapper;

    @Override
    public List<OrderDTO> findRecentOrdersForCafe(Long cafeId) {
        List<OrderDTO> orders = orderMapper.findRecentOrdersForCafe(cafeId);
        for (OrderDTO o : orders) {
            if (o != null) {
                o.setItems(orderMapper.findItemsByOrderId(o.getOrderId()));
            }
        }
        return orders;
    }

    @Transactional
    @Override
    public int markDone(Long orderId) {
        return orderMapper.markDone(orderId); // 1(성공) 기대
    }
    
    @Override
    public int countPendingForCafe(Long cafeId) {
        return orderMapper.countPendingForCafe(cafeId);
    }
    
    @Override
    public int sumDrinkCountByUserAndCafe(Long userId, Long cafeId) {
        return orderMapper.sumDrinkCountByUserAndCafe(userId, cafeId);
    }

}
