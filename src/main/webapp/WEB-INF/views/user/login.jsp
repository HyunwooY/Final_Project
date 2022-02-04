<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    
<style type="text/css">

#loginbox {
	text-align: center;
	border: 4px solid #7bcfbb;
	width: 400px;
	margin: auto;
	margin-top:200px;
	margin-bottom:200px;  
	padding: 15px;
}
#btn {
	width: 80px;
	height: 30px;        
	color: #7bcfbb;
	background-color: white;  
	border-radius: 4px;
	border-color: #7bcfbb;
	font-size: 20px;
	cursor: pointer;
}
</style>
<div id="loginbox">
<h1>회원로그인</h1>
<form:form method="post" action="${cp }/loginuser">
	아이디<br>
	<input type="text" name="username"><br>
	비밀번호<br>
	<input type="password" name="password"><br><br>             
	<div>${requestScope.errMsg }</div>
	<input type="submit" value="로그인" id="btn"><br><br> 
	로그인 유지 <input type="checkbox" name="remember-me" id="rememberMe"><br>
	아직 회원이 아니신가요?
	<a href="${cp }/insertuser">회원가입하기</a><br>
	<a href="${cp }/searchid">아이디 찾기</a> | <a href="${cp }/FindUserPwd">비밀번호 찾기</a>
</form:form>
</div>