select a.orderdate, priceeach*quantityordered
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.ordernumber;

select a.orderdate,
sum(priceeach*quantityordered) as sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.ordernumber
group by 1
order by 1;

select substr('abcde', 2 ,3);

select substr(a.orderdate,1,7) MM,
sum(priceeach*quantityordered) as sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.ordernumber
group by 1
order by 1;

select substr(a.orderdate, 1, 4) MM,
sum(priceeach*quantityordered) as sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.ordernumber
group by 1
order by 1;

select orderdate,
customernumber,
ordernumber
from classicmodels.orders;

# 칼럼에 중복된 값이 있는지 확인하는 방법
select count(ordernumber) n_orders,
count(distinct ordernumber) n_orders_distinct
from classicmodels.orders;

select orderdate,
count(distinct customernumber) n_purchaser,
count(ordernumber) n_orders
from classicmodels.orders
group by 1
order by 1;


select substr(a.orderdate, 1, 4) YY,
count(distinct a.customernumber) n_purchaser,
sum(priceeach*quantityordered) as sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.orderNumber = b.orderNumber
group by 1
order by 1;

select substr(a.orderdate, 1, 4) YY,
count(distinct a.customernumber) n_purchaser,
sum(priceeach*quantityordered) as sales,
sum(priceeach*quantityordered)/ count(distinct a.customernumber) amv
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.orderNumber = b.orderNumber
group by 1
order by 1;

select substr(a.orderdate,1,4) YY,
count(distinct a.ordernumber) n_purchaser,
sum(priceeach*quantityordered) as sales,
sum(priceeach*quantityordered)/ count(distinct a.ordernumber) atv
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber=b.ordernumber
group by 1
order by 1;

select *
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.orderNumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
;

select c.country, c.city, sum(priceEach*quantityordered) sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.orderNumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
group by 1,2;

select c.country, c.city, sum(priceEach*quantityordered) sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.orderNumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
group by 1,2
order by 1,2;

select case when country in ('usa', 'canada') Then 'North America'
else 'Others' end country_GRP
from classicmodels.customers;

select c.country, c.city, sum(priceEach*quantityordered) sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.orderNumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
group by 1,2
order by 3 desc;

select case when country in ('usa', 'canada') Then 'North America'
else 'Others' end country_GRP,
sum(priceEach*quantityordered) sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.orderNumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
group by 1
order by 2 desc;

create table classicmodels.stat as
select c.country,
sum(priceEach*quantityordered) sales
from classicmodels.orders a
left join classicmodels.orderdetails b
on a.ordernumber = b.ordernumber
left join classicmodels.customers c
on a.customerNumber = c.customerNumber
group by 1
order by 2 desc;

select *
from classicmodels.stat;

select country, sales,
dense_rank() over(order by sales desc) rnk
from classicmodels.stat;

create table classicmodels.stat_rnk as
select country, sales,
dense_rank() over(order by sales desc) rnk
from classicmodels.stat;

select *
from classicmodels.stat_rnk;

select *
from classicmodels.stat_rnk
where rnk between 1 and 5;

select * from
	(select country, sales,
	dense_rank() over(order by sales desc) rnk from
		(select c.country, sum(priceEach*quantityordered) sales from
		classicmodels.orders a
        left join classicmodels.orderdetails b
        on a.ordernumber = b.ordernumber
        left join classicmodels.customers c
        on a.customerNumber = c.customerNumber
        group by 1) a) a
        where rnk <= 5;
        
select a.customernumber, a.orderdate, b.customernumber, b.orderdate
from classicmodels.orders a
left join classicmodels.orders b
on a.customerNumber = b.customerNumber
and substr(a.orderdate, 1, 4) = substr(b.orderdate, 1, 4) -1;

select c.country, substr(a.orderdate, 1, 4) YY,
count(distinct a.customernumber) bu_1,
count(distinct b.customernumber) bu_2,
count(distinct b.customernumber)/ count(distinct a.customernumber)
retention_rate
from classicmodels.orders a
left join classicmodels.orders b
on a.customerNumber = b.customerNumber
and substr(a.orderdate,1,4) = substr(b.orderdate, 1, 4) -1
left join classicmodels.customers c
on a.customerNumber=c.customerNumber
group by 1,2;

create table classicmodels.product_sales as
select d.productname,
sum(quantityordered*priceEach) sales
from classicmodels.orders a
left join classicmodels.customers b
on a.customerNumber = b.customerNumber
left join classicmodels.orderdetails c
on a.ordernumber = c.orderNumber
left join classicmodels.products d
on c.productCode = d.productCode
where b.country = 'usa'
group by 1;
        
select * from
	(select *, row_number() over(order by sales desc) rnk
	from classicmodels.product_sales) a
	where rnk <= 5
	order by rnk;

