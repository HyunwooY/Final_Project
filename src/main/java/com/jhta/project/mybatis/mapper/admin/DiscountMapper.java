package com.jhta.project.mybatis.mapper.admin;

import java.util.HashMap;
import java.util.List;

import com.jhta.project.vo.admin.DiscountVo;

public interface DiscountMapper {
	//목록
	List<DiscountVo> list(String date);
}
