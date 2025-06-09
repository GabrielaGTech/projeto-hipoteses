---Para contar quantos registros estão nulos ou vazios em cada variável.

SELECT
COUNTIF(track_id IS NULL OR TRIM(track_id) = '') AS nulos_ou_vazios_track_id,
COUNTIF(bpm IS NULL OR TRIM(CAST(bpm AS STRING)) = '') AS nulos_ou_vazios_bpm,
COUNTIF(`key` IS NULL OR TRIM(CAST(`key` AS STRING)) = '') AS nulos_ou_vazios_key,
COUNTIF(mode IS NULL OR TRIM(CAST(mode AS STRING)) = '') AS nulos_ou_vazios_mode,
COUNTIF(`danceability_pct` IS NULL OR TRIM(CAST(`danceability_pct` AS STRING)) = '') AS nulos_ou_vazios_danceability,
COUNTIF(`valence_pct` IS NULL OR TRIM(CAST(`valence_pct` AS STRING)) = '') AS nulos_ou_vazios_valence,
COUNTIF(`energy_pct` IS NULL OR TRIM(CAST(`energy_pct` AS STRING)) = '') AS nulos_ou_vazios_energy,
COUNTIF(`acousticness_pct` IS NULL OR TRIM(CAST(`acousticness_pct` AS STRING)) = '') AS nulos_ou_vazios_acousticness,
COUNTIF(`instrumentalness_pct` IS NULL OR TRIM(CAST(`instrumentalness_pct` AS STRING)) = '') AS nulos_ou_vazios_instrumentalness,
COUNTIF(`liveness_pct` IS NULL OR TRIM(CAST(`liveness_pct` AS STRING)) = '') AS nulos_ou_vazios_liveness,
COUNTIF(`speechiness_pct` IS NULL OR TRIM(CAST(`speechiness_pct` AS STRING)) = '') AS nulos_ou_vazios_speechiness,
COUNT(*) AS total_registros
FROM `projeto2-hipoteses-459613.spotify_2023.3track_technical_info`;

---Seleciona e retorna as colunas da tabela , convertendo os valores nulos na coluna key para a string "Sem Tom Informado". Para os registros que não possuem valores nulos na coluna key, os dados são retornados de forma normal, sem alterações.

SELECT
track_id,
bpm,
`key`,
`mode`,
`danceability_pct`,
`valence_pct`,
`energy_pct`,
`acousticness_pct`,
`instrumentalness_pct`,
`liveness_pct`,
`speechiness_pct`,
CASE
WHEN `key` IS NULL OR TRIM(CAST(`key` AS STRING)) = '' THEN 'Sem Tom Informado'
ELSE CAST(`key` AS STRING)
END AS key_musical_label
FROM `projeto2-hipoteses-459613.spotify_2023.3track_technical_info`;

------Seleciona colunas específicas da tabela, agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.

SELECT
track_id,
bpm,
key,
mode,
danceability_pct,
valence_pct,
energy_pct,
acousticness_pct,
instrumentalness_pct,
liveness_pct,
speechiness_pct,
COUNT(*) AS total_duplicados
FROM
`projeto2-hipoteses-459613.spotify_2023.3track_technical_info`
GROUP BY
track_id,
bpm,
key,
mode,
danceability_pct,
valence_pct,
energy_pct,
acousticness_pct,
instrumentalness_pct,
liveness_pct,
speechiness_pct
HAVING
COUNT(*) > 1;

---Seleciona colunas específicas da tabela,no caso aqui ficou de fora a coluna que continha dados nulos,  agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.

SELECT
track_id,
bpm,
mode,
danceability_pct,
valence_pct,
energy_pct,
acousticness_pct,
instrumentalness_pct,
liveness_pct,
speechiness_pct,
COUNT(*) AS total_duplicados
FROM
`projeto2-hipoteses-459613.spotify_2023.3track_technical_info`
GROUP BY
track_id,
bpm,
mode,
danceability_pct,
valence_pct,
energy_pct,
acousticness_pct,
instrumentalness_pct,
liveness_pct,
speechiness_pct
HAVING
COUNT(*) > 1;

---Retorna todas as colunas da tabela 3track_technical_info, com exceção da coluna key. Ou seja, todos os dados da tabela serão retornados, mas a coluna key será excluída do conjunto de dados.

SELECT
* EXCEPT(key)
FROM
`projeto2-hipoteses-459613.spotify_2023.3track_technical_info`;

--- Verificação de track_id fora do padrão esperado

SELECT track_id
FROM `projeto2-hipoteses-459613.spotify_2023.3track_technical_info`
WHERE REGEXP_CONTAINS(CAST(track_id AS STRING), r'[^a-zA-Z0-9]')  
OR NOT REGEXP_CONTAINS(CAST(track_id AS STRING), r'^\d{7}$');

--- Correção track_id fora do padrão

-- Coletar todos os track_ids e colunas da tabela
WITH todos_ids AS (
SELECT *, CAST(track_id AS STRING) AS track_id_str
FROM `projeto2-hipoteses-459613.spotify_2023.3track_technical_info`
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
