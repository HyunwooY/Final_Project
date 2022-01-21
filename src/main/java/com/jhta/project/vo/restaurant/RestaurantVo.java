package com.jhta.project.vo.restaurant;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RestaurantVo {
	private String r_id;
	private String r_pwd;
	private String r_name;
	private String r_addr;
	private int r_minCost;
	private int r_delCost;
	private String r_img;
	private int r_state;
	private String r_info;
	private Date r_regdate;
}