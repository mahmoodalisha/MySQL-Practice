-- The query is intended to find the top 10 customers who have placed more than 5 orders after January 1, 2024, and list them in descending order based on their total order count

-- There are two primary issues with this query—one structural/schema-related and one related to SQL execution rules
SELECT
    id,
    name,
    COUNT (*) AS total_orders
FROM
    customers
WHERE
    order_date > '2024-01-01'
GROUP BY
    id, name
HAVING
    total_orders > 5
ORDER BY
    total_orders DESC
LIMIT 10;

/*
Missing Table Join (Schema Design Flaw):
The query attempts to select order_date and count orders directly from a single customers table.
In a properly normalized database schema, customer profile data lives in a customers table, while individual transactions live in a separate orders table. Querying order_date directly from customers implies either a poorly structured single-table design or a missing JOIN statement.

Using a SELECT Alias in the HAVING Clause:
In standard SQL, the logical order of query execution evaluates the HAVING clause before the SELECT clause. 
This means the column alias total_orders technically doesn't exist yet when HAVING runs.
While MySQL is lenient and allows aliases in HAVING and ORDER BY as an extension, it violates standard SQL compliance and will throw errors in strict SQL modes or other database systems (like PostgreSQL or SQL Server).
Best practice dictates using the aggregate function directly (COUNT(o.id) > 5) inside the HAVING clause.
 */

-- The fixed code (Best Practice with Proper Joins)
SELECT 
    cust.id,
    cust.name,
    COUNT(ord.id) AS total_orders
FROM
    customers cust
JOIN
    orders ord ON cust.id = ord.customer_id
WHERE
    ord.order_date > '2024-01-01'
GROUP BY
    cust.id, cust.name
HAVING
    COUNT(ord.id) > 5
ORDER BY
    total_orders DESC
LIMIT 10;

