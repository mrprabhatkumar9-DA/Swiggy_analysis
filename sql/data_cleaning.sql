-- DATA VALIDATION & CLEANING
-- NULL CHECK
select
	sum(case when State is null then 1 else 0 end) as null_state,
    sum(case when city is null then 1 else 0 end) as null_city,
    sum(case when order_date is null then 1 else 0 end) as null_order_date,
    sum(case when restaurant_name is null then 1 else 0 end) as null_restaurant_name,
    sum(case when location is null then 1 else 0 end) as null_Location,
    sum(case when category is null then 1 else 0 end) as null_category,
    sum(case when Dish_name is null then 1 else 0 end) as null_dish_name,
    sum(case when Price is null then 1 else 0 end) as Null_Price,
    sum(case when Rating is null then 1 else 0 end) as Null_rating,
    sum(case when rating_count is null then 1 else 0 end) as null_rating_count
    from swiggy;
    
-- BLANK OR EMPTY STRINGS
select * 
from swiggy
where
state='' or city='' or restaurant_name='' or location='' or category='' or dish_name='';

-- DUPLICATE DETECTIONS
select
state, city, order_date, restaurant_name, location, category, dish_name, price, rating, rating_count, count(*) as Dup_count
from swiggy
group by state, city, order_date, restaurant_name, location, category, dish_name, price, rating, rating_count
having count(*)>1;

-- CREATE A PRIMARY COLUMN
alter table swiggy add column s_no int auto_increment primary key first;

-- DELETE DUPLICATES
delete from swiggy
where s_no in(
with cte as(
select *,
row_number() over(partition by state, city, order_date, restaurant_name, location, category,
dish_name, price, rating, rating_count order by s_no) as rn from swiggy)
select s_no from cte where rn>1);
