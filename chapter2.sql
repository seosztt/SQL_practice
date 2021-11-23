select customernumber from classicmodels.customers;

select sum(amount), count(checknumber) from classicmodels.payments;

select productname, productline from classicmodels.products;

select count(productcode) as n_products,
count(productCode) n_products
 from classicmodels.products;
 
 select distinct ordernumber
 from classicmodels.orderdetails;

select *
from classicmodels.orderdetails
where priceeach between 30 and 50;

select *
from classicmodels.orderdetails
where priceeach >= 30;

select customernumber
from classicmodels.customers
where country in ('USA', 'Canada');

select customernumber
from classicmodels.customers
where country not in ('USA', 'Canada');

select employeenumber
from classicmodels.employees
where reportsto is null;

select addressline1
from classicmodels.customers
where addressline1 like '%st%';

select country, city, count(customernumber) n_customer
from classicmodels.customers
group by country, city;

select sum(case when country = 'usa' then 1 else 0 end) N_USA,
sum(case when country = 'usa' then 1 else 0 end)/count(*) usa_portion
from classicmodels.customers;

select a.ordernumber, b.country
from classicmodels.orders a
left join classicmodels.customers b
on a.customerNumber = b.customernumber;

select a.ordernumber, b.country
from classicmodels.orders a
inner join classicmodels.customers b
on a.customerNumber = b.customernumber
where b.country = 'usa';

select country,
case when country in ('usa', 'canada') then 'north america' else 'others' end as region
from classicmodels.customers;

select case when country in ('usa', 'canada') then 'north america' else 'others' end as region,
count(customerNumber) n_costomers
from classicmodels.customers
group by case when country in ('usa', 'canada') then 'north america' else 'others' end;

select case when country in ('usa', 'canada') then 'north america' else 'others' end as region
from classicmodels.customers;

select case when country in ('usa', 'canada') then 'north america' else 'others' end as region,
count(customerNumber) n_costomers
from classicmodels.customers
group by 1;

select buyprice,
row_number() over(order by buyPrice) rownumber,
rank() over(order by buyprice) rnk,
dense_rank() over(order by buyprice) denserank
from classicmodels.products;

select buyprice,
row_number() over(partition by productLine order by buyPrice) rownumber,
rank() over(partition by productLine order by buyprice) rnk,
dense_rank() over(partition by productLine order by buyprice) denserank
from classicmodels.products;

select ordernumber
from classicmodels.orders
where customerNumber
in (select customerNumber from classicmodels.customers where city ='nyc')
;

select customernumber
from (select customernumber from classicmodels.customers where city='nyc') A;

select customernumber from classicmodels.customers where city='nyc';

select ordernumber
from classicmodels.orders
where customerNumber in
(select customernumber from classicmodels.customers
 where country = 'usa')
 ;