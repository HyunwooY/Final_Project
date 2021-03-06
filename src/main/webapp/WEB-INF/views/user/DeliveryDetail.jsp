<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
 	#box{
 	position:center;
 	padding:45px;                   
 	margin:100px; 
 	text-align: center;       
 	} 
 	#form{
 	margin:auto;
 	text-align: center;  
 	position:center;      
 	} 
 	
 	#inserttable
 	{
 	height: 100px;            
    width: 1000px;        
    border-top: 3px solid black;
    margin-right: auto;
    margin-left: auto;
 	
 	}
 	td
 	{
    border-bottom: 1px dotted black;
  	position:center;      
    }
    .col1 {
    background-color: #7bcfbb;
    padding: 10px;
    text-align: center;
    font-weight: bold;
    font-size: 1.2  em;  
    }   
 
    .col2 {
    text-align: center;  
    padding: 5px;
    }
     .useridbtn {    
    height: 25px;
    width: 80px;
    color: white;
    background-color: black;
    border-color: black;
    }
   .btn3 {
    color:white; 
    height: 35px;
    width: 150px;
    background-color: #F6416C;   
    border: 2px solid white;
    }
    .btn3:hover { 
    background-color: white;
    color: black;
    border: 2px solid #F6416C;
    } 
    .num{
    color: red;
    }
    #option{  
    color:gray;          
    }
    h2{
    text-align:center;              
            
    }
</style> 

<div id="box">
<h2 >상세 메뉴</h2>   
<table  id="inserttable"> 
	<tr>
	   <th  class="col1">메뉴</th>
	   <th  class="col1">옵션</th>
	   <th  class="col1">가격</th>
	</tr>
	<c:forEach var="test" items="${selectmainlistforornum }" varStatus="testst"><!-- list인덱스 번호 얻어오기 -->
	<c:set var="testopt" value="${ff.get(testst.index) }"/> <!-- index번호랑 맞는 list꺼내서 변수 지정하기 -->
	<c:set var="testprice" value="${test.food_cost }"/><!-- 메인메뉴 가격 변수 지정 -->
	<tr>
		<td class="col2">${test.food_name }(${testprice }원)</td>      
		<td class="col2"> 
		<c:forEach var="testop" items="${testopt }">    <!-- 인덱스 번호에 맞는 list돌려서 값 얻어오기 -->
		<c:choose>
		<c:when test="${not empty testop.fo_name}">
		${testop.fo_name}(${testop.fo_cost }원),${testop.oo_count }개<br> 
		</c:when>
		<c:when test="${empty testop.fo_name}">    
		X      
		</c:when>
		</c:choose>  
		</c:forEach>
		</td>   
		<c:set var="total" value="0"/>
		<c:forEach var="result" items="${testopt }" varStatus="status">
		<c:set var="total" value="${total + (result.fo_cost * result.oo_count) }"/>   
		</c:forEach>                 
		<td class="col2">${total + testprice}원</td>     
		</tr>          
		</c:forEach>
</table><br><br>

<h2>가게 정보</h2>  
<table  id="inserttable"> 
	<tr>
	   <th  class="col1">가게</th>
	   <th  class="col1">가게 주소</th>
	   <th  class="col1">요청 사항</th>
	</tr>
	<tr>
		<td class="col2">${vo.r_name }</td>                
		<td class="col2">${vo.r_addr }</td>   
		<td class="col2">${vo.or_request }</td>       
	</tr> 
</table><br><br>
<h3>받는사람 정보</h3>
<table  id="inserttable"> 
	<tr>
	   <th  class="col1">이름</th>
	   <th  class="col1">배달 주소</th>
	   <th  class="col1">전화 번호</th>
	</tr>
	<tr>
		<td class="col2">${vo.ui_name }</td>                
		<td class="col2">${vo.or_addr }</td>     
		<td class="col2">${vo.ui_phone }</td>       
	</tr> 
</table><br><br>
<h2>결제 내역</h2>
<table  id="inserttable"> 
	<tr>
	   <th  class="col1">결제 수단</th>
	   <th  class="col1">배달 금액</th>
	   <th  class="col1">총 결제 금액</th>
	</tr>  
	<tr>    
		<td class="col2">${vo.or_paymethod }</td>     
		<td class="col2">${vo.r_delcost }원</td>   
		<td class="col2">${vo.or_totalcost}원</td>       
	</tr> 
</table><br><br>
<input type="button" value="목록" onclick="returnlist()" class="btn3">
</div>	

<script type="text/javascript">
  
function returnlist(){
	location.href="${cp }/userdelivery";  
	};
</script>
