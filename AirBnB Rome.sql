--  Practising SQL using AirBnB database 

/* Creating Table 1 - rome_listing */
CREATE TABLE rome_listing (
    id int,
    property_name varchar(255),
    property_description varchar(255),
    neighbourhood varchar(255),
    property_type varchar(255),
    accomodates int,
    bathrooms int,
    bedrooms int,
    price int,
    booked_days_pm int
);

/* Creating Table 2 - rome_reviews */
CREATE TABLE rome_reviews (
    id int,
    host_id int,
    host_name varchar(255),
    acceptance_rate float,
    no_of_reviews_30days int,
    last_review varchar(255),
    service_score float,
    cleaniness_score float,
    checkin_score float,
    location_score float,
    average_score float
);

-- Viewing Tables

Show databases;
Show Tables;
Describe rome_listing;
Describe rome_review;

-- Altering column names after detecting misspellings
ALTER TABLE rome_listing
Rename column property_description TO
neighbourhood_name;

ALTER TABLE rome_listing
Rename column neighbourhood TO
property_amenities;

/* Question 1 - Top  100 AirBnB properties in Rome by Revenue  - Creating new column (Revenue = Price x Nights Booked) */
Select *
From rome_listing;

Select id, property_name, neighbourhood_name, property_type ,price * booked_days_pm as property_revenue
From rome_listing
Order by property_revenue Desc
Limit 100;

/* Question 2 - Rank Top 100 highly reviwed properties (> 50) with average score of 4.8stars that accomodates 2 people*/
Select rr.id, rr.host_id, rr.host_name, rl.property_name, rl.neighbourhood_name, rl.price, rr.average_score,
	   rank() over (order by rl.price asc) as property_rank
From rome_reviews as rr
Join rome_listing as rl ON rr.id = rl.id
Where no_of_reviews_30days > 50 AND average_score > 4.8 AND accommodates = 2
Limit 100;


/* Question 3 - 10 most common property types, number of properties in each type and their average price per night */
Select property_type, COUNT(*) as no_of_properties, AVG(price)
From rome_listing
Group By property_type
Order by no_of_properties DESC
Limit 10;

/* Question 4 - Getting entire rental units that provides breakfast and also has wifi  */
Select id, property_name, neighbourhood_name, property_amenities, property_type, price
From rome_listing
Where property_type = 'Entire rental unit' AND Lower(property_amenities) LIKE '%breakfast%' AND Lower(property_amenities) LIKE '%wifi%'
Order By price ASC;

/* Question 5 - Ranking neighbourhoods according to location score ratings and average price  - Round() and Rank()  */
Select rl.neighbourhood_name, Round(AVG (rr.location_score),2) as Location_Rating , Round(AVG (rl.price),2) as Average_Price,
	   rank() over (Order By AVG (rr.location_score) Desc) as Location_Rank,
       rank() over (Order By AVG (rl.price) Desc) as Price_Rank
From rome_reviews as rr
Join rome_listing as rl ON rr.id = rl.id
Group By neighbourhood_name;


/* Question 6a - Splitting hosts into categories based on acceptance rate and average scores using CASE STATEMENT*/
Select host_id, host_name, acceptance_rate, average_score,
       Case When acceptance_rate < 0.50 OR average_score < 3.5 then '1 Star Host'
       When acceptance_rate < 0.65 OR average_score < 3.8 then '2 Star Host'
       When acceptance_rate < 0.76 OR average_score < 4.07 then '3 Star Host'
	   When acceptance_rate < 0.87  OR average_score < 4.75 then  '4 Star Host'
       Else '5 Star Host'
       End as 'Host_Category'
From rome_reviews;

/* Question 6b - Getting the number of hosts in each category using SUB-QUERIES*/
Select Host_Category, Count(Host_Category) as Category_Count
From (Select host_id, host_name, acceptance_rate, average_score,
       Case When acceptance_rate < 0.50 OR average_score < 3.5 then '1 Star Host'
       When acceptance_rate < 0.65 OR average_score < 3.8 then '2 Star Host'
       When acceptance_rate < 0.76 OR average_score < 4.07 then '3 Star Host'
	   When acceptance_rate < 0.87  OR average_score < 4.75 then  '4 Star Host'
       Else '5 Star Host'
       End as 'Host_Category'
From rome_reviews) as Category
Group by Host_Category
Order by Host_Category Desc;

/* Queston 7a - Converting data types (last_review from varchar to datetime) */
Desc rome_reviews;

#First step is to convert datelike column to SQLs default YYYY-MM-DD
Update rome_reviews
Set last_review = str_to_date(last_review, "%m/%d/%Y");

Alter Table rome_reviews
Modify last_review date;

#last_review column has now being converted to datetime datatype and necessary operations can be carried out
Desc rome_reviews;

/* Queston 7b - Which Month has most reviews  - Using datetime functions monthname() and month() functions */
Select monthname(last_review) as review_month, month(last_review) as month_no, count(no_of_reviews_30days) as review_count
From rome_reviews
Group By review_month
Order By review_count DESC;

/* Queston 8a - Income per month from 2021 to 2022  */
Select  monthname(rr.last_review) as Month, sum(rl.price * rl.booked_days_pm) as Revenue
From rome_listing as rl
Join rome_reviews as rr on rl.id = rr.id
Where rr.last_review >= '2021-01-01' and rr.last_review < '2023-01-01'
Group By month
Order By FIELD(Month,'January','February','March', 'April', 'May','June', 
'July', 'August', 'September', 'October', 'November', 'December');

/* Queston 8b - Income for 2021- 2022 on a monthly cummulative basis  using Subqueries, Joins, Windows Function */
Select Month, Revenue, Sum(Revenue) Over (Order By FIELD(Month,'January','February','March', 'April', 'May','June', 
'July', 'August', 'September', 'October', 'November', 'December')) as Running_Total
From (
Select  monthname(rr.last_review) as Month, sum(rl.price * rl.booked_days_pm) as Revenue
From rome_listing as rl
Join rome_reviews as rr on rl.id = rr.id
Where rr.last_review >= '2021-01-01' and rr.last_review < '2023-01-01'
Group By month
Order By FIELD(Month,'January','February','March', 'April', 'May','June', 
'July', 'August', 'September', 'October', 'November', 'December')) a;


/* Queston 9a - List properties from cheapest to most 
expensive pwe neighbourhood - Row_Number() Windows Function*/

Select property_name, neighbourhood_name, price, property_type, accommodates,
row_number() over (partition by neighbourhood_name order by price) as neighbourhood_cost_rank
From rome_listing
Where price <> 0;


/* Queston 9a - List properties from cheapest to most expensive pwe neighbourhood - Row_Number() Windows Function*/
Select property_name, neighbourhood_name, price, property_type, accommodates,
row_number() over (partition by neighbourhood_name order by price) as cost_rank
From rome_listing
Where price <> 0;

/* Queston 9b - List 5 most expensive properties in each neighbourhood - Sub-Query, Row_Number() Windows Function*/
Select *
From (
Select property_name, neighbourhood_name, price, property_type, accommodates,
row_number() over (partition by neighbourhood_name order by price DESC) as cost_rank
From rome_listing
Where price <> 0) a
Where a.cost_rank < 6;

/* Queston 10 - Select properities that accommodates 2 with prices higher than the 
 average price  Common Table Expressions (CTE) to simplify queries*/
 
With average_price (avg_price) as 
	  (Select avg(price) From rome_listing)
Select id, property_name, neighbourhood_name, property_type, accommodates, price
From rome_listing, average_price as av
Where price > av.avg_price and accommodates = 2
Order by price;


