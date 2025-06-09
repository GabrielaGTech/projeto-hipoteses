CREATE OR REPLACE TABLE `spotify_2023.tabela_unificada_tracks_expandida` AS

SELECT *,

NTILE(4) OVER (ORDER BY bpm) AS bpm_quartil,
CASE NTILE(4) OVER (ORDER BY bpm)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS bpm_categoria,

NTILE(4) OVER (ORDER BY energy_pct) AS energy_quartil,
CASE NTILE(4) OVER (ORDER BY energy_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS energy_categoria,

NTILE(4) OVER (ORDER BY danceability_pct) AS danceability_quartil,
CASE NTILE(4) OVER (ORDER BY danceability_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS danceability_categoria,

NTILE(4) OVER (ORDER BY valence_pct) AS valence_quartil,
CASE NTILE(4) OVER (ORDER BY valence_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS valence_categoria,

NTILE(4) OVER (ORDER BY acousticness_pct) AS acousticness_quartil,
CASE NTILE(4) OVER (ORDER BY acousticness_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS acousticness_categoria,

NTILE(4) OVER (ORDER BY instrumentalness_pct) AS instrumentalness_quartil,
CASE NTILE(4) OVER (ORDER BY instrumentalness_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS instrumentalness_categoria,

NTILE(4) OVER (ORDER BY liveness_pct) AS liveness_quartil,
CASE NTILE(4) OVER (ORDER BY liveness_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS liveness_categoria,

NTILE(4) OVER (ORDER BY speechiness_pct) AS speechiness_quartil,
CASE NTILE(4) OVER (ORDER BY speechiness_pct)
WHEN 1 THEN 'Baixa'
WHEN 2 THEN 'Média'
WHEN 3 THEN 'Média'
ELSE 'Alta'
END AS speechiness_categoria

FROM `spotify_2023.tabela_unificada_tracks_expandida`;
