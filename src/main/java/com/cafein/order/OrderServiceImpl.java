package com.cafein.order;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafein.order.mapper.OrderMapper;
import com.cafein.payment.PaymentDTO;

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
	
	@Override
	public List<OrderDTO> findAllOrderHistory(Long userCafeId) {
		
	    List<OrderDTO> orders = orderMapper.findAllOrderHistory(userCafeId);
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

	@Transactional
	public OrderDTO createOrder(PaymentDTO payment, String orderType, String couponUse, Long userCafeId,
			List<OrderItemDTO> items) {
		OrderDTO order = new OrderDTO();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		try {
			order.setCreatedDate(sdf.parse(payment.getCreatedDate()));
		} catch (ParseException e) {
			e.printStackTrace();
		}

		order.setPaymentMethod(payment.getPaymentMethod());
		if (couponUse.equals("Y"))
		{
			order.setTotalPrice(payment.getAmount() + 2000);
		}
		else
		{
			order.setTotalPrice(payment.getAmount());
		}
		order.setStatus("N");
		order.setMerchantUid(payment.getMerchantUid());
		order.setTakeout(orderType);
		order.setCouponUse(couponUse);
		order.setUserCafeId(userCafeId);
		order.setItems(items);

		orderMapper.insertOrder(order);

		Long orderId = order.getOrderId(); // 여기서 방금 생성된 시퀀스 값 확인 가능

		// 2) OrderItem 테이블 insert
		for (OrderItemDTO item : items) {
			item.setOrderId(orderId); // FK 세팅
			item.setUnitPrice(orderMapper.findMenuUnitPriceById(item.getMenuId()));
			orderMapper.insertOrderItem(item);
		}

		return order;
	}

	@Override
	public int countPendingForCafe(Long cafeId) {
		return orderMapper.countPendingForCafe(cafeId);
	}

	@Override
	public int sumDrinkCountByUserAndCafe(Long userId, Long cafeId) {
		return orderMapper.sumDrinkCountByUserAndCafe(userId, cafeId);
	}
	
	@Override
	public int sumOrderItemCountByOrderId(long orderId){
		return orderMapper.sumOrderItemCountByOrderId(orderId);
	}
	
	@Transactional(readOnly = true)
	public String getCurrentStatusByOrderId(Long orderId) {
	String status = orderMapper.selectStatusByOrderId(orderId);
	return status != null ? status : "N";
	}

	@Override
	public OrderDTO findOrderById(Long orderId) {
		return orderMapper.findOrderById(orderId);
	}

	@Override
	public PaymentDTO findPaymentByOrderId(Long orderId) {
		return orderMapper.findPaymentByOrderId(orderId);
	}
	
	@Override
	public List<OrderItemDTO> findItemsByOrderId(Long orderId)
	{
		return orderMapper.findItemsByOrderId(orderId);
	}
}
