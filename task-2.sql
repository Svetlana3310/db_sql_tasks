-- Частина 1: Запити на вибірку даних (SELECT)

-- 1) Отримання списку фільмів та їх категорій: Напишіть SQL-запит, 
-- який виведе назву фільму, тривалість і категорію для кожного фільму.

SELECT film.title, film.length, category.name AS category_name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id 
LIMIT 1000;


-- 2) Фільми, орендовані певним клієнтом: Напишіть запит, який виведе 
-- список фільмів, орендованих одним із клієнтів, разом з датами оренди.
SELECT film.title, 
       rental.last_update, 
       CONCAT(customer.first_name, ' ', customer.last_name) AS customer
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE rental.customer_id = 1
LIMIT 1000;


-- 3) Популярність фільмів: Напишіть запит, який виведе топ-5 найпопулярніших 
-- фільмів на основі кількості оренд.
SELECT film.title, COUNT(inventory.film_id) as rents
FROM inventory 
JOIN film ON inventory.film_id = film.film_id 
GROUP BY inventory.film_id, film.title 
ORDER BY inventory.film_id DESC 
LIMIT 5;



-- Частина 2: Маніпуляції з даними (INSERT, UPDATE, DELETE) 

-- 1)Додавання нового клієнта: Додайте новий запис у таблицю клієнтів. Ім'я клієнта
-- "Alice Cooper", адреса — "123 Main St", місто — "San Francisco".

--CREATE TABLE public.address (
    --address_id integer DEFAULT nextval('public.address_address_id_seq'::regclass) NOT NULL,
    --address character varying(50) NOT NULL,
    --address2 character varying(50),
    --disтtrict character varying(20) NOT NULL,
    --city_id smallint NOT NULL,
    --postal_code character varying(10),
    --phone character varying(20) NOT NULL,
    --last_update timestamp without time zone DEFAULT now() NOT NULL
--); 
-- Через брак даних та обов'язковість деяких полів disтtrict, я додала рандомні значення.
DO $$
DECLARE
    v_country_id INTEGER;
    v_city_id INTEGER;
    v_address_id INTEGER;
BEGIN
    -- Додавання країни, якщо її немає
    IF NOT EXISTS (SELECT 1 FROM public.country WHERE country = 'United States') THEN
        INSERT INTO public.country (country, last_update)
        VALUES ('United States', now())
        RETURNING country_id INTO v_country_id;
    ELSE
        SELECT country_id INTO v_country_id FROM public.country WHERE country = 'United States';
    END IF;

    -- Додавання міста, якщо його немає
    IF NOT EXISTS (SELECT 1 FROM public.city WHERE city = 'San Francisco' AND country_id = v_country_id) THEN
        INSERT INTO public.city (city, country_id, last_update)
        VALUES ('San Francisco', v_country_id, now())
        RETURNING city_id INTO v_city_id;
    ELSE
        SELECT city_id INTO v_city_id FROM public.city WHERE city = 'San Francisco' AND country_id = v_country_id;
    END IF;

    -- Додавання адреси, якщо її немає
    IF NOT EXISTS (SELECT 1 FROM public.address WHERE address = '123 Main St' AND district = 'Downtown' AND city_id = v_city_id) THEN
        INSERT INTO public.address (address, district, city_id, phone, last_update)
        VALUES ('123 Main St', 'Downtown', v_city_id, '123-456-7890', now())
        RETURNING address_id INTO v_address_id;
    ELSE
        SELECT address_id INTO v_address_id FROM public.address 
        WHERE address = '123 Main St' AND district = 'Downtown' AND city_id = v_city_id;
    END IF;

    -- Додавання нового клієнта, якщо його немає
    IF NOT EXISTS (SELECT 1 FROM public.customer WHERE store_id = 1 AND first_name = 'Alice' AND last_name = 'Cooper' AND address_id = v_address_id) THEN
        INSERT INTO public.customer (store_id, first_name, last_name, address_id, activebool, create_date, last_update)
        VALUES (1, 'Alice', 'Cooper', v_address_id, TRUE, CURRENT_DATE, now());
    END IF;

END $$;





-- 2) Оновлення адреси клієнта: Оновіть адресу клієнта "Alice Cooper" на "456 Elm St".
UPDATE address
SET address = '456 Elm St'
WHERE address = '123 Main St'; 



-- 3) Видалення клієнта: Видаліть запис про клієнта "Alice Cooper" з бази даних.
-- Через небезпеку утворення безладу в базі даних пряме вилучення запису 
-- DELETE FROM customer WHERE first_name='Alice' AND last_name='Cooper';
-- є небезпечним, тому я оновлюю запис та встановлюю значення поля activebool. 
-- Структура таблиці автоматично визначить значення поля active в значення 0, 
-- що свідчить про не активний запис.
 
UPDATE customer
SET activebool = FALSE
WHERE first_name='Alice' AND last_name='Cooper';