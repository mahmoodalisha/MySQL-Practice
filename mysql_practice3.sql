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
/* if the goal is a complete user list (ranking everyone, including zeroes)
To fix this, we need to change it to a LEFT JOIN so all users are preserved.
However if we put WHERE status = 'completed', it turns our LEFT JOIN right back into an INNER JOIN because it filters out the NULL rows.
So the correct approach is to move the status check inside a conditional aggregate—like a COUNT(CASE WHEN o.status = 'completed' THEN o.id END)
and make sure our GROUP BY includes both u.id and u.name for strict SQL compliance.
 */

/*If you want to include ALL users (even those with 0 completed orders)
To make sure users with zero completed orders still show up with a count of 0 instead of disappearing entirely, use a LEFT JOIN and move the filter condition into the ON clause (or count conditionally) */

SQL
SELECT 
    u.id, 
    u.name, 
    COUNT(CASE WHEN o.status = 'completed' THEN o.id END) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY order_count DESC;