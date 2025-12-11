-- Uppgift 1a: Hitta filmer längre än 3 timmar

-- Lärande mål:
-- - WHERE-klausulen för filtrering  
-- - Jämförelseoperatorer (>, <, =)
-- - Sortera resultat med ORDER BY

-- Hämta titel och längd för filmer över 180 minuter
SELECT 
    title,          -- Filmens titel
    length          -- Längd i minuter
FROM film           
WHERE length > 180  -- Endast filmer över 180 min (3 timmar)
ORDER BY length DESC;  -- Sortera från längst till kortast

-- Tips: 
-- WHERE används för filtrering
-- DESC = descending (fallande ordning)

-- Förväntat resultat: Ca 39 filmer
