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

--The fixed code (Best Practice with Proper Joins)
--There are two Tables
--customers: Holds information about the people (like their ID and name)
--orders: Holds information about the transactions (like the order ID, which customer placed it, and the order date).


-- Step 1: Create the customers table
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Step 2: Create the orders table
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Step 3: Insert sample data into customers
INSERT INTO customers (id, name) VALUES 
(1, 'Alice Smith'),
(2, 'Bob Jones'),
(3, 'Charlie Brown');

-- Step 4: Insert sample data into orders (making sure Alice has more than 5 orders after 2024-01-01)
INSERT INTO orders (id, customer_id, order_date) VALUES 
(101, 1, '2024-02-01'),
(102, 1, '2024-03-15'),
(103, 1, '2024-04-10'),
(104, 1, '2024-05-20'),
(105, 1, '2024-06-01'),
(106, 1, '2024-07-04'), -- Alice's 6th order after Jan 1, 2024
(107, 2, '2024-02-10'),
(108, 2, '2024-03-01'), -- Bob only has 2 orders
(109, 3, '2023-12-15'); -- Charlie's order is before 2024 (should be filtered out)

-- Step 5: Run your query!
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

-- What cust is: It is simply a custom nickname (alias) for the customers table
-- Just like cust is a nickname for customers, ord is a custom nickname for the orders table

SELECT * FROM customers

SELECT * FROM orders