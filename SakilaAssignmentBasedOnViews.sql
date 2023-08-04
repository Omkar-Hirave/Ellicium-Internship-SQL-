-- 16. Find the names (first and last) of all the actors and costumers whose first name is the
-- same as the first name of the actor with ID 8. Do not return the actor with ID 8 him.
-- Note that you cannot use the name of the actor with ID 8 as a constant (only the ID).
-- There is more than one way to solve this question, but you need to provide only one
-- solution.
USE sakila
SELECT actor_id , first_name , last_name
FROM actor 
WHERE  actor_id = 8
UNION 
SELECT customer_id , first_name , last_name
FROM Customer
 
     
-- Q. List the top five genres in gross revenue in descending order.
--  In your new role as an executive, you would like to have an easy way of 
--  viewing the Top five genres by gross revenue. Use the solution from the problem above 
--  to create a view. If you haven’t solved the above question you can substitute another 
--  query to create a view.
 
USE sakila

-- Approach 1 - Using Partition
SELECT * FROM film
CREATE VIEW v1 AS (
WITH cte1 AS(
SELECT  
 c.name AS name,
 SUM(p.amount)  OVER(PARTITION BY c.name) AS 'sum_across_categories'
FROM Payment p INNER JOIN Rental r ON p.rental_id = r.rental_id
			   INNER JOIN Inventory i ON i.inventory_id = r.rental_id
               INNER JOIN Film f ON f.film_id = i.film_id
			   INNER JOIN film_category fc ON fc.film_id = f.film_id
               INNER JOIN category c ON fc.category_id = c.category_id
), cte2 AS(
SELECT DISTINCT name , sum_across_categories ,
 DENSE_RANK() OVER(ORDER BY sum_across_categories DESC) AS 'rnk' 
FROM cte1 )
SELECT name  , sum_across_categories
FROM cte2 
WHERE rnk <=5 )


-- Approach 2
CREATE VIEW v2 AS (
SELECT  DISTINCT
 c.name AS name ,
  SUM(p.amount)  AS 'sum_across_categories'
FROM Payment p INNER JOIN Rental r ON p.rental_id = r.rental_id
			   INNER JOIN Inventory i ON i.inventory_id = r.rental_id
               INNER JOIN Film f ON f.film_id = i.film_id
			   INNER JOIN film_category fc ON fc.film_id = f.film_id
               INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5)

