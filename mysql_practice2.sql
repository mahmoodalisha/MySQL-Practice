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

-- Step 3: Insert data into customers
INSERT INTO customers (id, name) VALUES 
(1, 'Alice Smith'),
(2, 'Bob Jones'),
(3, 'Charlie Brown'),
(4, 'Diana Prince'),
(5, 'Ethan Hunt'),
(6, 'Fiona Glenanne');

-- Step 4: Insert orders with different counts after 2024-01-01
INSERT INTO orders (id, customer_id, order_date) VALUES 
(101, 1, '2024-02-01'),
(102, 1, '2024-03-15'), 
(103, 1, '2024-04-10'),
(104, 1, '2024-05-20'), 
(105, 1, '2024-06-01'), 
(106, 1, '2024-07-04'),
(107, 2, '2024-02-10'), 
(108, 2, '2024-03-01'), 
(109, 2, '2024-03-25'),
(110, 2, '2024-04-12'), 
(111, 2, '2024-05-05'), 
(112, 2, '2024-06-18'),
(113, 2, '2024-07-22'),
(114, 3, '2024-01-10'), 
(115, 3, '2024-02-15'), 
(116, 3, '2024-03-20'),
(117, 3, '2024-04-05'), 
(118, 3, '2024-05-11'), 
(119, 3, '2024-06-19'),
(120, 3, '2024-07-30'),
(121, 3, '2024-08-14'),
(122, 4, '2024-01-05'),
(123, 4, '2024-02-02'),
(124, 4, '2024-03-03'),
(125, 4, '2024-04-04'),
(126, 4, '2024-05-05'),
(127, 4, '2024-06-06'),
(128, 4, '2024-07-07'),
(129, 4, '2024-08-08'),
(130, 4, '2024-09-09'),
(131, 5, '2024-02-20'),
(132, 5, '2024-03-21'),
(133, 5, '2024-04-22'),
(134, 5, '2024-05-23'),
(135, 5, '2024-06-24'),
(136, 5, '2024-07-25'),
(137, 6, '2024-01-15'), 
(138, 6, '2024-02-18');

-- Step 5: Run the query
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
