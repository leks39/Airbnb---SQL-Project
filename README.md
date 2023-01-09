# Airbnb---SQL-Project
Created a database from scratch to answer questions tourist visting Rome might have with regards Airbnb listings in the city.

A summary of the steps involved in this project was;

* Downloading csv files from http://insideairbnb.com/get-the-data/ to get listing and review details of Airbnb properties in Rome

* Importing csv files into Python using packages such as; MySQLdb (connects SQL and Python), csv, sys and pandas

* Writing Python code to insert files into SQL using the cursor. execute function ()

* Creating a database in MySQL called Rome_AirBnB and tables called Rome_Listing and Rome_Reviews to store the files

* Answering questions below using more complex SQL commands such as Aggregate functions, Pattern matching using Wildcards (%) Rank, Row Number CTEs, Sub Queries, Datatype conversions, Datetime functions, and CASE Statements.

QUESTIONS

1. Fetching Top 100 highly reviewed properties with

 an average score of over 4.8stars that accommodates 2 people 

2. Getting entire rental units that house 2 people with breakfast included and also have wifi 

3. Ranking neighbourhoods in Rome according to location score ratings and average price 

4. Month with the highest number of reviews

5. Splitting hosts into categories based on acceptance rate and average scores

6. Number of hosts in each category from Question 5

7. Listing 5 most expensive properties in each neighbourhood

8. Selecting properties that accommodate 2 with prices higher than the average price

9. Income per  month for hosts from 2021 - 2022 

10. Cummulative income per month for hosts from 2021 -2022
