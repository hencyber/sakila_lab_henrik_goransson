-- Uppgift 1c: Beskrivande statistik för filmlängd

-- Lärande mål:
-- - Aggregeringsfunktioner (MIN, MAX, AVG, MEDIAN)
-- - AS-nyckelordet för att ge kolumner nya namn (alias)

-- Beräkna statistik om filmlängder
SELECT 
    MIN(length) AS shortest_length,     -- Kortaste filmen
    AVG(length) AS average_length,      -- Genomsnittlig längd
    MEDIAN(length) AS median_length,    -- Medianlängd  
    MAX(length) AS longest_length       -- Längsta filmen
FROM film;

-- Förklaring:
-- MIN() hittar minsta värdet
-- MAX() hittar största värdet
-- AVG() beräknar medelvärde (average)
-- MEDIAN() hittar mittenvärdet när data är sorterad
-- AS ger kolumnen ett nytt namn (alias)

-- Förväntat resultat: En rad med fyra siffror
-- Kortaste: ca 46 min, Genomsnitt: ca 115 min, Median: 114 min, Längsta: 185 min
