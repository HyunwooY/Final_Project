package com.jhta.project.controller.user;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
	@GetMapping("/loginuser")
	public String login(Model model) {
		model.addAttribute("main","/WEB-INF/views/user/login.jsp");
		return "layout";
	}
}