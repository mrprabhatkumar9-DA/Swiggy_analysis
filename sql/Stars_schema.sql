-- CREATING SCHEMA
-- DIMENSION TABLES

-- DATE TABLE
Create table dim_date(
	 date_id int auto_increment primary key,
     Full_date date,
     Year int,
     Month int,
     Month_name varchar(20),
     Quarter Int,
     Day Int,
     Week Int
     );

-- DIM LOCATION
Create table Dim_Location(
	Location_ID int auto_increment primary key,
    State varchar(100),
    City varchar(100),
    Location varchar(100)
    );
    
-- DIM RESTAURANT
Create table Dim_Restaurant(
Restaurant_Id int auto_increment primary key,
Restaurant_name varchar(100)
);

-- DIM CATEGORY
Create table Dim_Category(
Category_Id int auto_increment primary key,
Category varchar(200)
);

-- DIM_DISH
create table Dim_dish(
Dish_id int auto_increment primary key,
Dish_name varchar(200)
);

-- FACT TABLE
Create table Fact_swiggy_orders(
	Order_id int auto_increment primary key,
		date_id int,
        Price_INR decimal(10,2),
        Rating decimal(4,2),
        rating_count int,
        
        location_id int,
        restaurant_id int,
        category_id int,
        dish_id int,
        
        foreign key(date_id) references dim_date(date_id),
        foreign key(location_id) references dim_location(location_id),
        foreign key(restaurant_id) references dim_restaurant(restaurant_id),
        foreign key(category_id) references dim_category(category_id),
        foreign key(dish_id) references dim_dish(dish_id)
);

-- INSERT DATA INTO TABLES
-- DIM DATE
select*from swiggy;
Insert into dim_date(Full_date, Year, Month, Month_name, Quarter, Day, Week)
Select distinct
	Order_date,
    year(Order_date),
    month(Order_date),
    monthname(Order_date),
    quarter(Order_date),
    day(Order_date),
    week(Order_date)
From swiggy
where order_date is not null;
select*from dim_date;

-- DIM LOCATION
select*from dim_location;
insert into dim_location(State, City, Location)
select distinct
	State,
    City,
    Location
from swiggy
where Order_Date is not null;

-- DIM CATEGORY
select*from swiggy;
select*from dim_category;
insert into dim_category(Category)
select distinct
	Category
from swiggy;

-- DIM DISH
select*from swiggy;
select*from dim_dish;
insert into dim_dish(Dish_name)
select distinct
	Dish_name
from swiggy;

-- DIM RESTAURANT
select*from swiggy;
select*from dim_restaurant;
insert into dim_restaurant(Restaurant_name)
select distinct
	Restaurant_name
from swiggy;

-- FACT TABLE
select*FROM fact_swiggy_orders;
INSERT INTO fact_swiggy_orders
(	
DATE_ID, 
PRICE_INR,
RATING, 
RATING_COUNT, 
LOCATION_ID, 
RESTAURANT_ID, 
CATEGORY_ID, 
DISH_ID
)

select
	dd.date_id,
    s.price,
    s.rating,
    s.rating_count,
    
    dl.location_id,
    dr.restaurant_id,
    dc.category_id,
    dsh.dish_id
from swiggy s

JOIN dim_date as dd
	ON dd.Full_date=s.order_date
    
JOIN dim_category as dc
	ON dc.Category=s.category
    
JOIN dim_dish as dsh
	ON dsh.dish_name=s.Dish_Name
    
JOIN dim_location as dl
	ON dl.state=s.state
    AND dl.City=s.city
    AND dl.Location=s.location

JOIN dim_restaurant as dr
	ON dr.Restaurant_name=s.Restaurant_Name; 
    
select * from fact_swiggy_orders f
	JOIN dim_date d ON f.date_id=d.date_id
    JOIN dim_category dc ON f.category_id=dc.Category_Id
    JOIN dim_dish as dsh ON f.dish_id=dsh.Dish_id
    JOIN dim_location as dl ON f.location_id=dl.Location_ID
    JOIN dim_restaurant as dr ON f.restaurant_id=dr.Restaurant_Id;
