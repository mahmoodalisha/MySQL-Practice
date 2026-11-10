/* 
The query is designed to fetch the latest 10 active products from the products table.
It filters out products that have been deleted (deleted_at = NULL intended),
filters out products that are discontinued (status != 'discontinued'),
sorts them from newest to oldest based on when they were added (ORDER BY added_at DESC),
and grabs only the top 10 results (LIMIT 10)

deleted_at is a column name in the table
If deleted_at is NULL: It means the product has NOT been deleted (it is still active and visible in the store).
If deleted_at has a date/time (e.g., '2026-11-08 14:30:00'): It means the product was deleted at that exact moment
*/
-- The buggy code
SELECT id, title, added_at
FROM products
WHERE deleted_at = NULL
AND status != 'discontinued'
ORDER BY added_at DESC
LIMIT 10;
/* 
The bug is a classic SQL trap involving how databases handle NULL values:

Using = NULL instead of IS NULL:
On line 4, the query writes WHERE deleted_at = NULL. In SQL, NULL represents the absence of a value (nothingness).
Because NULL is not a regular value, you cannot use standard comparison operators like =, !=, or <> with it.
*/

-- the fixed code
SELECT 
    id, 
    title, 
    added_at
FROM 
    products
WHERE 
    deleted_at IS NULL        -- Must use IS NULL instead of = NULL
    AND status != 'discontinued'
ORDER BY 
    added_at DESC
LIMIT 10;