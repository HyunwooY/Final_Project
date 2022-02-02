<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	.where{padding-top:100px;}
	#up{position:relative;left:220px}
	.searchplace{width:700px;margin-bottom:100px}
	.searchbar{width:600px}
	.restaurant{width:600px;margin:auto;margin-top:50px;height:70px}
	.restaurant img{float:left;margin-right:10px}
	.resimg{width:100px;height:100px}
	.paging{position:relative;left:140px;margin-top:30px}
	#category{width:100px}
</style>    

<div class="container where">
	
	<sec:authorize access="isAuthenticated()">
		<div class="input-group container searchplace">
			<select onchange="changeAddr(this.options[this.selectedIndex].text)">
				<c:forEach var="vo" items="${list }" varStatus="status">
					<c:choose>
						<c:when test="${vo.ua_nickname=='기본배송지' }">
							<option selected="selected">${vo.ua_nickname }</option>
						</c:when>
						<c:otherwise>
							<option>${vo.ua_nickname }</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
			<input type="text" class="form-control col-10" id="place" value="${vo.ua_addr }" readonly="readonly">
		</div>
	</sec:authorize>
	<sec:authorize access="isAnonymous()">
		<div id="up">
			<a href="loginuser">아이디 있으신가요?</a>
			<h3>어디로 배달해드릴까요?</h3>
		</div>
		<div class="input-group container searchplace">
			<input type="text" class="form-control col-6" id="place" placeholder="배달받을 간단한 주소를 입력해주세요!">
			<input type="text" class="form-control col-4 place" id="placeDetail" aria-describedby="addr-addon" >
			<button class="btn btn-outline-secondary" type="button" id="addr-addon">검색</button>
		</div>
	</sec:authorize>
