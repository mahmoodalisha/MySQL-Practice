/*
The query is designed to analyze products created on or after January 1, 2026.
It groups them by category and filters for categories that meet two conditions:

1) They have more than 5 products with a price (COUNT(price) > 5).
2)Their average price (avg_price) is higher than a benchmark average price.
Finally, it sorts the results from the highest average price to the lowest (ORDER BY avg_price DESC).
*/

-- The buggy Query
SELECT
    category,
    COUNT (*) AS total_products,
    AVG(price) AS avg_price
FROM products
WHERE created_at >= '2026-01-01'
GROUP BY category
HAVING COUNT(price) > 5
AND avg_price > (
    SELECT AVG(price)
    FROM products
    WHERE category = category
)
ORDER BY avg_price DESC

/* 
There are two major bugs in this query:

Bug 1: The Subquery Bug (WHERE category = category)
Because both sides of the = sign point to the exact same column name,
MySQL evaluates it as TRUE for every single row.
Instead of calculating the average price for that specific category,
the subquery accidentally calculates the global average price of all products in the entire table.
To make it correlate with the outer query, it needs a table alias (e.g., p.category = category).

Bug 2: Using a SELECT Alias (avg_price) Inside the HAVING Clause
The outer query uses the column alias avg_price inside the HAVING clause (AND avg_price > (...)). In standard SQL, the HAVING clause is evaluated before the SELECT clause,
meaning the alias avg_price technically doesn't exist yet when HAVING runs.
While MySQL is lenient and sometimes allows this, it will throw errors in strict SQL modes or other database engines like PostgreSQL or SQL Server.
You should use the aggregate function AVG(price) directly instead.
*/

-- The fixed code
SELECT 
    p.category,
    COUNT(*) AS total_products,
    AVG(p.price) AS avg_price
FROM products p
WHERE p.created_at >= '2026-01-01'
GROUP BY p.category
HAVING COUNT(p.price) > 5
   AND AVG(p.price) > (
       SELECT AVG(sub.price)
       FROM products sub
       WHERE sub.category = p.category
   )
ORDER BY avg_price DESC;