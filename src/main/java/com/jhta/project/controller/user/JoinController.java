package com.jhta.project.controller.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.jhta.project.service.user.UserService;
import com.jhta.project.vo.user.UserVo;

@Controller
public class JoinController {
	@Autowired private UserService service;
	
	@GetMapping("/joinuser")
	public String joinForm(Model model) {
		model.addAttribute("main","/WEB-INF/views/user/join.jsp");
		return "layout";
	}
	@PostMapping("/joinuser")
	public String join(UserVo vo,Model model) {
		try {
			service.addUser(vo);
			model.addAttribute("code","success");
		}catch(Exception e) {
			e.printStackTrace();
			model.addAttribute("code","fail");
		}
		return "layout";
	}
}
















