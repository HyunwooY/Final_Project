<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<style>
* {
	font-size: 16x;
	font-family: consolas, sans-serif;
}

h1 {
	text-align: center;
}

p {
	text-align: center;
	font-size:16px;
}
.container{
padding-right:300px;
padding_left:300px;
margin-right:auto;
margin-left:auto;
padding-top:130px;
}
}

</style>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<h1 style="color:#337ab7;">작성페이지</h1>
		<br>
		<div class="panel panel-default" >
			<div class="panel-heading">작성페이지</div>
			<div class="panel-body">
				<form:form method="post" id="smsForm">
					<div class="form-group">
						<label>보내는 사람</label> <input type="text" class="form-control"
							name="from" />
					</div>
					<div class="form-group">
						<label>입력할 메세지</label>
						<td><textarea class="form-control" rows="3" name="text"></textarea>
					</div>
					<input type="button" value="목록" onclick="location.href='${cp }/admin/refund/list'" class='btn btn-primary'/>
					<input type="button" onclick="sendSMS('sendSms')" value="전송"
						class="btn btn-success" />
				</form:form>
			</div>

			<script>
				function sendSMS(pageName) {

					console.log("문자를 전송합니다.");
					$("#smsForm").attr("action", pageName + ".do");
					$("#smsForm").submit();
				}
			</script>
		</div>
		</div>
</body>
</html>