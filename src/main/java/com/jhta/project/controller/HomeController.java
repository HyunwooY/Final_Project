package com.jhta.project.controller;

import java.util.Locale;
import javax.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jhta.project.service.user.CategoryService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired private ServletContext sc;
	@Autowired CategoryService service;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		sc.setAttribute("cp", sc.getContextPath());
		model.addAttribute("main","/WEB-INF/views/home.jsp");
		model.addAttribute("list", service.Categorylist());
		return "layout";
	}
	
}
