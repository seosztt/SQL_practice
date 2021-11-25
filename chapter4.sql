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