# 지표 추출
# 1) 전체 주문 건수
select count(distinct order_id) f
from instacart.orders;

# 2) 구매자 수
select count(distinct user_id) bu
from instacart.orders;

# 3) 상품별 주문 건수
select b.product_name, count(distinct a.order_id) n_product
from instacart.order_products__prior a
left join instacart.products b
on a.product_id=b.product_id
group by 1 
order by 2 desc
limit 100000;

# 4) 장바구니에 먼저 넣는 상품 10개
select product_id, case when add_to_cart_order = 1 then 1 else 0 end f_1st
from instacart.order_products__prior;

select product_id, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
from instacart.order_products__prior
group by 1 limit 100000;

select *, row_number() over(order by f_1st desc) rnk
from (select product_id, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
	  from instacart.order_products__prior
	  group by 1)
a;
select *
from (select *, row_number() over(order by f_1st desc) rnk
	  from (select product_id, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
	   	    from instacart.order_products__prior
		    group by 1)
	  a)
base
where rnk <= 10; # rnk between 1 and 10

select product_id, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
from instacart.order_products__prior
group by 1
order by 2 desc limit 10;

# 5) 시간별 주문 건수
select order_hour_of_day, count(distinct order_id) f
from instacart.orders
group by 1
order by 1;

# 6) 첫 구매 후 다음 구매까지 걸린 평균 일수
select avg(days_since_prior_order) avg_recency
from instacart.orders
where order_number = 2;

# 7) 주문 건당 평균 구매 상품 수(UPT, Unit Per Transaction)
select count(product_id) / count(distinct order_id) upt
from instacart.order_products__prior;

# 8) 인당 평균 주문 건수
select count(order_id) / count(distinct user_id) avg_f
from instacart.orders;

# 9) 재구매율이 가장 높은 상품 10개
select product_id, sum(case when reordered = 1 then 1 else 0 end) / count(*) ret_ratio
from instacart.order_products__prior
group by 1;

select *, row_number() over(order by ret_ratio desc) rnk
from (select product_id, sum(case when reordered = 1 then 1 else 0 end) / count(*) ret_ratio
	  from instacart.order_products__prior
	  group by 1)
a;

select *
from (select *, row_number() over(order by ret_ratio desc) rnk
	  from (select product_id, sum(case when reordered = 1 then 1 else 0 end) / count(*) ret_ratio
		    from instacart.order_products__prior
		    group by 1)
	  a)
base
where rnk <= 10;

# 10) Department별 재구매율이 가장 높은 상품 10개
select *
from (select *, row_number() over(partition by department order by ret_ratio desc) rnk
	from (select c.department, a.product_id, sum(case when reordered = 1 then 1 else 0 end)/count(*) ret_ratio
		from instacart.products a
		left join instacart.order_products__prior b
		on a.product_id = b.product_id
		left join instacart.departments c
		on c.department_id = a.department_id
		group by 1, 2)
	a)
a
where rnk <= 10;


# 구매자 분석
# 1) 10분위 분석
select *, row_number() over(order by f desc) rnk
from (select user_id, count(distinct order_id) f
	from instacart.orders
	group by 1)
a;

select count(distinct user_id)
from (select user_id, count(distinct order_id) f
	from instacart.orders
	group by 1)
a;

select *,
case when rnk <= 316 then 'Quantile_1'
when rnk <= 632 then 'Quantile_2'
when rnk <= 948 then 'Quantile_3'
when rnk <= 1264 then 'Quantile_4'
when rnk <= 1580 then 'Quantile_5'
when rnk <= 1895 then 'Quantile_6'
when rnk <= 2211 then 'Quantile_ 7'
when rnk <= 2527 then 'Quantile_8'
when rnk <= 2843 then 'Quantile_9'
when rnk <= 3159 then 'Quantile_10' end quantile
from (select *, row_number() over(order by f desc) rnk
	from (select user_id, count(distinct order_id) f
		from instacart.orders
		group by 1)
	a)
a;

create temporary table instacart.user_quantile as
select *,
case when rnk <= 316 then 'Quantile_1'
when rnk <= 632 then 'Quantile_2'
when rnk <= 948 then 'Quantile_3'
when rnk <= 1264 then 'Quantile_4'
when rnk <= 1580 then 'Quantile_5'
when rnk <= 1895 then 'Quantile_6'
when rnk <= 2211 then 'Quantile_ 7'
when rnk <= 2527 then 'Quantile_8'
when rnk <= 2843 then 'Quantile_9'
when rnk <= 3159 then 'Quantile_10' end quantile
from (select *, row_number() over(order by f desc) rnk
	from (select user_id, count(distinct order_id) f
		from instacart.orders
		group by 1)
	a)
a;

select quantile, sum(f) f
from instacart.user_quantile
group by 1;

select sum(f) from instacart.user_quantile;

select quantile, sum(f)/3220 f
from instacart.user_quantile
group by 1;

# 상품 분석
select product_id, sum(reordered)/sum(1) reorder_rate, count(distinct order_id) f
from instacart.order_products__prior
group by product_id
order by reorder_rate desc;

select product_id, sum(reordered)/sum(1) reorder_rate, count(distinct order_id) f
from instacart.order_products__prior
group by product_id
having count(distinct order_id) > 10;

select a.product_id, sum(reordered)/sum(1) reorder_rate, count(distinct order_id) f
from instacart.order_products__prior a
left join instacart.products b
on a.product_id = b.product_id
group by product_id
having count(distinct order_id) > 10;

select a.product_id, b.product_name, sum(reordered)/sum(1) reorder_rate, count(distinct order_id) f
from instacart.order_products__prior a
left join instacart.products b
on a.product_id = b.product_id
group by product_id, b.product_name
having count(distinct order_id) > 10;

# 다음 구매까지의 소요 기간과 재구매 관계
select *, row_number() over(order by ret_ratio desc) rnk
from (select product_id, sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
	from instacart.order_products__prior
	group by 1)
a;

create temporary table instacart.product_repurchase_quantile as
select a.product_id, case when rnk <= 929 then 'q_1'
when rnk <= 1858 then 'q_2'
when rnk <= 2786 then 'q_3'
when rnk <= 3715 then 'q_4'
when rnk <= 4644 then 'q_5'
when rnk <= 5573 then 'q_6'
when rnk <= 6502 then 'q_7'
when rnk <= 7430 then 'q_8'
when rnk <= 8359 then 'q_9'
when rnk <= 9288 then 'q_10' end rnk_grp
from (select *, row_number() over(order by ret_ratio desc) rnk
	from (select product_id, sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
		from instacart.order_products__prior
		group by 1)
	a)
a
group by 1, 2;

create temporary table instacart.order_products__prior2 as
select product_id, days_since_prior_order
from instacart.order_products__prior a
inner join instacart.orders b
on a.order_id = b.order_id;

select a.rnk_grp, a.product_id, variance(days_since_prior_order) var_days
from instacart.product_repurchase_quantile a
left join instacart.order_products__prior2 b
on a.product_id = b.product_id
group by 1,2
order by 1;

select rnk_grp, avg(var_days) avg_var_days
from (select a.rnk_grp, a.product_id, variance(days_since_prior_order) var_days
	from instacart.product_repurchase_quantile a
	left join instacart.order_products__prior b
	on a.product_id = b.product_id
	left join instacart.orders c
	on b.order_id = c.order_id
	group by 1, 2)
a
group by 1
order by 1;