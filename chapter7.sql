# 국가별, 상품별 구매자 수 및 매출액
select country, stockcode, count(distinct customerid) bu, sum(quantity * unitprice) sales
from mydata.dataset3
group by 1, 2
order by 3 desc, 4 desc;

# 특정 상품 구매자가 많이 구매한 상품은?
## 1) 가장 많이 판매된 2개 상품 조회(판매 상품 수 기준)
select stockcode, sum(quantity) qty
from mydata.dataset3
group by 1;

select *, row_number() over(order by qty desc) rnk
from (select stockcode, sum(quantity) qty
	from mydata.dataset3
	group by 1)
a;

select stockcode
from (select *, row_number() over(order by qty desc) rnk
	from (select stockcode, sum(quantity) qty
		from mydata.dataset3
		group by 1)
	a)
a
where rnk <= 2;

# 가장 많이 판매된 2개 상품을 모두 구매한 구매자가 구매한 상품
create table mydata.bu_list as
select customerid
from mydata.dataset3
group by 1
having max(case when stockcode = '84077' then 1 else 0 end) = 1
and max(case when StockCode = '85123a' then 1 else 0 end) = 1;

select distinct stockcode
from mydata.dataset3
where customerid in (select CustomerID from mydata.bu_list)
and StockCode not in ('84077', '85123a');

# 국가별 재구매율 계산
select a.country, substr(a.invoicedate,1,4) YY, count(distinct b.CustomerID)/count(distinct a.customerid) retention_rate
from (select distinct Country, InvoiceDate, CustomerID
		from mydata.dataset3) a
left join (select distinct country, invoicedate, customerid
			from mydata.dataset3) b
on substr(a.invoicedate, 1, 4) = substr(b.invoicedate, 1, 4) -1
	and a.country = b.country
	and a.customerid = b.customerid
group by 1, 2
order by 1, 2;

# 코호트 분석
select customerid, min(invoicedate) mndt
from mydata.dataset3
group by 1;

select CustomerID, invoicedate, unitprice*quantity sales
from mydata.dataset3;

select *
from (select customerid, min(invoicedate) MNDT
		from mydata.dataset3
		group by 1) a
left join (select CustomerID, InvoiceDate, UnitPrice*quantity sales
			from mydata.dataset3) b
on a.customerid = b.customerid;

select substr(mndt, 1, 7) MM, timestampdiff(month, mndt, invoicedate) datediff,
		count(distinct a.customerid) bu, sum(sales) sales
from (select customerid, min(invoicedate) mndt
		from mydata.dataset3
        group by 1) a
left join (select customerid, InvoiceDate, UnitPrice*quantity sales
			from mydata.dataset3) b
on a.customerid = b.customerid
group by 1,2;

# 고객 세그먼트
## 1) RFM
select customerid, max(invoicedate) mxdt
from mydata.dataset3
group by 1;

select customerid, datediff('2011-12-02', mxdt) recency, frequency, monetary
from (select customerid, max(invoicedate) mxdt,
			count(distinct invoiceno) frequency, sum(quantity*unitprice) monetary
		from mydata.dataset3
		group by 1)
a;

## 2) 재구매 segment
select customerid, stockcode, count(distinct substr(invoicedate, 1,4)) unique_yy
from mydata.dataset3
group by 1, 2
having unique_yy >=2;

select customerid, case when mx_unique_yy >= 2 then 1 else 0 end repurchase_segment
from (select customerid, max(unique_yy) mx_unique_yy
		from (select customerid, stockcode, count(distinct substr(invoicedate, 1, 4)) unique_yy
				from mydata.dataset3
                group by 1, 2) a
		group by 1) a
group by 1;
		
# 일자별 첫 구매자 수
select customerid, min(invoicedate) mndt
from mydata.dataset3
group by CustomerID;

select mndt, count(distinct customerid) bu
from (select customerid, min(invoicedate) mndt
		from mydata.dataset3
		group by CustomerID) a
group by mndt;

# 상품별 첫 구매 고객 수
## 1) 고객별, 상품별 첫 구매 일자
select customerid, stockcode, min(invoicedate) mndt
from mydata.dataset3
group by 1, 2;

## 2) 고객별 구매와 기준 순위 생성(랭크)
select *, row_number() over(partition by customerid order by mndt) rnk
from (select customerid, stockcode, min(invoicedate) mndt
	from mydata.dataset3
	group by 1, 2) a
;

## 3) 고객별 첫 구매 내역 조회
select *
from (select *, row_number() over(partition by customerid order by mndt) rnk
		from (select customerid, stockcode, min(invoicedate) mndt
			from mydata.dataset3
			group by 1, 2)
		a) a
where rnk = 1;

## 4) 상품별 첫 구매 고객 수 집계
select stockcode, count(customerid) first_bu
from (select *
		from (select *, row_number() over(partition by customerid order by mndt) rnk
				from (select customerid, stockcode, min(invoicedate) mndt
					from mydata.dataset3
					group by 1, 2) a
				) a
		where rnk = 1) a
group by StockCode
order by 2 desc;

# 첫 구매 후 이탈하는 고객의 비중
select customerid, count(distinct invoicedate) f_date
from mydata.dataset3
group by 1;

select sum(case when f_date=1 then 1 else 0 end)/ sum(1) bounce_rate
from (select customerid, count(distinct invoicedate) f_date
		from mydata.dataset3
		group by 1) a;
        
select Country, sum(case when f_date=1 then 1 else 0 end)/ sum(1) bounce_rate
from (select customerid, Country, count(distinct invoicedate) f_date
		from mydata.dataset3
		group by 1, 2) a
group by 1
order by country;

# 판매 수량이 20% 이상 증가한 상품 리스트 (YTD)
