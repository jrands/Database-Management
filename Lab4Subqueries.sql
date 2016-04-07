
--1. 
SELECT city
FROM agents 
WHERE aid in (
	SELECT aid
	FROM orders
	WHERE cid = 'c002');

--2.
SELECT pid
FROM orders 
WHERE aid in(
	SELECT aid
	FROM orders
	WHERE cid in(
		SELECT cid
		FROM customers
		WHERE city = 'Dallas'))
ORDER BY pid DESC;

--3.
SELECT cid, name
FROM customers
WHERE cid in(
	SELECT cid
	FROM orders
	WHERE aid != 'a01');

--4. 
SELECT cid
FROM customers
WHERE cid in(
	SELECT cid
	FROM orders
	WHERE pid = 'p01' 
	OR pid = 'p07');

--5.
SELECT pid
FROM products
WHERE pid in(
	SELECT pid 
	FROM orders
	WHERE aid != 'a07')
ORDER BY pid DESC;

--6.
SELECT name, discount, city
FROM customers
WHERE cid in(
	SELECT cid 
	FROM orders
	WHERE aid in(
		SELECT aid 
		FROM agents
		WHERE city = 'London' 
		OR city = 'New York'));

--7.
SELECT *
FROM customers
WHERE discount in(
	SELECT discount
	FROM customers
	WHERE city = 'Dallas' 
	OR city = 'London');

--8.
/*
* A check contraint in SQL is used to restrict the type of data entered into a 
* given field in a table. Check constrains are helpful for ensuring the user does
* not enter invalid data. For instance, if you do not want the user to enter a
* negative number in a num field, then you should put a check contraint to prevent
* that. An example would be inputting stock of an item; you should not be allowed
* to have negative stock of something. A bad example of this implementation would
* be to disallow negative currency values. While typically you would not want to
* have a negative monetary value, it may be neccessary to allow such data to be
* added to account for instances when there is a negative net profit. 
*/
