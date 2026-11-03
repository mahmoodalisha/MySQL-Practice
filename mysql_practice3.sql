/* The query is intended to find all users and count how many completed orders each user has placed
pending (placed, but waiting for payment or processing)
shipped (on its way to the customer)
cancelled (abandoned or refunded)
completed (fully delivered, paid for, and closed out successfully)
listing them in descending order from the highest number of completed orders to the lowest */

-- buggy query
/*
At first glance, this query looks completely normal and clean. It uses custom table aliases (u for users and o for orders)
performs an INNER JOIN, filters by status = 'completed' groups by user ID and sorts by the count.
However it contains a classic silently incorrect business logic bug related to how INNER JOIN behaves with WHERE clauses.

What is the Bug?
The Silent Exclusion of Inactive Users: Because this is an INNER JOIN combined with a WHERE o.status = 'completed' clause, users who have never placed any orders (or have zero completed orders) completely vanish from the results.
The Grouping Error: On line 5, it groups only by u.id. In standard SQL, if you select u.name
you are supposed to group by u.name as well (or include it in the GROUP BY clause)
though MySQL's default settings sometimes tolerate missing non-aggregated columns.
*/

SELECT u.id, u.name, COUNT(o.id) as order_count
FROM users
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.id
ORDER BY order_count DESC;

-- ==================================================

--fixed query
SELECT 
    u.id, 
    u.name, 
    COUNT(o.id) AS order_count
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.id, u.name
ORDER BY order_count DESC;