--- sql exam solutions

-- 1. What is foreign key? what is foreign key violation? 


-- 2. please list employee and their manager's name, to include every employee.
 select concat(e.lastName, e.firstName) as employee, concat(m.lastName, m.firstName) as manager
 from employees e left outer join employees m
 on m.employeeNumber = e.reportsto
 order by manager desc;
 
-- 3. Employees all over the word. Can you tell me the top three cities that we have employees?
-- Expected result:
-- City      employee count
-- San Francisco   6
-- Paris           5
-- Syndney         4
select o.city, count(1) as cnt
from employees e, offices o
where e.officecode = o.officecode 
group by o.city
order by cnt desc limit 3;

-- 4. For company products, each products has inventory and buy price, msrp. Assume that every product is sold on msrp price. 
-- Can you write a query to tell company executives: profit margin on each productlines
-- Profit margin= sum(profit if all sold) - sum(cost of each) / sum (cost)
-- Product line = each product belongs to a product line. You need group by product line. 

select *  from products;
select  productline, sum(quantityinstock * buyprice) as totalinvestment, 
-- sum(quantityinstock * msrp) as totalvalue, 
SUM(quantityInStock * (MSRP - BUYPRICE))/SUM(QUANTITYINSTOCK * BUYPRICE) AS MA
from products
group by productline
order by totalinvestment desc;

-- 5. company wants to cut sales rep because economic downturn. They look at who produce the least orders in value.
 --  a. can you write a query to help find the employee. 
 --  b. Can you delete the sales rep? the sales rep should be either inactive in employee table or replaced with its manager employeenumber in customer table. 


select salesrepemployeenumber, totalsales from (
select c.customernumber, c.salesrepemployeenumber, 
 sum(d.quantityordered * d.priceeach) as totalsales 
 from customers c, orders o, orderdetails d
where o.orderNumber = d.orderNumber and c.customernumber = o.customernumber 
group by c.customernumber, c.salesrepemployeenumber ) as temp
order by totalsales desc limit 1;

select count(1), c.salesrepemployeenumber
from customers c, orders o
where o.customernumber = c.customernumber
group by c.salesrepemployeenumber;

update customers set salesrepnumber =
 (select reportsto from employees where employeeNumber = 1370) 
 where salesrepnumber = 1370;
 
-- 6. Please list orders count and group by status  in row like the following
--       shipped  resolved . canceled
--      303        4                6
select status, count(1) from orders group by status;    

select 
sum(case when status='Shipped' then 1 else 0 end ) as shipped
from orders;




