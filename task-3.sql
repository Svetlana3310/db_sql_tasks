-- 1)Загальна кількість фільмів у кожній категорії: 
-- Напишіть SQL-запит, який виведе назву категорії 
-- та кількість фільмів у кожній категорії.
SELECT category.name as category_name, count(film.film_id) as film_name FROM category 
JOIN film_category ON film_category.category_id=category.category_id
JOIN film ON film.film_id=film_category.film_id 
GROUP BY category.name;



-- 2)Середня тривалість фільмів у кожній категорії: 
-- Напишіть запит, який виведе назву категорії та середню 
-- тривалість фільмів у цій категорії.
SELECT category.name as category_name, ROUND(avg(film.length)) as averange_length FROM category 
JOIN film_category ON film_category.category_id=category.category_id
JOIN film ON film.film_id=film_category.film_id 
GROUP BY category.name;



-- 3)Мінімальна та максимальна тривалість фільмів: 
-- Напишіть запит, який виведе мінімальну та максимальну 
-- тривалість фільмів у базі даних.
SELECT MIN(film.length) AS min_length, MAX(film.length) AS max_length FROM film;

-- Мінімальна та максимальна тривалість фільмів у кожній категорії. 
SELECT category.name as category_name, MIN(film.length) AS min_length, MAX(film.length) AS max_length FROM category 
JOIN film_category ON film_category.category_id=category.category_id
JOIN film ON film.film_id=film_category.film_id 
GROUP BY category.name;


-- 4)Загальна кількість клієнтів: Напишіть запит, 
-- який поверне загальну кількість клієнтів у базі даних.
SELECT count(*) as clients FROM customer;


-- 5)Сума платежів по кожному клієнту: Напишіть запит, 
--який виведе ім'я клієнта та загальну суму платежів, яку він здійснив.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
CAST(SUM(payment.amount) AS DECIMAL(10, 2)) AS payment_sum 
FROM payment 
JOIN customer ON customer.customer_id = payment.customer_id 
GROUP BY customer.first_name, customer.last_name;


-- 6)П'ять клієнтів з найбільшою сумою платежів: Напишіть запит, 
--який виведе п'ять клієнтів, які здійснили найбільшу кількість платежів, у порядку спадання.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
CAST(SUM(payment.amount) AS DECIMAL(10, 2)) AS payment_sum 
FROM payment 
JOIN customer ON customer.customer_id = payment.customer_id 
GROUP BY customer.first_name, customer.last_name 
ORDER BY payment_sum DESC LIMIT 5;


-- 7)Загальна кількість орендованих фільмів кожним клієнтом: 
--Напишіть запит, який поверне ім'я клієнта та кількість фільмів, які він орендував.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
count(payment.payment_id) as rented_films
FROM customer 
JOIN payment ON customer.customer_id = payment.customer_id 
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer_name 
ORDER BY customer.customer_id;


-- 8)Середній вік фільмів у базі даних: Напишіть запит, 
--який виведе середній вік фільмів (різниця між поточною датою та роком випуску фільму).
SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(CAST(release_year AS TEXT), 'YYYY'))))::INTEGER 
AS average_age 
FROM film;


-- 9)Кількість фільмів, орендованих за певний період: 
--Напишіть запит, який виведе кількість фільмів, орендованих у період між двома вказаними датами.
SELECT COUNT(rental_id) AS rented_films_count
FROM rental
WHERE rental_period && tsrange('2005-05-25'::timestamp, '2005-08-18'::timestamp);


-- 10)Сума платежів по кожному місяцю: Напишіть запит, 
--який виведе загальну суму платежів, здійснених кожного місяця.
SELECT TO_CHAR(payment_date, 'Month YYYY') AS month_year, SUM(amount) AS total_payments
FROM payment
GROUP BY month_year
ORDER BY month_year;


-- 11)Максимальна сума платежу, здійснена клієнтом: 
--Напишіть запит, який виведе максимальну суму окремого платежу для кожного клієнта.
SELECT customer_id, MAX(amount) AS max_payment 
FROM payment 
GROUP BY customer_id;


--12)Середня сума платежів для кожного клієнта: 
--Напишіть запит, який виведе ім'я клієнта та середню суму його платежів.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
ROUND(AVG(amount), 2) AS avg_payment
FROM payment 
JOIN customer ON customer.customer_id = payment.customer_id 
GROUP BY customer.customer_id, customer.first_name, customer.last_name 
ORDER BY customer.customer_id;


--13)Кількість фільмів у кожному рейтингу (rating): Напишіть запит, 
--який поверне кількість фільмів для кожного з можливих рейтингів (G, PG, PG-13, R, NC-17).
SELECT count(film_id) as films, rating FROM film 
GROUP BY rating;


-- 14)Середня сума платежів по кожному магазину (store): 
--Напишіть запит, який виведе середню суму платежів, здійснених у кожному магазині.
SELECT CAST(avg(payment.amount) as DECIMAL(10, 2)) as avg_payment, store.store_id FROM payment  
JOIN rental ON rental.rental_id=payment.rental_id 
JOIN inventory ON inventory.inventory_id=rental.inventory_id
JOIN store on store.store_id=inventory.store_id 
GROUP BY store.store_id;

