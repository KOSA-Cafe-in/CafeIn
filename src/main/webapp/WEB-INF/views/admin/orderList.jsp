<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>주문 내역</title>
    <style>
        .order-card {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .completed {
            background-color: #e0e0e0;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-complete {
            background-color: #4CAF50;
            color: white;
        }

        .btn-complete[disabled] {
            background-color: #aaa;
            cursor: default;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h1>🧾 주문 내역</h1>

<div id="order-list">
    <c:forEach var="order" items="${orderList}">
        <div class="order-card ${order.status eq 'Y' ? 'completed' : ''}" data-order-id="${order.orderId}">
            <p><strong>주문번호:</strong> ${order.orderId}</p>
            <p><strong>총액:</strong> ₩<fmt:formatNumber value="${order.totalPrice}" type="number" /></p>
            <p><strong>주문일:</strong> ${order.createdDate}</p>
            <p><strong>상태:</strong>
                <span class="status-text">
                    <c:choose>
                        <c:when test="${order.status eq 'Y'}">완료</c:when>
                        <c:otherwise>조리중</c:otherwise>
                    </c:choose>
                </span>
            </p>
            <c:if test="${order.status eq 'N'}">
                <button class="btn btn-complete">조리 완료</button>
            </c:if>
        </div>
    </c:forEach>
</div>

<script>
    $(document).on("click", ".btn-complete", function () {
        const $card = $(this).closest(".order-card");
        const orderId = $card.data("order-id");

        // 실제 구현 시 Ajax 요청 필요
        // 여긴 프론트엔드 시뮬레이션
        $.ajax({
            url: "/admin/order/complete", // 아직 구현되지 않은 가상의 API
            method: "POST",
            data: { orderId: orderId },
            success: function () {
                $card.addClass("completed");
                $card.find(".status-text").text("완료");
                $card.find(".btn-complete").prop("disabled", true).text("완료됨");
            },
            error: function () {
                alert("상태 변경 실패");
            }
        });
    });
</script>
</body>
</html>
