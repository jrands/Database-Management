-- SQL statements for displaying example data into the CAP2 database
-- Connect to your Postgres server and set the active database to CAP2.  Then . . .

-- 1.
SELECT ordno, dollars 
FROM orders;

-- 2.
SELECT name, city 
FROM agents 
WHERE name = 'Smith';

-- 3.
SELECT pid, name, priceUSD 
FROM products
WHERE quantity > 208000;

-- 4.
SELECT name, city
FROM customers
WHERE city = 'Dallas';

-- 5.
SELECT name
FROM agents
WHERE city != 'New York' AND city != 'Tokyo';

-- 6.
SELECT *
FROM products
WHERE city != 'Dallas'
AND city != 'Duluth'
AND priceUSD >= 1;

-- 7. 
SELECT *
FROM orders
WHERE mon = 'jan' OR mon = 'feb';

-- 8.
SELECT *
FROM orders
WHERE mon = 'feb'
AND dollars < 500;

-- 9.
SELECT *
FROM customers
WHERE cid = 'c005';

