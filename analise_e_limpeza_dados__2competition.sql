--- Para verificar os dados de todas as colunas da tabela

SELECT *
FROM `projeto2-hipoteses-459613.spotify_2023.2track_in_competition`;

---Para contar quantos registros estão nulos ou vazios em cada variável.

SELECT
COUNTIF(track_id IS NULL OR TRIM(track_id) = '') AS nulos_ou_vazios_track_id,
COUNTIF(in_apple_playlists IS NULL OR TRIM(CAST(in_apple_playlists AS STRING)) = '') AS nulos_ou_vazios_in_apple_playlists,
COUNTIF(in_apple_charts IS NULL OR TRIM(CAST(in_apple_charts AS STRING)) = '') AS nulos_ou_vazios_in_apple_charts,
COUNTIF(in_deezer_playlists IS NULL OR TRIM(CAST(in_deezer_playlists AS STRING)) = '') AS nulos_ou_vazios_in_deezer_playlists,
COUNTIF(in_deezer_charts IS NULL OR TRIM(CAST(in_deezer_charts AS STRING)) = '') AS nulos_ou_vazios_in_deezer_charts,
COUNTIF(in_shazam_charts IS NULL OR TRIM(CAST(in_shazam_charts AS STRING)) = '') AS nulos_ou_vazios_in_shazam_charts,
COUNT(*) AS total_registros
FROM `projeto2-hipoteses-459613.spotify_2023.2track_in_competition`;

------Seleciona colunas específicas da tabela, agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.

SELECT
track_id,
in_apple_playlists,
in_apple_charts,
in_deezer_playlists,
in_deezer_charts,
in_shazam_charts,
COUNT(*) AS total_duplicados
FROM
`projeto2-hipoteses-459613.spotify_2023.2track_in_competition`
GROUP BY
track_id,
in_apple_playlists,
in_apple_charts,
in_deezer_playlists,
in_deezer_charts,
in_shazam_charts
HAVING
COUNT(*) > 1;

---Seleciona colunas específicas da tabela,no caso aqui ficou de fora a coluna que continha dados nulos,  agrupa os dados baseando em todas as colunas listadas, filtra apenas os grupos que aparecem mais de uma vez e conta o total de duplicidades.


SELECT
track_id,
in_apple_playlists,
in_apple_charts,
in_deezer_playlists,
in_deezer_charts,
COUNT(*) AS total_duplicados
FROM
`projeto2-hipoteses-459613.spotify_2023.2track_in_competition`
GROUP BY
track_id,
in_apple_playlists,
in_apple_charts,
in_deezer_playlists,
in_deezer_charts
HAVING
COUNT(*) > 1;

---Retorna todas as colunas da tabela 2track_in_competition, com exceção da coluna in_shazam_charts. Ou seja, todos os dados da tabela serão retornados, mas a coluna in_shazam_charts será excluída do conjunto de dados.


SELECT
* EXCEPT(in_shazam_charts)
FROM
`projeto2-hipoteses-459613.spotify_2023.2track_in_competition`;

--- Verificação de track_id fora do padrão esperado

SELECT track_id
FROM `projeto2-hipoteses-459613.spotify_2023.2track_in_competition`
WHERE REGEXP_CONTAINS(CAST(track_id AS STRING), r'[^a-zA-Z0-9]')  
OR NOT REGEXP_CONTAINS(CAST(track_id AS STRING), r'^\d{7}$');

--- Correção track_id fora do padrão
-- Coletar todos os track_ids e colunas da tabela

WITH todos_ids AS (
SELECT *, CAST(track_id AS STRING) AS track_id_str
FROM `projeto2-hipoteses-459613.spotify_2023.2track_in_competition`
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
WHEN track_id_str = '00:00' THEN (SELECT novo_track_id FROM primeiro_id_disponivel)
ELSE track_id_str
END AS track_id_corrigido
FROM todos_ids;

--- *Foi verificado dados discrepantes com a função min, max e avg, nesta tabela só identifiquei em "in_deezer_playlists" e os dados foram removidas uma vez que não tinha como ter certeza do que seria o correto em relação a eles. Foi feito a remoção, importação novamente do arquivo e a correção das formulas. Em "in_shazam_charts" não considerei a consulta uma vez que essa coluna será excluida da analise.
