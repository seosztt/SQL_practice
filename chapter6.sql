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