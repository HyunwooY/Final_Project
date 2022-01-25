package com.jhta.project.controller.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.jhta.project.service.user.UserAddrService;
import com.jhta.project.service.user.UserService;
import com.jhta.project.vo.user.UserAddrVo;
import com.jhta.project.vo.user.UserVo;

@Controller
public class InsertUserController {
	@Autowired UserService service;
	@Autowired UserAddrService service1;
	
	@GetMapping("/insertuser")
	public String UserInsertForm(Model model) {
		model.addAttribute("main","/WEB-INF/views/user/insert.jsp");
		return "layout";
	}
	@PostMapping("/insertuser")
	public String UserInsert(UserVo vo,Model model,UserAddrVo vo1,HttpServletRequest req,HttpServletResponse resp) {
		try {
			service.addUser(vo);
			vo1.setUa_name(vo.getUi_name());
			vo1.setUa_phone(vo.getUi_phone());
			service1.insertaddr(vo1);
			model.addAttribute("result","success");
			model.addAttribute("main","/WEB-INF/views/user/result.jsp");
		}catch(Exception e){
			e.printStackTrace();
			model.addAttribute("result","false");
			model.addAttribute("main","/WEB-INF/views/user/result.jsp");
		}
		return "layout";
	}

}