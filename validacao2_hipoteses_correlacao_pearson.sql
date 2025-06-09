---Hipótese 01 (Com base na tabela expandida)

SELECT
CORR(bpm, streams_corrigidos) AS hipotese_bpm_streams
FROM `spotify_2023.tabela_unificada_tracks_expandida`;

--Com base na tabela filtrada

SELECT
CORR(bpm, streams_corrigidos) AS hipotese_bpm_streams
FROM `spotify_2023.tabela_unificada_tracks_filtrada`;


---Hipótese 02 (Com base na tabela filtrada)
--Deezer

SELECT
CORR (in_spotify_charts, in_deezer_charts) AS hipotese_charts_spotify_deezer,

--Apple

CORR (in_spotify_charts, in_apple_charts) AS hipotese_charts_spotify_apple,

--Deezer e Apple 

CORR (in_deezer_charts, in_apple_charts) AS charts_deezer_apple,
FROM `spotify_2023.tabela_unificada_tracks_filtrada`;

---Hipótese 03 
--Tabela Expandida para a Variável Spotify

SELECT
CORR(in_spotify_playlists, streams_corrigidos) AS hipotese_spotify_playlists_streams
FROM `spotify_2023.tabela_unificada_tracks_expandida`;

--Tabela Filtrada para as Variáveis Deezer e Apple 

SELECT
CORR(in_deezer_playlists, streams_corrigidos) AS hipotese_deezer_playlists_streams,
CORR(in_apple_playlists, streams_corrigidos) AS hipotese_apple_playlists_streams,
CORR(participacao_total_playlists,streams_corrigidos) AS hipotese_total_playlists_streams
FROM `spotify_2023.tabela_unificada_tracks_filtrada`;

---Hipótese 04
--Tabela Expandida

WITH artist_stream_counts_expandida AS (
SELECT
artist_name_cleaned,
COUNT(track_id_corrigido) AS total_songs,
SUM(streams_corrigidos) AS total_streams
FROM
`spotify_2023.tabela_unificada_tracks_expandida`
GROUP BY
artist_name_cleaned
)
SELECT
CORR(total_songs, total_streams) AS hipotese_artists_streams_expandida
FROM
artist_stream_counts_expandida;

--Tabela Filtrada

WITH artist_stream_counts_filtrada AS (
SELECT
artist_name_cleaned,
COUNT(track_id_corrigido) AS total_songs,
SUM(streams_corrigidos) AS total_streams
FROM
`spotify_2023.tabela_unificada_tracks_filtrada`
GROUP BY
artist_name_cleaned
)
SELECT
CORR(total_songs, total_streams) AS hipotese_artists_streams_filtrada
FROM
artist_stream_counts_filtrada;

---Hipótese 05 (Com base na tabela expandida)

SELECT
CORR(danceability_pct, streams_corrigidos) AS correlacao_danceability,
CORR(valence_pct, streams_corrigidos) AS correlacao_valence,
CORR(energy_pct, streams_corrigidos) AS correlacao_energy,
CORR(acousticness_pct, streams_corrigidos) AS correlacao_acousticness,
CORR(instrumentalness_pct, streams_corrigidos) AS correlacao_instrumentalness,
CORR(liveness_pct, streams_corrigidos) AS correlacao_liveness,
CORR(speechiness_pct, streams_corrigidos) AS correlacao_speechiness
FROM
`spotify_2023.tabela_unificada_tracks_expandida`;

--Com base na tabela Filtrada

SELECT
CORR(danceability_pct, streams_corrigidos) AS correlacao_danceability,
CORR(valence_pct, streams_corrigidos) AS correlacao_valence,
CORR(energy_pct, streams_corrigidos) AS correlacao_energy,
CORR(acousticness_pct, streams_corrigidos) AS correlacao_acousticness,
CORR(instrumentalness_pct, streams_corrigidos) AS correlacao_instrumentalness,
CORR(liveness_pct, streams_corrigidos) AS correlacao_liveness,
CORR(speechiness_pct, streams_corrigidos) AS correlacao_speechiness
FROM
`spotify_2023.tabela_unificada_tracks_filtrada`




