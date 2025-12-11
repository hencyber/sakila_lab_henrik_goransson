-- Uppgift 1e: Top 10 skådespelare efter antal filmer

-- Lärande mål:
-- - INNER JOIN för att kombinera tabeller
-- - GROUP BY för att gruppera data
-- - COUNT() för att räkna antal
-- - Jobba med många-till-många-relationer

-- Hitta skådespelare som är med i flest filmer
SELECT 
    a.first_name,                    -- Skådespelarens förnamn
    a.last_name,                     -- Skådespelarens efternamn
    COUNT(fa.film_id) AS film_count  -- Räkna antal filmer
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC  -- Sortera från flest till minst filmer
LIMIT 10;  -- Visa bara top 10

-- Förklaring:
-- INNER JOIN kopplar ihop actor och film_actor-tabellerna
-- ON anger vilken kolumn som kopplar tabellerna (actor_id)
-- GROUP BY grupperar alla filmer per skådespelare
-- COUNT(fa.film_id) räknar antal filmer för varje skådespelare
-- AS ger tabeller och kolumner alias (kortare namn)

-- Förväntat resultat: 10 skådespelare, toppen har 42 filmer (Gina Degeneres)
