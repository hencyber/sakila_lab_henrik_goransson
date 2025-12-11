-- Uppgift 1b: Filmer med "love" i titeln

-- Lärande mål:
-- - LIKE-operatorn för textmatchning
-- - Wildcards (%) i SQL
-- - LOWER() för case-insensitive sökning

-- Hämta information om filmer med "love" i titeln
SELECT 
    title,          -- Filmens namn
    rating,         -- Åldersgräns (G, PG, PG-13, R, NC-17)
    length,         -- Längd i minuter
    description     -- Beskrivning
FROM film
WHERE LOWER(title) LIKE '%love%'  -- Sök efter "love" (case-insensitive)
ORDER BY title;  -- Sortera alfabetiskt

-- Förklaring:
-- LOWER(title) gör om titeln till små bokstäver
-- '%love%' = vad som helst + "love" + vad som helst
-- % är en wildcard som matchar vilket antal tecken som helst

-- Exempel: matchar "GRAFFITI LOVE", "Love Story", "LOVELY JINGLE"

-- Förväntat resultat: Ca 10 filmer
