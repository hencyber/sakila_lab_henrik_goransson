-- Uppgift 1d: Top 10 dyraste filmerna att hyra per dag

-- Lärande mål:
-- - Aritmetiska beräkningar i SQL
-- - ORDER BY på beräknade kolumner
-- - LIMIT för att begränsa antal rader

-- Beräkna kostnad per dag och visa de 10 dyraste
SELECT 
    title,                                     -- Filmens titel
    rental_rate,                               -- Hyrespris totalt
    rental_duration,                           -- Antal dagar man får hyra
    rental_rate / rental_duration AS cost_per_day,  -- Beräkning: pris per dag
    rating                                     -- Åldersgräns
FROM film
ORDER BY cost_per_day DESC  -- Sortera från dyrast till billigast per dag
LIMIT 10;  -- Visa bara de 10 första (dyraste)

-- Förklaring:
-- rental_rate / rental_duration beräknar pris per dag
-- ORDER BY kan användas på beräknade kolumner
-- LIMIT 10 betyder "visa bara 10 rader"

-- Förväntat resultat: 10 filmer, alla med cost_per_day = 4.99