</div>
<div class="container" id="res">
	<div class="input-group container searchbar">
		<select class="form-control col-3" id="category">
		<c:choose>
			<c:when test="${category==''||category==null }">
				<option value="all" selected>전체</option>
				<c:forEach var="cg_name" items="${cglist }">
					<option value="${cg_name }">${cg_name }</option>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<option value="">전체</option>
				<c:forEach var="cg_name" items="${cglist }">
					<c:choose>
						<c:when test="${category==cg_name }">
							<option value="${cg_name }" selected>${cg_name }</option>
						</c:when>
						<c:otherwise>
							<option value="${cg_name }">${cg_name }</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</select>
		<input type="text" class="form-control col-8 searchmenu" placeholder="먹고싶은 메뉴, 가게 검색" 
							aria-describedby="button-addon2" id="keyword" value="${param.keyword }">
		<button class="btn btn-outline-secondary" type="button" id="button-addon2">검색</button>
	</div>
	<div class="container" id="restau"></div>
	<div class="container paging" id="paging"></div>   
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6cda1d2e6578e00f2f149b8981a3cb1f&libraries=services"></script>
<script>
	let x="";
	let y="";
	$("#button-addon2").click(function(){
		let keyword=$("#keyword").val();
		if(keyword!=null||keyword!=''){
			location.href="${cp}/search?cg_name="+$("#category").val()+"&keyword="+keyword;
		}else{
			location.href="${cp}/search?cg_name="+$("#category").val()+"&keyword="+keyword;
		}
	});
	let category="";
	function changeAddr(selected,keyword){
		$.ajax({
			url:"${cp}/user/addrDetail?ua_nickname="+selected,
			dataType:"json",
			success:function(data){
				$("#place").prop("value",data.vo.ua_addr);
				let coordx="";
				let coordy="";
				var geocoder = new kakao.maps.services.Geocoder();
				// 주소로 좌표를 검색합니다
				geocoder.addressSearch(data.vo.ua_addr, function(result, status) {
				    // 정상적으로 검색이 완료됐으면 
				     if (status === kakao.maps.services.Status.OK) {
				    	 coordx=result[0].x;
				    	 coordy=result[0].y;
				    	 $.ajax({
								url:"${cp}/user/search",
								data:{
									pageNum:"${pu.pageNum}",
									cg_name:"${param.cg_name}",
									keyword:"${keyword}",
									user_coordx:coordx,
									user_coordy:coordy
								},
								dataType:"json",
								success:function(data){
									console.log(data); // 데이터 받아오는지 체크
									let seller="";
									$("#restau").empty();
									$("#paging").empty();
									for(let i=0;i<data.listvo.length;i++){
										seller+="<a href='${cp}/searchDetail?r_id="+data.listvo[i].r_id+"&distance="+data.listvo[i].distance+"' style='text-decoration:none;color:black'>"
										seller+="<div class='container restaurant'>";
										seller+="<img src='${cp}/resources/img/"+data.listvo[i].r_img+"' class='resimg'>";
										seller+="<h5>"+data.listvo[i].r_name+"</h5>";
										seller+="<img src='${cp}/resources/img/star.png' style='width:25px;height:20px;float:left'>";
										seller+="<span></span><br>" // 별점 
										seller+="<img src='${cp}/resources/img/clock.jpg' style='width:20px;height:20px;float:left'>";
										seller+="&nbsp<span style='float:left;font-size:0.9em'>"+data.listvo[i].r_delmin+"분~"+data.listvo[i].r_delmax+"분";
										seller+="&nbsp&nbsp·&nbsp"+Math.round(data.listvo[i].distance *10)/10+"km </span><br>";
										seller+="<span style='font-size:0.9em'>배달요금 "+data.listvo[i].r_delCost+"원</span>";
										seller+="</div></a>";
									}
									$("#restau").append(seller);
									let page="";
									let keyword="";
									//$("#keyword").val();
									console.log("count:"+data.pu.totalPageCount);
									x=data.user_coordx;
									y=data.user_coordy;
									for(let i=1;i<=data.pu.totalPageCount;i++){
										if(i==1){
											page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
													+i+"</span></a>&nbsp";
										}else{
											page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
													+i+"</span></a>&nbsp";
										}
										console.log("page:"+keyword);
										$("#paging").append(page);
									}
								}
							});
				     }
				});
			}
		});
	}
	function paging(pageNum,user_coordx,user_coordy){
		$.ajax({
			url:"${cp}/user/search",
			data:{
				pageNum:pageNum,
				keyword:"${param.keyword}",
				category:"${param.cg_name}",
				user_coordx:user_coordx,
				user_coordy:user_coordy
			},
			dataType:"json",
			success:function(data){
				console.log(data); // 데이터 받아오는지 체크
				let seller="";
				$("#restau").empty();
				$("#paging").empty();
				for(let i=0;i<data.listvo.length;i++){
					seller+="<a href='${cp}/searchDetail?r_id="+data.listvo[i].r_id+"&distance="+data.listvo[i].distance+"' style='text-decoration:none;color:black'>";
					seller+="<div class='container restaurant'>";
					seller+="<img src='${cp}/resources/img/"+data.listvo[i].r_img+"' class='resimg'>";
					seller+="<h5>"+data.listvo[i].r_name+"</h5>";
					seller+="<img src='${cp}/resources/img/star.png' style='width:25px;height:20px;float:left'>";
					seller+="<span></span><br>"; // 별점 
					seller+="<img src='${cp}/resources/img/clock.jpg' style='width:20px;height:20px;float:left'>";
					seller+="&nbsp<span style='float:left;font-size:0.9em'>"+data.listvo[i].r_delmin+"분~"+data.listvo[i].r_delmax+"분";
					seller+="&nbsp&nbsp·&nbsp"+Math.round(data.listvo[i].distance *10)/10+"km </span><br>";
					seller+="<spanstyle='font-size:0.9em'>배달요금 "+data.listvo[i].r_delCost+"원</span>";
					seller+="</div></a>";
				}
				$("#restau").append(seller);
				let page="";
				let keyword="";
					//$("#keyword").val();
				console.log("count:"+data.pu.totalPageCount);
				for(let i=1;i<=data.pu.totalPageCount;i++){
					if(pageNum==i){
						page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
						+i+"</span></a>&nbsp";
					}else{
						page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
						+i+"</span></a>&nbsp";
					}
					console.log("page:"+page);
					$("#paging").append(page);
				}
			}
		});
	}
	var themeObj = {
		   bgColor: "#162525", //바탕 배경색
		   searchBgColor: "#162525", //검색창 배경색
		   contentBgColor: "#162525", //본문 배경색(검색결과,결과없음,첫화면,검색 서제스트)
		   pageBgColor: "#162525", //페이지 배경색
		   textColor: "#FFFFFF", //기본 글자색
		   queryTextColor: "#FFFFFF", //검색창 글자색
		   //postcodeTextColor: "", //우편번호 글자색
		   //emphTextColor: "", //강조 글자색
		   outlineColor: "#444444" //테두리 
		};
	window.onload = function(){
		category=$("#category").val();
		
		let detail=document.getElementById("placeDetail");
		$.ajax({
			url:"${cp}/user/addrDetail?ua_nickname=기본배송지",
			
			dataType:"json",
			success:function(data){
				$("#place").prop("value",data.vo.ua_addr);
				let coordx="";
				let coordy="";
				var geocoder = new kakao.maps.services.Geocoder();
				// 주소로 좌표를 검색합니다
				geocoder.addressSearch(data.vo.ua_addr, function(result, status) {
				    // 정상적으로 검색이 완료됐으면 
				     if (status === kakao.maps.services.Status.OK) {
				    	 coordx=result[0].x;
				    	 coordy=result[0].y;
				    	 $.ajax({
								url:"${cp}/user/search",
								data:{
									pageNum:"${pu.pageNum}",
									keyword:"${param.keyword}",
									cg_name:"${param.cg_name}",
									user_coordx:coordx,
									user_coordy:coordy
								},
								dataType:"json",
								success:function(data){
									console.log(data);
									let seller="";
									$("#restau").empty();
									$("#paging").empty();
									x=data.user_coordx;
									y=data.user_coordy;
									for(let i=0;i<data.listvo.length;i++){
										seller+="<a href='${cp}/searchDetail?r_id="+data.listvo[i].r_id+"&distance="+data.listvo[i].distance+"' style='text-decoration:none;color:black'>"
										seller+="<div class='container restaurant'>";
										seller+="<img src='${cp}/resources/img/"+data.listvo[i].r_img+"' class='resimg'>";
										seller+="<h5>"+data.listvo[i].r_name+"</h5>";
										seller+="<img src='${cp}/resources/img/star.png' style='width:25px;height:20px;float:left'>";
										seller+="<span></span><br>" // 별점 
										seller+="<img src='${cp}/resources/img/clock.jpg' style='width:20px;height:20px;float:left'>";
										seller+="&nbsp<span style='float:left;font-size:0.9em'>"+data.listvo[i].r_delmin+"분~"+data.listvo[i].r_delmax+"분";
										seller+="&nbsp&nbsp·&nbsp"+Math.round(data.listvo[i].distance *10)/10+"km </span><br>"
										seller+="<span style='font-size:0.9em'>배달요금 "+data.listvo[i].r_delCost+"원</span>"
										seller+="</div></a>";
									}
									let page="";
									let keyword="";
										//$("#keyword").val();
									$("#restau").append(seller);
									for(let i=1;i<=data.pu.totalPageCount;i++){
										if(i==1){
											page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
													+i+"</span></a>&nbsp";
										}else{
											page="<a href='javascript:paging("+i+","+data.user_coordx+","+data.user_coordy+")'><span style='color:blue'>"
													+i+"</span></a>&nbsp";
										}
										console.log("page:"+page);
										$("#paging").append(page);
									}
								}
							});
				     }
				});
			}
		});
		if(detail!=null){
			detail.disabled=true;
			document.getElementById("addr-addon").addEventListener('click',function(){
				new daum.Postcode({
			        oncomplete: function(data) {
			    	   	document.getElementById("place").value = data.address; // 주소 넣기
			    	   	detail.disabled=false;
			    	   	detail.placeholder = "상세주소를 입력하세요";
			    	   	detail.focus();
			        },
			        theme:themeObj
				 }).open({
					q:document.getElementById("place").value
				 });
			});
		}
		
	}
</script>
