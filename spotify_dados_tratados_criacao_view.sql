--- Realizado para a criação da view:

CREATE OR REPLACE VIEW projeto2-hipoteses-459613.spotify_2023.view_1track_in_spotify_limpa AS

WITH pares_contados AS (
SELECT
track_name,
artist_name,
COUNT(*) AS qtd
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
GROUP BY track_name, artist_name
),

pares_unicos AS (
SELECT
track_name,
artist_name
FROM pares_contados
WHERE qtd = 1
),

dados_filtrados AS (
SELECT t.*
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify` t
JOIN pares_unicos u
ON t.track_name = u.track_name
AND t.artist_name = u.artist_name
),

todos_ids AS (
SELECT *, CAST(track_id AS STRING) AS track_id_str
FROM dados_filtrados
),

contagem AS (
SELECT COUNT(*) AS total FROM todos_ids
),

possiveis_ids AS (
SELECT
LPAD(CAST(1000000 + OFFSET AS STRING), 7, '0') AS novo_track_id
FROM contagem,
UNNEST(GENERATE_ARRAY(0, total * 2)) AS OFFSET
),

primeiro_id_disponivel AS (
SELECT novo_track_id
FROM possiveis_ids
WHERE novo_track_id NOT IN (SELECT track_id_str FROM todos_ids)
LIMIT 1
),

dados_corrigidos AS (
SELECT
CASE 
WHEN track_id_str = '0:00' OR track_id_str IS NULL OR TRIM(track_id_str) = '' THEN (SELECT novo_track_id FROM primeiro_id_disponivel)
ELSE track_id_str
END AS track_id_corrigido,
    
REGEXP_REPLACE(
REGEXP_REPLACE(
LOWER(
IF(track_name IS NULL OR TRIM(track_name) = '', 'Track Name Não Informada', track_name)
),
r'[^a-z0-9\s]', ''
),
r'\s+', ' '
) AS track_name_corrigido,

REGEXP_REPLACE(
REGEXP_REPLACE(
LOWER(
IF(artist_name IS NULL OR TRIM(artist_name) = '', 'Artist Não Informado', artist_name)
),
r'[^a-z0-9\s]', ''
),
r'\s+', ' '
) AS artist_name_cleaned,
    
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
SAFE_CAST(streams AS INT64) AS streams_corrigidos,
DATE(CAST(released_year AS INT64), CAST(released_month AS INT64), CAST(released_day AS INT64)) AS release_date
FROM todos_ids
WHERE
released_year > 1930
AND (track_id_str IS NOT NULL AND TRIM(track_id_str) <> '')
AND SAFE_CAST(streams AS INT64) IS NOT NULL
)

SELECT
track_id_corrigido,
track_name_corrigido,
artist_name_cleaned,
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
streams_corrigidos,
release_date
FROM dados_corrigidos
;
