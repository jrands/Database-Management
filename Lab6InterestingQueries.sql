
--1
SELECT name, city
FROM customers
WHERE city in (
        SELECT customers.city
        from products
        GROUP BY city
        ORDER BY count(pid) DESC
        LIMIT 1);

--2 
SELECt name
from products
where priceUSD > (
        select AVG(priceUSD)
        FROM products
        )
order by name desc

--3
Select customers.name, orders.pid, sum(orders.dollars) as totalOrderSum
	from orders inner join customers on orders.cid = customers.cid
	group by customers.name, orders.pid
	Order BY totalOrderSum desc;
	
--4
Select customers.name, COALESCE(sum(orders.dollars), 0) as totalOfAllOrders
	from orders full outer join customers on orders.cid = customers.cid
	group by customers.name
	order by customers.name asc
	
--5
Select customers.name, products.name, agents.name
	from orders inner join customers on orders.cid = customers.cid
	inner join agents on orders.aid = agents.aid
	inner join products on orders.pid = products.pid
	where orders.cid in
	(
		Select orders.cid
			from orders inner join customers on orders.cid = customers.cid
			inner join agents on orders.aid = agents.aid
			where orders.aid = 
			( 
				Select aid 
					from agents 
					where city = 'Tokyo'
			)
	);

--6 
Select *
From (Select o.*, o.qty*p.priceusd*(1-(discount/100)) as truedollars
      from orders o
      inner join products p on o.pid = p.pid
      inner join customers c on o.cid = c.cid) as tmptable
Where dollars != truedollars

-- 7
-- When using outer joins, a left outer join specifies that you want all the rows
-- from the left table and any matching rows from the right table. a right outer
-- join specifies the opposite. For instance, the following query: 


select *
from orders
right outer join customers
on orders.cid=customers.cid

--contains c005 while

select *
from orders
LEFT outer join customers
on orders.cid=customers.cid

--does not
