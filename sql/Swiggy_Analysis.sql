-- KPI's
-- TOTAL ORDERS
select count(*) as Total_orders
from fact_swiggy_orders;

-- TOTAL REVENUE (INR MILLION)
select*from fact_swiggy_orders;
SELECT 
    CONCAT(FORMAT(SUM(Price_INR)/1000000, 2), ' INR Million') AS Total_revenue
FROM fact_swiggy_orders;

-- AVG Dish Price
SELECT
	CONCAT(FORMAT(AVG(Price_INR),2), ' INR') as AVG_Dis_Price
from fact_swiggy_orders;

-- AVG Rating
select
	format(avg(rating),2) as AVG_Rating
from fact_swiggy_orders;

-- Deep Drive Business Analysis

-- Monthly Order Trends
select
d.year,
d.month,
d.month_name,
count(*) as Total_Orders
from fact_swiggy_orders f
JOIN dim_date d on
d.date_id=f.date_id
group by d.year, d.month, d.month_name
order by Total_Orders desc;

-- Total Revenue By Month in INR Million
select
d.year,
d.month,
d.month_name,
concat(format(sum(f.Price_INR)/1000000,2)," INR Million") as Tota_revenue
from fact_swiggy_orders f
JOIN dim_date d ON
d.date_id=f.date_id
group by d.year, d.month, d.month_name
order by Tota_revenue desc;

-- Quarterly Trend by orders
select
d.year,
d.quarter,
count(*) as Total_orders
from fact_swiggy_orders f
JOIN dim_date d on
d.date_id=f.date_id
group by d.year, d.quarter
order by Total_orders desc;

-- Quarterly Trend by Revenue in INR Million
select
d.year,
d.quarter,
concat(format(sum(Price_INR)/1000000,2), " INR Million") as Total_revenue
from fact_swiggy_orders f
JOIN dim_date d ON
d.date_id=f.date_id
group by d.year, d.quarter
order by Total_revenue;

-- Yearly Trend
select
d.year,
count(*) as Total_orders
from fact_swiggy_orders f
JOIN dim_date d ON
d.date_id=f.date_id
group by d.year;

-- Orders By Day of Week [Mon-Sun]
select
	dayname(d.full_date) as Day_name,
	count(*) as Total_orders
from fact_swiggy_orders f
JOIN dim_date as d ON
d.date_id=f.date_id
group by Day_name, dayofweek(d.full_date)
order by dayofweek(d.full_date);

-- Top 10 Cities By Order Value
select
d.City,
Count(*) as Total_order
from fact_swiggy_orders f
JOIN dim_location d ON
d.Location_ID=f.location_id
group by d.City
order by Total_order desc
limit 10;

 -- Top 10 Cities By Revenue in INR Million
select
d.City,
concat(format(sum(f.Price_INR)/1000000,2)," INR Million") as Total_order
from fact_swiggy_orders f
JOIN dim_location d ON
d.Location_ID=f.location_id
group by d.City
order by Total_order desc
limit 10;

-- Revenue Contribution By States
select
d.state,
sum(Price_INR) as Total_revenue
from fact_swiggy_orders f
JOIN dim_location d ON
d.Location_ID=f.location_id
group by d.state
order by Total_revenue desc;

-- Top 10 Restaurant By Orders
select
d.restaurant_name,
count(*) as Total_orders
from fact_swiggy_orders f
JOIN dim_restaurant d ON
d.Restaurant_Id=f.restaurant_id
group by d.restaurant_name
order by Total_Orders desc
Limit 10;

-- Top 10 Restaurant By Revenue
select
d.restaurant_name,
sum(Price_INR) as Total_revenue
from fact_swiggy_orders f
JOIN dim_restaurant d ON
d.Restaurant_Id=f.restaurant_id
group by d.restaurant_name
order by Total_revenue desc
Limit 10;

-- Top categories
select
d.Category,
count(*) as Total_orders
from fact_swiggy_orders f
JOIN dim_category as d ON
d.Category_Id=f.category_id
group by d.Category
order by Total_orders desc;

-- Most Order Dish
select
d.Dish_name,
count(*) as Total_Order
from fact_swiggy_orders f
JOIN dim_dish d ON
d.Dish_id=f.dish_id
group by d.Dish_name
order by Total_Order desc;

-- Cuisine Performance
Select
d.category,
count(*) as Total_orders,
format(avg(Rating),2) as Rating
from fact_swiggy_orders f
JOIN dim_category d ON
d.Category_Id=f.category_id
group by d.category
order by Total_orders desc;

-- Total Orders By Price Range
Select
	CASE
		when Price_INR < 100 THEN 'UNDER 100'
        when Price_INR Between 100 and 199 Then '100-199'
        when Price_INR Between 200 and 299 Then '200-299'
        when Price_INR Between 300 and 499 Then '300-499'
        Else '500+'
        End as Price_range,
	count(*) as Total_Orders
From fact_swiggy_orders
group by
	CASE
		when Price_INR < 100 THEN 'UNDER 100'
        when Price_INR Between 100 and 199 Then '100-199'
        when Price_INR Between 200 and 299 Then '200-299'
        when Price_INR Between 300 and 499 Then '300-499'
        Else '500+'
	END
order by Total_orders desc;

-- Rating Count Distribution
Select
	rating,
    Count(*) as Total_rating
from fact_swiggy_orders
group by rating
Order by Total_rating desc;

-- Month over Month Growth

with cte as(
select
	d.Month,
    d.Month_name,
    sum(f.Price_INR) as Current_sales
from fact_swiggy_orders f
JOIN dim_date d ON
d.date_id=f.date_id
group by d.Month_name, d.Month
order by d.month),

cte2 as(
select *,
lag(Current_sales) over(order by month) as Previous_sales
from cte)

select Month_name, Current_sales, Previous_sales,
round((Current_sales-Previous_sales)/Previous_sales,2)*100 as Growth_Degrowth
from cte2;
