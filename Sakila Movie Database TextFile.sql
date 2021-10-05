--Query 1 - query used for first insight--
SELECT 
  f.title AS film_title, 
  c.name AS category_name, 
  COUNT(r.rental_id) AS rental_count 
FROM 
  category c 
  JOIN film_category fc ON c.category_id = fc.category_id 
  JOIN film f ON f.film_id = fc.film_id 
  JOIN inventory i ON f.film_id = i.film_id 
  JOIN rental r ON i.inventory_id = r.inventory_id 
WHERE 
  c.name IN (
    'Animation', 'Children', 'Classics', 
    'Comedy', 'Family', 'Music'
  ) 
GROUP BY 
  f.title, 
  c.name 
ORDER BY 
  c.name, 
  f.title;




--Query 2 - query used for second insight--
SELECT 
  DATE_PART('month', r.rental_date) AS month, 
  DATE_PART('year', r.rental_date) AS year, 
  s.store_id AS id, 
  COUNT(s.store_id) 
FROM 
  rental r 
  JOIN staff s ON r.staff_id = s.staff_id 
  JOIN store st ON s.store_id = st.store_id 
GROUP BY 
  DATE_PART('month', r.rental_date), 
  DATE_PART('year', r.rental_date), 
  s.store_id  
ORDER BY 
  COUNT(s.store_id) DESC;




--Query 3 - query used for third insight--
SELECT 
  t1.film_title AS film_title, 
  t1.category_name AS category_name, 
  t1.duration AS duration, 
  t1.standard_quartile AS standard_quartile 
FROM 
  (
    SELECT 
      f.title AS film_title, 
      c.name AS category_name, 
      f.rental_duration AS duration, 
      NTILE(4) OVER (
        ORDER BY 
          f.rental_duration
      ) AS standard_quartile 
    FROM 
      category c 
      JOIN film_category fc ON c.category_id = fc.category_id 
      JOIN film f ON f.film_id = fc.film_id 
    WHERE 
      c.name IN (
        'Animation', 'Children', 'Classics', 
        'Comedy', 'Family', 'Music'
      )
  ) t1;




--Query 4 - query used for fourth insight--
SELECT 
  t1.name AS category_name, 
  t1.standard_quartile AS quartile, 
  COUNT(*) 
FROM 
  (
    SELECT 
      c.name AS name, 
      NTILE(4) OVER (
        ORDER BY 
          f.rental_duration
      ) AS standard_quartile 
    FROM 
      category c 
      JOIN film_category fc ON c.category_id = fc.category_id 
      JOIN film f ON f.film_id = fc.film_id 
    WHERE 
      c.name IN (
        'Animation', 'Children', 'Classics', 
        'Comedy', 'Family', 'Music'
      )
  ) t1 
GROUP BY 
  t1.name, 
  t1.standard_quartile 
ORDER BY 
  t1.name, 
  t1.standard_quartile;




