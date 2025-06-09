--- Para contar quantos registros estão nulos ou vazios em cada variável.

SELECT
COUNTIF(track_id IS NULL OR TRIM(track_id) = '') AS nulos_ou_vazios_track_id,
COUNTIF(track_name IS NULL OR TRIM(track_name) = '') AS nulos_ou_vazios_track_name,
COUNTIF(artist_name IS NULL OR TRIM(artist_name) = '') AS nulos_ou_vazios_artist_name,
COUNTIF(artist_count IS NULL OR TRIM(CAST(artist_count AS STRING)) = '') AS nulos_ou_vazios_artist_count,
COUNTIF(released_year IS NULL OR TRIM(CAST(released_year AS STRING)) = '') AS nulos_ou_vazios_released_year,
COUNTIF(released_month IS NULL OR TRIM(CAST(released_month AS STRING)) = '') AS nulos_ou_vazios_released_month,
COUNTIF(released_day IS NULL OR TRIM(CAST(released_day AS STRING)) = '') AS nulos_ou_vazios_released_day,
COUNTIF(in_spotify_playlists IS NULL OR TRIM(CAST(in_spotify_playlists AS STRING)) = '') AS nulos_ou_vazios_in_spotify_playlists,
COUNTIF(in_spotify_charts IS NULL OR TRIM(CAST(in_spotify_charts AS STRING)) = '') AS nulos_ou_vazios_in_spotify_charts,
COUNTIF(streams IS NULL OR TRIM(CAST(streams AS STRING)) = '') AS nulos_ou_vazios_streams,
COUNT(*) AS total_registros
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`;

--- Para criar uma nova coluna chamada track_name_null_corrigido que trata valores nulos ou vazios da coluna track_name, substituindo por um texto padrão "Track Name Não Informada", enquanto mantém todas as demais colunas da tabela original.

SELECT
IF(TRIM(track_name) IS NULL OR TRIM(track_name) = '', 'Track Name Não Informada', track_name) AS track_name_null_corrigido,
*
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`;

---Seleciona colunas específicas da tabela, agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.

SELECT 
track_id,
track_name,
artist_name,
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
streams,
COUNT(*) AS total_duplicadas
FROM 
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
GROUP BY 
track_id,
track_name,
artist_name,
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
streams
HAVING 
COUNT(*) > 1;

---Seleciona colunas específicas da tabela,no caso aqui ficou de fora a coluna que continha dados nulos,  agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.

SELECT 
track_id,
artist_name,
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
streams,
COUNT(*) AS total_duplicadas
FROM 
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
GROUP BY 
track_id,
artist_name,
artist_count,
released_year,
released_month,
released_day,
in_spotify_playlists,
in_spotify_charts,
streams
HAVING 
COUNT(*) > 1;

---A consulta seleciona o nome da música (track_name) e o nome do artista (artist_name). Agrupa os resultados por esses dois campos e filtra para que sejam retornados somente os pares de música e artista que aparecem mais de uma vez na tabela.
WITH duplicadas AS (
SELECT
track_name,
artist_name
FROM
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
GROUP BY
track_name,
artist_name
HAVING
COUNT(*) > 1
)

SELECT
t.track_id,
t.track_name,
t.artist_name,
t.artist_count,
t.released_year,
t.released_month,
t.released_day,
t.in_spotify_playlists,
t.in_spotify_charts,
t.streams
FROM
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify` t
JOIN
duplicadas d
ON
t.track_name = d.track_name AND
t.artist_name = d.artist_name;

--- Retorna todas as linhas da tabela 1track_in_spotify onde o nome da música "track_name" ou o nome do artista "artist_name" contém caracteres especiais.

SELECT
*
FROM
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
WHERE
REGEXP_CONTAINS(track_name, r'[^a-zA-Z0-9\s]') OR
REGEXP_CONTAINS(artist_name, r'[^a-zA-Z0-9\s]');

--- Converte todas as letras para minúsculas, remove caracteres especiais e símbolos, substitui qualquer sequência de espaço por um único espaço.

SELECT
*,
REGEXP_REPLACE(
REGEXP_REPLACE(
LOWER(track_name),                
r'[^a-z0-9\s]', ''),               
r'\s+', ' '                        
) AS track_name_cleaned,

REGEXP_REPLACE(
REGEXP_REPLACE(
LOWER(artist_name),
r'[^a-z0-9\s]', ''),
r'\s+', ' '
) AS artist_name_cleaned

FROM
`projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`;

--- Verificação de track_id fora do padrão esperado

SELECT track_id
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
WHERE REGEXP_CONTAINS(CAST(track_id AS STRING), r'[^a-zA-Z0-9]')  
OR NOT REGEXP_CONTAINS(CAST(track_id AS STRING), r'^\d{7}$');

--- Correção track_id fora do padrão

-- Coletar todos os track_ids e colunas da tabela
WITH todos_ids AS (
SELECT *, CAST(track_id AS STRING) AS track_id_str
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
),

-- Contar quantas linhas existem
contagem AS (
SELECT COUNT(*) AS total FROM todos_ids
),

-- Gerar possíveis novos track_ids com base na contagem
possiveis_ids AS (
SELECT
LPAD(CAST(1000000 + OFFSET AS STRING), 7, '0') AS novo_track_id
FROM contagem,
UNNEST(GENERATE_ARRAY(0, total * 2)) AS OFFSET
),

-- Encontrar o primeiro ID de 7 dígitos que ainda não existe
primeiro_id_disponivel AS (
SELECT novo_track_id
FROM possiveis_ids
WHERE novo_track_id NOT IN (SELECT track_id_str FROM todos_ids)
LIMIT 1
)

-- Todas as colunas + track_id corrigido
SELECT
*,  
CASE
WHEN track_id_str = '0:00' THEN (SELECT novo_track_id FROM primeiro_id_disponivel)
ELSE track_id_str
END AS track_id_corrigido
FROM todos_ids;

--- Formula para considerar apenas os dados que forem de anos de lançamento maiores que 1930:

SELECT *
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
WHERE released_year > 1930;

-- Identificando dados discrepantes

SELECT
MIN(in_spotify_charts),
MAX(in_spotify_charts),
AVG(in_spotify_charts)
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`;

---Formula para corrigir "streams" e transforma-los em INTEGER:

SELECT 
*,
SAFE_CAST(streams AS INT64) AS streams_corrigidos
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`
WHERE SAFE_CAST(streams AS INT64) IS NOT NULL;

---Nova variavel (data de lançamento completa)

SELECT 
*,
DATE(
CAST(released_year AS INT64),
CAST(released_month AS INT64),
CAST(released_day AS INT64)
) AS release_date
FROM `projeto2-hipoteses-459613.spotify_2023.1track_in_spotify`;

