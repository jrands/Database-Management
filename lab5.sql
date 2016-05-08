
--1. 

Select agents.city
from agents inner join orders
on orders.aid = agents.aid
where orders.cid = 'c002';

--2.

Select distinct orders.pid
from orders 
inner join customers on orders.cid = customers.cid
inner join agents on orders.aid = agents.aid
where  customers.city = 'Dallas'
order by pid desc;

--3.

Select name 
from customers 
where cid not in(
	select cid 
	from orders);

--4. 

Select customers.name
from orders 
full outer join customers on orders.cid = customers.cid
where orders.cid is null;

--5. 

Select distinct customers.name, agents.name
from orders inner join customers on orders.cid = customers.cid
inner join agents on orders.aid = agents.aid
where customers.city = agents.city;

--6. 
-- YOU MISSED A SEMICOLON ON THIS ONE!!!
SELECT c.name, a.name, c.city
FROM customers c, agents a
WHERE c.city = a.city;

--7.

SELECT name, city
FROM customers c
WHERE c.city in(
	SELECT city
	FROM products
	GROUP BY city
	ORDER BY count(pid) ASC
	LIMIT 1);
