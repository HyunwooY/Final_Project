package com.jhta.project.mybatis.mapper.user;

import java.util.HashMap;
import java.util.List;

import com.jhta.project.vo.restaurant.FoodVo;
import com.jhta.project.vo.user.CartDetailVo;
import com.jhta.project.vo.user.CartFoodVo;
import com.jhta.project.vo.user.CartVo;
import com.jhta.project.vo.user.FoodOptionsVo;
import com.jhta.project.vo.user.InSearchOrdersVo;
import com.jhta.project.vo.user.InSearchRestaurantVo;
import com.jhta.project.vo.user.InSearchReviewVo;
import com.jhta.project.vo.user.OrderAndHitVo;
import com.jhta.project.vo.user.OrdersDetailVo;
import com.jhta.project.vo.user.OrdersOptionVo;
import com.jhta.project.vo.user.UserAddrVo;

public interface SearchMapper {
	List<UserAddrVo> selectAddr(HashMap<String, Object> map);
	List<InSearchRestaurantVo> searchRes(HashMap<String, Object> map);
	int count(HashMap<String, Object> map);
	List<String> searchCategory();
	InSearchRestaurantVo searchDetail(String r_id);
	List<FoodVo> foodlist(String r_id);
	List<FoodOptionsVo> foodOptionslist(int food_num);
	int insertcart(CartVo vo);
	int insertcartdetail(CartDetailVo vo);
	int getcartseq();
	List<CartVo> selectcart(String ui_id);
	CartVo selectcartnum(int cart_num);
	List<CartDetailVo> selectcd(int cart_num);
	int deletecart(String ui_id);
	int delcartnum(int cart_num);
	int deletecd(int cart_num);
	Double getdistance(HashMap<String, Object> map);
	String getCartRid(String ui_id);
	String getFoodRid(int food_num);
	List<CartFoodVo> selectFood(String ui_id); 
	int incOrseq();
	int incOdseq();
	int incOoseq();
	int insertOrders(InSearchOrdersVo vo);
	int insertOD(OrdersDetailVo vo);
	int insertOO(OrdersOptionVo vo);
	Double findhit(String r_id);
	List<OrderAndHitVo> orfoodcount(String r_id);
	InSearchReviewVo findreview(int or_num);
	List<String> findfoodname(int or_num);
	List<InSearchOrdersVo> findOrdersRid(String ui_id);
	InSearchOrdersVo getOrder(int or_num);
	String getRidOrnum(int or_num);
}










