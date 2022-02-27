package com.jhta.project.controller.user;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
	public HashMap<String, Object> saveAlarm(int or_num,
			HttpServletResponse resp,HttpServletRequest req,Principal principal, @RequestParam(value="reject",defaultValue ="")String reject){
		HashMap<String, Object> map=new HashMap<String, Object>();
		try {
			if(req.isUserInRole("ROLE_USER")) {
				InSearchOrdersVo vo=service.getOrder(or_num);
				Cookie c=null;
				if(vo.getOr_status()==2) {
					Calendar cal=Calendar.getInstance();
					cal.add(Calendar.MINUTE,vo.getOr_deltime());
					String deltime=cal.get(Calendar.YEAR)+"/"+(cal.get(Calendar.MONTH)+1)+";"+cal.get(Calendar.DAY_OF_MONTH)+"_"+
								String.format("%02d", cal.get(Calendar.HOUR_OF_DAY))+":"+String.format("%02d",cal.get(Calendar.MINUTE));
					System.out.println(deltime);
					c=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+or_num,"utf-8"), 
							URLEncoder.encode(Integer.toString(vo.getOr_status())+","+deltime,"utf-8") );
				}else if(vo.getOr_status()==5){
					c=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+or_num,"utf-8"), 
							URLEncoder.encode(reject,"utf-8") );
				}else{
					Cookie[] cookie=req.getCookies();
					for(Cookie tempc:cookie) {
						if(tempc.getName().equals(URLEncoder.encode(principal.getName()+".or_num,"+or_num,"utf-8"))) {
							String deltime=URLDecoder.decode(tempc.getValue(),"utf-8").split(",")[1];
							c=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+Integer.toString(or_num),"utf-8"), 
									URLEncoder.encode(Integer.toString(vo.getOr_status())+","+deltime,"utf-8") );
						}
					}
				}
				c.setPath("/");
				c.setMaxAge(60*60*24);
				resp.addCookie(c);
				map.put("result", "success");
				map.put("ovo", vo);
			}else if(req.isUserInRole("ROLE_RESTAURANT")) {
				InSearchOrdersVo vo=service.getOrder(or_num);
				Cookie c=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+Integer.toString(or_num),"utf-8"), 
						URLEncoder.encode(Integer.toString(vo.getOr_status())+","+Integer.toString(vo.getOr_deltime()),"utf-8") );
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
	public HashMap<String, Object> getAlarm(HttpServletRequest req,Principal principal){
		HashMap<String, Object> map=new HashMap<String, Object>();
		ArrayList<InSearchOrdersVo> list=new ArrayList<InSearchOrdersVo>();
		try {
			if(req.isUserInRole("ROLE_USER")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.startsWith(principal.getName()+".or_num")) {
						int or_num=Integer.parseInt(name.split(",")[1]);
						if(service.getOrder(or_num).getOr_status()==5) {
							String reject=URLDecoder.decode(c.getValue(),"utf-8");
							list.add(service.getOrder(or_num));
						}else {
							String deltime=URLDecoder.decode(c.getValue(),"utf-8").split(",")[1];
							Calendar cal=Calendar.getInstance();
							Calendar now=Calendar.getInstance();
							String year=deltime.split("_")[0].split("/")[0];
							String month=deltime.split("_")[0].split("/")[1].split(";")[0];
							String day=deltime.split("_")[0].split("/")[1].split(";")[1];
							String hour=deltime.split("_")[1].split(":")[0];
							String min=deltime.split("_")[1].split(":")[1];
							cal.set(Calendar.YEAR, Integer.parseInt(year));
							cal.set(Calendar.MONTH, Integer.parseInt(month)-1);
							cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(day));
							cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(hour));
							cal.set(Calendar.MINUTE, Integer.parseInt(min));
							int remainTime=(int)((cal.getTimeInMillis()-now.getTimeInMillis())/60000);
							InSearchOrdersVo vo=service.getOrder(or_num);
							vo.setRemainTime(remainTime);
							list.add(vo);
						}
					}
				}
				map.put("list", list);
				map.put("result", "success");
			}else if(req.isUserInRole("ROLE_RESTAURANT")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.startsWith(principal.getName()+".or_num")) {
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
	public HashMap<String, Object> deleteAlarm(HttpServletRequest req,HttpServletResponse resp,int or_num,Principal principal){
		HashMap<String, Object> map=new HashMap<String, Object>();
		try {
			if(req.isUserInRole("ROLE_USER")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.equals(principal.getName()+".or_num,"+or_num)) {
						Cookie cookie=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+or_num,"utf-8"),"");
						cookie.setPath("/");
						cookie.setMaxAge(0);
						resp.addCookie(cookie);
						map.put("result", "success");
					}
				}
			}else if(req.isUserInRole("ROLE_RESTAURANT")) {
				Cookie[] cookies=req.getCookies();
				for(Cookie c:cookies) {
					String name=URLDecoder.decode(c.getName(),"utf-8");
					if(name.equals(principal.getName()+".or_num,"+or_num)) {
						System.out.println(name+","+URLDecoder.decode(c.getValue(),"utf-8"));
						Cookie cookie=new Cookie(URLEncoder.encode(principal.getName()+".or_num,"+or_num,"utf-8"),"");
						cookie.setPath("/");
						cookie.setMaxAge(0);
						resp.addCookie(cookie);
						map.put("result", "success");
					}
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
			map.put("result", "fail");
		}
		return map;
	}
}








