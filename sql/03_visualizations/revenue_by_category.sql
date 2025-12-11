-- Uppgift 2b: Total intäkt per filmkategori

-- Lärande mål:
-- - Komplex JOIN-kedja (6 tabeller)
-- - Förstå normaliserade databaser
-- - SUM() för aggregering
-- - GROUP BY för gruppering

-- Beräkna total revenue för varje filmkategori
SELECT 
    c.name AS category_name,           -- Kategorinamn (Action, Drama, etc)
    SUM(p.amount) AS total_revenue,    -- Total intäkt
    ROUND(SUM(p.amount), 2) AS revenue_rounded  -- Avrundat
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC;

-- Förklaring av JOIN-kedjan:
-- 1. category -> film_category (vilka filmer tillhör kategorin?)
-- 2. film_category -> film (filmens information)
-- 3. film -> inventory (vilka DVD-kopior finns?)
-- 4. inventory -> rental (vilka uthyrningar gjordes?)
-- 5. rental -> payment (hur mycket betalades?)
--
-- Varför så många JOINs?
-- Databasen är normaliserad = data är uppdelad i många tabeller
-- för att undvika upprepning. Vi måste koppla ihop dem för att
-- få full information.

-- Förväntat resultat: 16 kategorier, Sports/Sci-Fi/Animation är högst
