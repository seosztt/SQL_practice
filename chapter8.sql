# 요인별 생존 여부 관계
select *
from mydata.dataset4;

## 1) 성별
### passenger ID 중복 확인
select count(passengerid) n_passengers, count(distinct passengerid) n_d_passengers
from mydata.dataset4;

select sex, count(passengerid) n_passengers, sum(survived) n_survived
from mydata.dataset4
group by 1;

select sex, count(passengerid) n_passengers, sum(survived) n_survived, sum(Survived)/ count(PassengerId) survived_ratio
from mydata.dataset4
group by 1;

## 2) 연령, 성별
select floor(age/10)*10 ageband, age
from mydata.dataset4;

select floor(age/10)*10 ageband, count(passengerid) n_passengers, sum(survived) n_survived,
sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by 1;

select floor(age/10)*10 ageband, count(passengerid) n_passengers, sum(survived) n_survived,
sum(Survived)/ count(PassengerId) survived_rate
group by 1
order by 1;

select floor(age/10)*10 ageband, sex, count(passengerid) n_passengers, sum(survived) n_survived,
sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by 1, 2
order by 1, 2;

select floor(age/10)*10 ageband, sex, count(passengerid) n_passengers, sum(survived) n_survived,
sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by 1, 2
having sex = 'male';

select floor(age/10)*10 ageband, sex, count(passengerid) n_passengers, sum(survived) n_survived,
sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by 1, 2
having sex = 'female';

select a.ageband, a.survived_rate male_survived_rate,
		b.Survived_rate Female_survived_rate,
        b.survived_rate - a.survived_rate survived_rate_diff
from (select floor(age/10)*10 ageband, sex, count(passengerid) n_passengers, sum(survived) n_survived,
		sum(Survived)/ count(PassengerId) survived_rate
		from mydata.dataset4
		group by 1, 2
		having sex = 'male') a
left join (select floor(age/10)*10 ageband, sex, count(passengerid) n_passengers, sum(survived) n_survived,
			sum(Survived)/ count(PassengerId) survived_rate
			from mydata.dataset4
			group by 1, 2
			having sex = 'female') b
on a.ageband = b.ageband
order by a.ageband;

## 3) Pclass(객실 등급)
select distinct pclass
from mydata.dataset4;

select pclass, count(passengerid) n_passengers, sum(survived) n_survived,
			sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by pclass
order by 1;

select pclass, sex, count(passengerid) n_passengers, sum(survived) n_survived,
			sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by pclass, sex
order by 2, 1;

select pclass, sex, floor(age/10)*10 ageband, count(passengerid) n_passengers, sum(survived) n_survived,
			sum(Survived)/ count(PassengerId) survived_rate
from mydata.dataset4
group by pclass, sex, floor(age/10)*10
order by 2, 1;

# Embarked
## 1) 항구별 승객 수
select embarked, count(passengerid) n_passengers
from mydata.dataset4
group by 1
order by 1;

## 2) 승선 항구별, 성별 승객 수
select embarked, sex, count(passengerid) n_passengers
from mydata.dataset4
group by 1, 2
order by 1, 2;

## 3) 승선 항구별, 성별 승객 비중
select embarked, count(passengerid) n_passengers
from mydata.dataset4
group by 1;

select embarked, sex, count(passengerid) n_passengers
from mydata.dataset4
group by 1, 2;

select a.embarked, a.sex, a.n_passengers, b.n_passengers n_passengers_tot,
		a.n_passengers/b.n_passengers passengers_rat
from (select embarked, sex, count(passengerid) n_passengers
		from mydata.dataset4
		group by 1, 2) a
left join (select embarked, count(passengerid) n_passengers
			from mydata.dataset4
			group by 1) b
on a.embarked = b.embarked
order by 1;

# 탑승객 분석
## 1) 출발지, 도착지별 승객 수
select boarded, destination, count(passengerid) n_passengers
from mydata.dataset4
group by boarded, destination
order by 3 desc;

select *, row_number() over(order by n_passengers desc) rnk
from (select boarded, destination, count(passengerid) n_passengers
		from mydata.dataset4
		group by boarded, destination) base;

create temporary table mydata.route as
select boarded, destination
from (select *, row_number() over(order by n_passengers desc) rnk
		from (select boarded, destination, count(passengerid) n_passengers
				from mydata.dataset4
				group by boarded, destination) base
		) base
where rnk <= 5;

select name_wiki, a.boarded, a.destination
from mydata.dataset4 a
inner join mydata.route b
on a.boarded = b.boarded and a.destination = b.destination;

## 2) Hometown별 탑승객 수 및 생존율
select Hometown, sum(1) n_passengers, sum(survived)/sum(1) survived_ratio
from mydata.dataset4
group by 1;

select Hometown, sum(1) n_passengers, sum(survived)/sum(1) survived_ratio
from mydata.dataset4
group by 1
having sum(survived)/sum(1) >= 0.5 and sum(1) >= 10;