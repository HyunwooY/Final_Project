package com.jhta.project.controller.user;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jhta.project.service.user.SearchService;
import com.jhta.project.vo.user.InSearchOrdersVo;

@RestController
public class AlarmController {
	@Autowired private SearchService service;
	
	@GetMapping("/user/findrid")
	public HashMap<String, Object> findRid(Principal principal){
		HashMap<String, Object> map=new HashMap<String, Object>();
		List<InSearchOrdersVo> list=service.findOrdersRid(principal.getName());
		if(list.size()>0) {
			map.put("result", "exist");
			map.put("list", list);
		}else {
			map.put("result", "none");
		}
		return map;
	}
	@GetMapping("/saveAlarm")
	public HashMap<String, Object> saveAlarm(int or_num,int deltime,
			HttpServletResponse resp,HttpServletRequest req){
		HashMap<String, Object> map=new HashMap<String, Object>();
		try {
			if(req.isUserInRole("ROLE_USER")) {
				System.out.println("유저");
				InSearchOrdersVo vo=service.getOrder(or_num);
				Cookie c=new Cookie(URLEncoder.encode("or_num,"+Integer.toString(or_num),"utf-8"), URLEncoder.encode(Integer.toString(vo.getOr_status())+","+Integer.toString(vo.getOr_deltime()),"utf-8") );
				c.setPath("/");
				c.setMaxAge(60*60*24);
				resp.addCookie(c);
				map.put("result", "success");
				map.put("ovo", vo);
			}else if(req.isUserInRole("ROLE_RESTAURANT")) {
				System.out.println("레스토랑");
				InSearchOrdersVo vo=service.getOrder(or_num);
				Cookie c=new Cookie(URLEncoder.encode("r.or_num,"+Integer.toString(or_num),"utf-8"), URLEncoder.encode(Integer.toString(vo.getOr_status())+","+Integer.toString(vo.getOr_deltime()),"utf-8") );
				c.setPath("/");
				c.setMaxAge(60*60*24);
				resp.addCookie(c);
				map.put("result", "success");
				map.put("ovo", vo);
			}else {
				map.put("result", "fail");	
			}
		}catch(Exception e) {
			e.printStackTrace();
			map.put("result", "fail");			
		}
		return map;
	}
	@GetMapping("/getAlarm")
	public HashMap<String, Object> getAlarm(HttpServletRequest req){
		HashMap<String, Object> map=new HashMap<String, Object>();
		ArrayList<InSearchOrdersVo> list=new ArrayList<InSearchOrdersVo>();
		try {
			if(req.isUserInRole("ROLE_USER")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.startsWith("or_num")) {
						int or_num=Integer.parseInt(name.split(",")[1]);
						list.add(service.getOrder(or_num));
					}
				}
				map.put("list", list);
				map.put("result", "success");
			}else if(req.isUserInRole("ROLE_RESTAURANT")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.startsWith("r.or_num")) {
						int or_num=Integer.parseInt(name.split(",")[1]);
						list.add(service.getOrder(or_num));
					}
				}
				map.put("list", list);
				map.put("result", "success");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			map.put("result", "fail");
		}
		return map;
	}
	@GetMapping("/deleteAlarm")
	public HashMap<String, Object> deleteAlarm(HttpServletRequest req,HttpServletResponse resp,int or_num){
		HashMap<String, Object> map=new HashMap<String, Object>();
		try {
			Cookie[] cookies=req.getCookies();
			for(Cookie c:cookies) {
				String name=URLDecoder.decode(c.getName(),"utf-8");
				if(name.equals("or_num,"+or_num)) {
					Cookie cookie=new Cookie(URLEncoder.encode("or_num,"+or_num,"utf-8"),"");
					cookie.setPath("/");
					cookie.setMaxAge(0);
					resp.addCookie(cookie);
					map.put("result", "success");
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
			map.put("result", "fail");
		}
		return map;
	}
}







