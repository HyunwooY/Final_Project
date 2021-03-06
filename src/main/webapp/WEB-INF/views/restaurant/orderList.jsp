<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
	.order_cancel_wrap {
		width: 70%;
	    height: 750px;
	    margin: auto;
	    overflow-y: auto;
	    -ms-overflow-style: none;
	    scrollbar-width: none;
	}
	
	.order_cancel_wrap::-webkit-scrollbar {
		display: none;
	}
	
	.order_cancel_table {
    	margin: auto;
    	margin-bottom: 50px;
    	width: 930px;
	}
	
	.order_cancel_table th {
		text-align: center;
	    background-color: #7bcfbb;
	    height: 50px;
	}
	
	.order_cancel_table td {
		text-align: center;
		padding: 5px;
	}
	
	.order_cancel_title {
		text-align: center;
	}
	
	.order_cancel_title h3 {
		padding: 10px;
	}
	
	.orderlist-btn {
		border-radius: 10px;
	    border: 1px solid;
	    display: block;
	    height: 40px;
	    width: 200px;
	    text-align: center;
	    margin: auto;
	    line-height: 2.5;
	    text-decoration: none;
	    background-color: #7bcfbb;
		color: white;
		display: inline-block;
	}
	
	.orderlist-btn:hover {
		color: #7bcfbb;
		background-color: white;
		text-decoration: none;
	}
</style>
<c:set var="cnt" value="0"/>
<div class="order_cancel_wrap">
	<div class="order_cancel_title">
		<h3>주문 목록</h3>
	</div>
	<c:forEach var="vo" items="${requestScope.list }">
		<c:if test="${vo.or_status != 4 }">
			<table class="order_cancel_table" style="border-collapse: collapse">
		 		<colgroup>
		 			<col width="auto">
		 			<col width="auto">
		 			<col width="auto">
		 		</colgroup>
		 		<thead>
		 			<tr>
		 				<th scope="col">메뉴</th>
		 				<th scope="col">수량</th>
		 				<th scope="col">금액</th>
		 			</tr>
		 		</thead>
		 		<tbody>
					<c:forEach var="menu" items="${requestScope.menu }">
						<tr>
							<c:if test="${vo.or_num == menu.or_num }">
								<c:choose>
									<c:when test="${menu.food_name != null }">
										<td>
											<b>${menu.food_name }</b>
										</td>
									</c:when>
									<c:otherwise>
										<td>
											${menu.fo_name }&nbsp;<small>(옵션)</small>
										</td>
									</c:otherwise>
								</c:choose>
								<td>
									${menu.food_count }개
								</td>
								<td>
									${menu.food_cost_sum }원
								</td>
							</c:if>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="3"><hr><i>총 결제 금액 : ${vo.or_totalcost }</i></td>
					</tr>
					<tr>
						<td colspan="3"><hr><i>주문번호 : ${vo.or_num }</i><hr></td>
					</tr>
					<tr>
						<td colspan="3"><i>주문 시간 : ${vo.or_regdate }</i><hr></td>
					</tr>
					<c:if test="${vo.or_request != null }">
						<tr>
							<td colspan="3"><i>요청 사항 : ${vo.or_request }</i><hr></td>
						</tr>
					</c:if>
					<tr>
						<td colspan="3">
							<c:choose>
								<c:when test="${vo.or_status == 1}">
									<a id="order_accept" class="orderlist-btn" href="javascript:void(0)" onclick="acceptPopup(${vo.or_num})">주문 수락</a>
								</c:when>
								<c:when test="${vo.or_status == 2}">
									<a id="order_delivery" class="orderlist-btn" href="javascript:void(0)" onclick="deliveryStart(${vo.or_num})">배달 시작</a>
								</c:when>
								<c:when test="${vo.or_status == 3}">
									<a id="order_delivery" class="orderlist-btn" href="javascript:void(0)" onclick="deliveryEnd(${vo.or_num})">배달 완료</a>
								</c:when>
							</c:choose>
							<c:if test="${vo.or_status == 1}">
								<a id="order_cancel" class="orderlist-btn" href="javascript:void(0)" onclick="cancelPopup(${vo.or_num})">주문 거부</a>
							</c:if>
						</td>
					</tr>
		 		</tbody>
		 	</table>
		</c:if>
	</c:forEach>
</div>
<script>
	function cancelPopup(or_num) {
		var url = "${cp }/restaurant/cancelReason?or_num=" + or_num;
		var name = "cancelReason";
		var option = "width = 300, height = 280, top = 300, left = 800";
		window.open(url, name, option);
	}
	
	function acceptPopup(or_num) {
		var url = "${cp }/restaurant/acceptReason?or_num=" + or_num;
		var name = "acceptReason";
		var option = "width = 300, height = 150, top = 300, left = 800";
		window.open(url, name, option);
	}
	
	function deliveryStart(or_num) {
		if (confirm("배달을 시작하시겠습니까?")) {
			alert("해당 주문의 배달이 시작되었습니다.");
			stompClient.send("/app/callback", {}, JSON.stringify({'or_num': or_num}));
			location.href="${cp }/restaurant/deliveryStart?or_num=" + or_num;
		} else {
			return;
		}
	}
	
	function deliveryEnd(or_num) {
		if (confirm("배달을 완료하시겠습니까?")) {
			alert("해당 주문의 배달이 완료되었습니다.");
			stompClient.send("/app/callback", {}, JSON.stringify({'or_num': or_num}));
			location.href="${cp }/restaurant/deliveryEnd?or_num=" + or_num;
		} else {
			return;
		}
	}
	// 창 닫기
	function closeWin() {
		top.window.opener = top;
		top.window.open('', '_parent', '');
		top.window.close();
	}
</script>