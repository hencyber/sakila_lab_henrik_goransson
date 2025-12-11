-- Uppgift 2a: Top 5 kunder efter total spenderad summa

-- Lärande mål:
-- - Multiple JOINs (koppla flera tabeller)
-- - SUM() för att summera värden
-- - String concatenation (sätta ihop strängar)
-- - ROUND() för att avrunda decimaler

-- Hitta de 5 kunder som spenderat mest pengar
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,  -- Sätt ihop för- och efternamn
    SUM(p.amount) AS total_spent,                        -- Summera alla betalningar
    ROUND(SUM(p.amount), 2) AS total_spent_rounded       -- Avrunda till 2 decimaler
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- Förklaring:
-- || operator sätter ihop strängar (concatenation)
-- Tre tabeller kopplas: customer -> rental -> payment
-- SUM(p.amount) summerar alla betalningar per kund
-- ROUND(värde, 2) avrundar till 2 decimaler
-- GROUP BY grupperar alla betalningar per kund

-- Förväntat resultat: 5 kunder, toppen har spenderat ca 200+ kr
