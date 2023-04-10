-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film_id, count(inventory_id) from inventory
WHERE film_id IN (
SELECT film_id from film
WHERE title = 'Hunchback Impossible'
)
GROUP BY film_id;

-- 2. List all films whose length is longer than the average of all the films.
SELECT * from film
WHERE length > (
SELECT avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name from actor
WHERE actor_id in (
SELECT actor_id from film_actor
WHERE film_id in (
SELECT film_id from film
WHERE title = 'Alone Trip'
));

-- 4. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT * from film 
WHERE film_id IN (
SELECT film_id from film_category
WHERE category_id IN(
SELECT category_id from category
WHERE name = 'Family'
))
ORDER BY film_id;

-- 5. Get name and email from customers from Canada using subqueries.
SELECT first_name, last_name, email from customer
WHERE address_id IN (
SELECT address_id from address
WHERE city_id in(
SELECT city_id from city 
WHERE country_id IN(
SELECT country_id from country
WHERE country = 'Canada'
)));

-- 6. Which are films starred by the most prolific actor? 

SELECT first_name, last_name FROM actor
WHERE actor_id IN(
SELECT actor_id FROM(
SELECT actor_id, count(film_id) from film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1) as sub1
);

SELECT * from film
WHERE film_id in(
SELECT film_id from film_actor
WHERE actor_id in (
SELECT actor_ID from actor
WHERE first_name = 'GINA' AND last_name = 'DEGENERES'
));

-- 7. Films rented by most profitable customer. 
SELECT * from film
WHERE film_id IN(
SELECT film_id from inventory
WHERE inventory_id IN(
SELECT inventory_id from rental 
WHERE customer_id IN(
SELECT customer_id FROM(
SELECT customer_id, sum(amount) as 'Total payment' from payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1) as sub1
)));

-- 8. Customers who spent more than the average payments. 
SELECT avg(total_spend) as average_payment FROM (
SELECT sum(amount) as total_spend from payment
GROUP BY customer_id) as sub1;

SELECT * from customer 
WHERE customer_id IN(
SELECT customer_id from(
SELECT customer_id, sum(amount) as total_spend from payment
GROUP BY customer_id
HAVING sum(amount) > 112.53) as sub1
);
