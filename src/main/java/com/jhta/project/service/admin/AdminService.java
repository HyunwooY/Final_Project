package com.jhta.project.service.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.jhta.project.mybatis.mapper.admin.AdminMapper;
import com.jhta.project.service.security.CustomUserDetail;
import com.jhta.project.vo.admin.AdminVo;
import com.jhta.project.vo.security.AuthorityVo;

@Service
public class AdminService {
	@Autowired private AdminMapper mapper;
	@Autowired private PasswordEncoder passwordEncoder;
	
	public CustomUserDetail getAuths(String admin_id) {
		return mapper.getAuths(admin_id);
	}
	public int adminInsert(AdminVo vo) {
		String admin_pwd=vo.getAdmin_pwd();
		vo.setAdmin_pwd(passwordEncoder.encode(admin_pwd));
		mapper.admininsert(vo);
		AuthorityVo auth=new AuthorityVo(vo.getAdmin_id(),"ROLE_ADMIN");
		mapper.addAuth(auth);
		return 1;
	}
	public int addAuth(AuthorityVo vo) {
		return mapper.addAuth(vo);
	}
	public boolean selectId(AdminVo vo) {
		return mapper.selectId(vo);
	}
	public int selectadmin(String admin_id) {
		return mapper.selectadmin(admin_id);
	}
	public String checkidadmin(String admin_id) {
		return mapper.checkidadmin(admin_id);
	}
	public String checkiduser(String admin_id) {
		return mapper.checkiduser(admin_id);
	}
	public String checkidre(String admin_id) {
		return mapper.checkidre(admin_id);
	}
	
}








