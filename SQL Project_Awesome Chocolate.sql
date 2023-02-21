show databases;
use awesome_chocolates;
show tables;

select * from geo;
select * from people;
select * from products;
select * from sales;

-------------------------------------------------INTERMEDIATE PROBLEMS --------------------------------------------------------------------

-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales 
where Amount >2000 and Boxes < 100;

-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022? 
select p.Salesperson, count(*) as 'Total Sales'
from sales s inner join people p on s.SPID = p.SPID
where monthname(SaleDate)='January' and year(SaleDate)='2022'
group by p.Salesperson;

-- 3. Which product sells more boxes? Milk Bars or Eclairs?
select p.Product,sum(s.Boxes) as 'Total Boxes' 
from sales s inner join products p on s.PID=p.PID 
where p.Product in ('Milk Bars','Eclairs') 
group by p.Product 
order by sum(s.Boxes) desc;

-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
select p.Product,sum(s.Boxes) as 'Total Boxes' 
from sales s inner join products p on s.PID=p.PID 
where s.SaleDate between '2022-02-01' and '2022-02-07' and p.Product in ('Milk Bars','Eclairs') 
group by p.Product 
order by sum(s.Boxes) desc;

-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select * from sales 
where Customers < 100 and Boxes < 100 and weekday(SaleDate)=2;

-------------------------------------------------------HARD PROBLEMS ---------------------------------------------------------------
-- 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select p.Salesperson, count(s.SaleDate) as 'Total Count'
from sales s inner join people p on s.SPID=p.SPID 
where s.SaleDate between '2022-01-01' and '2022-01-07' 
group by p.Salesperson 
having count(s.SaleDate) >=1;

-- 2. Which salespersons did not make any shipments in the first 7 days of January 2022?
select p.Salesperson, count(s.SaleDate) as 'Total Count'
from sales s inner join people p on s.SPID=p.SPID 
where s.SaleDate between '2022-01-01' and '2022-01-07' 
group by p.Salesperson 
having count(s.SaleDate) <1;

-- 3. How many times we shipped more than 1,000 boxes in each month?
select monthname(SaleDate) as 'Month', count(Boxes) as 'Total Count' 
from sales 
where Boxes > 1000
group by monthname(SaleDate);

-- 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
select monthname(s.SaleDate) as 'Month', sum(s.Boxes) as 'Total Boxes' 
from sales s 
inner join products p on p.PID=s.PID
inner join geo g on g.GeoID=s.GeoID
where p.Product = 'After Nines' and g.Geo='New Zealand'
group by monthname(s.SaleDate) 
having sum(Boxes)>=1;

-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?
select monthname(SaleDate), sum(case when g.Geo='India' then s.Boxes else 0 end) as 'India', sum(case when g.Geo='Australia' then S.Boxes else 0 end) as 'Australia'
from sales s
inner join geo g on g.GeoID=s.GeoID
where Geo in ('India','Australia') and year(SaleDate)='2021'
group by monthname(SaleDate)
order by month(SaleDate);

