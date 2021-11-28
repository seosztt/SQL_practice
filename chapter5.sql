select `division name`, avg(rating) avg_rate
from mydata.dataset2
group by 1
order by 2 desc;

select `department name`, avg(rating) avg_rate
from mydata.dataset2
group by 1
order by 2 desc;

select *
from mydata.dataset2
where `Department Name` = 'Trend'
and rating <= 3;

select case when age between 0 and 9 then '0009'
when age between 10 and 19 then '10'
when age between 20 and 29 then '20'
when age between 30 and 39 then '30'
when age between 40 and 49 then '40'
when age between 50 and 59 then '50'
when age between 60 and 69 then '60'
when age between 70 and 79 then '70'
when age between 80 and 89 then '80'
when age between 90 and 99 then '90' end ageband,
age
from mydata.dataset2
where `department name` = 'Trend'
and rating <= 3;

select floor(age/10)*10 ageband,
count(*) cnt
from mydata.dataset2
where `department name` = 'Trend'
and rating <= 3
group by 1
order by 2 desc;

select floor(age/10)*10 ageband, count(*) cnt
from mydata.dataset2
where `department name` = 'Trend'
group by 1
order by 2 desc;

select *
from mydata.dataset2
where `department name` = 'Trend'
and rating <= 3
and age between 50 and 59 limit 10;

select `department name`, `clothing id`, avg(rating) avg_rate
from mydata.dataset2
group by 1, 2;

select *, row_number() over(partition by `department name` order by avg_rate) rnk
from (select `department name`, `clothing id`, avg(rating) avg_rate
	  from mydata.dataset2
	  group by 1, 2)
a;

select * 
from(select *, row_number() over(partition by `department name` order by avg_rate) rnk
	 from (select `department name`, `clothing id`, avg(rating) avg_rate
		   from mydata.dataset2
		   group by 1, 2)
	 a)
a
where rnk <= 10;

create temporary table mydata.stat as
select *
from (select *, row_number() over(partition by `department name` order by avg_rate) rnk
	  from (select `department name`, `clothing id`, avg(rating) avg_rate
			from mydata.dataset2
            group by 1, 2)
	  a)
a
where rnk <= 10;
		  
select `clothing id`
from mydata.stat
where `department name` = 'bottoms';

select *
from mydata.dataset2
where `Clothing ID`
in (select `Clothing ID`
	from mydata.stat
    where `department name` = 'bottoms')
order by `Clothing ID`;

select `department name`, floor(age/10)*10 ageband, avg(rating) avg_rating
from mydata.dataset2
group by 1, 2;

select *, row_number() over(partition by ageband order by avg_rating) rnk
from (select `department name`, floor(age/10)*10 ageband, avg(rating) avg_rating
	  from mydata.dataset2
	  group by 1, 2)
a;

select *
from (select *, row_number() over(partition by ageband order by avg_rating) rnk
	  from (select `department name`, floor(age/10)*10 ageband, avg(rating) avg_rating
		    from mydata.dataset2
		    group by 1, 2)
	  a)
a
where rnk = 1;

select `review text`, case when `review text` like '%size%' then 1 else 0 end size_yn
from mydata.dataset2;

select sum(case when `review text` like '%size%' then 1 else 0 end) n_size,
sum(case when `review text` like '%large%' then 1 else 0 end) n_large,
sum(case when `review text` like '%loose%' then 1 else 0 end) n_loose,
sum(case when `review text` like '%small%' then 1 else 0 end) n_small,
sum(case when `review text` like '%tight%' then 1 else 0 end) n_tight,
sum(1) N_total
from mydata.dataset2;

select `department name`,
sum(case when `review text` like '%size%' then 1 else 0 end) n_size,
sum(case when `review text` like '%large%' then 1 else 0 end) n_large,
sum(case when `review text` like '%loose%' then 1 else 0 end) n_loose,
sum(case when `review text` like '%small%' then 1 else 0 end) n_small,
sum(case when `review text` like '%tight%' then 1 else 0 end) n_tight,
sum(1) N_total
from mydata.dataset2
group by 1;

select floor(age/10)*10 ageband,
`department name`,
sum(case when `review text` like '%size%' then 1 else 0 end)/sum(1) n_size,
sum(case when `review text` like '%large%' then 1 else 0 end)/sum(1) n_large,
sum(case when `review text` like '%loose%' then 1 else 0 end)/sum(1) n_loose,
sum(case when `review text` like '%small%' then 1 else 0 end)/sum(1) n_small,
sum(case when `review text` like '%tight%' then 1 else 0 end)/sum(1) n_tight
from mydata.dataset2
group by 1, 2
order by 1, 2;

select `Clothing ID`, sum(case when `review text` like '%size%' then 1 else 0 end) n_size
from mydata.dataset2
group by 1;

select `clothing id`,
sum(case when `review text` like '%size%' then 1 else 0 end) n_size_t,
sum(case when `review text` like '%size%' then 1 else 0 end)/sum(1) n_size,
sum(case when `review text` like '%large%' then 1 else 0 end)/sum(1) n_large,
sum(case when `review text` like '%loose%' then 1 else 0 end)/sum(1) n_loose,
sum(case when `review text` like '%small%' then 1 else 0 end)/sum(1) n_small,
sum(case when `review text` like '%tight%' then 1 else 0 end)/sum(1) n_tight
from mydata.dataset2
group by 1;

create table mydata.size_stat as
select `clothing id`,
sum(case when `review text` like '%size%' then 1 else 0 end) n_size_t,
sum(case when `review text` like '%size%' then 1 else 0 end)/sum(1) n_size,
sum(case when `review text` like '%large%' then 1 else 0 end)/sum(1) n_large,
sum(case when `review text` like '%loose%' then 1 else 0 end)/sum(1) n_loose,
sum(case when `review text` like '%small%' then 1 else 0 end)/sum(1) n_small,
sum(case when `review text` like '%tight%' then 1 else 0 end)/sum(1) n_tight
from mydata.dataset2
group by 1;