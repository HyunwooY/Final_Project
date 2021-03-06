<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- ajax 통신을 위한 meta tag -->
<meta id="_csrf" content="${_csrf.token}">
<meta id="_csrf_header" content="${_csrf.headerName}">
<style type="text/css">
   .pwd_check_wrap {
		border: 4px solid #7bcfbb;
	    width: 425px;
	    margin: auto;
	    /* height: 300px; */
	    padding: 50px;
	    padding-top: 50px;
	    margin-top: 210px;
    	margin-bottom: 210px;     
   } 
   
   .check_btn_div {
   		text-align: center;
   }
   
   #pwd_check_btn {
	    color:white; 
	    height: 35px;
	    width: 150px;
	    background-color: #F6416C;   
	    border: 2px solid white;
    }
    
    #pwd_check_btn:hover { 
	    background-color: white;
	    color: black;
	    border: 2px solid #F6416C;
    }
    
    .pwd_input {
    	margin: 5px 0px 10px 0px;
    }
    
    #r_id {
    	color: skyblue;
    }
    
    .pwd_check_title {
    	text-align: center;
    }
    
    #pwd_err {
    	text-align: center;
    	color: red;
    }
</style>
<script type="text/javascript">
	
</script>

<div class="pwd_check_wrap"> 
	<div class="pwd_check_title">
		<h3>비밀번호 확인</h3>
	</div>
	<p style="text-align: center;">
	   <b id="r_id">${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}</b>님의 회원정보를 안전하게 보호하기 위해
	   비밀번호를 한번 더 확인해 주세요.
	</p>
	<label>비밀번호</label>
	<input type="password" name="r_pwd" id="r_pwd" class="pwd_input">
	<div id="pwd_err"></div>
	<div class="check_btn_div">
		<input type="button" value="확인" id="pwd_check_btn" onclick="pwdCheck()">
	</div>
</div>
<script>
	var xhr = null;
	
	function pwdCheck() {
		let r_pwd = document.getElementById("r_pwd");
		let params = "r_pwd=" + r_pwd.value;
		let token = document.getElementById("_csrf").getAttribute("content");
		let token_header = document.getElementById("_csrf_header").getAttribute("content");
		
		if (r_pwd.value == '') {
			r_pwd.focus();
			pwd_err.innerText = "비밀번호를 입력해 주세요.";
			return;
		}
		
		xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4 && xhr.status == 200) {
				let data = xhr.responseText;
				let json = JSON.parse(data);
				
				if (json.result == 'success') {
					location.href="${cp}/restaurant/pwdChange";
				} else {
					let pwd_err = document.getElementById("pwd_err");
					pwd_err.innerText = "비밀번호가 일치하지 않습니다.";					
				}
			}
		}
		let url = "${cp}/sellerPwdCheck";
		xhr.open('post', url, true);
		xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		xhr.setRequestHeader(token_header, token);
		xhr.send(params);
	}
</script>
