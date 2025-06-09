--- Correlação entre Streams e Playlists no Spotify (Tabela Expandida)
SELECT 
CORR (streams_corrigidos,in_spotify_playlists) as valor_correlacao 
FROM `spotify_2023.tabela_unificada_tracks_expandida`; --- Resultado 0.79039702099481768

--- Correlação entre Streams e Playlists no Spotify (Tabela Filtrada)
SELECT 
CORR (streams_corrigidos,in_spotify_playlists) as valor_correlacao 
FROM `spotify_2023.tabela_unificada_tracks_filtrada`; --- Resultado 0.7943338550056166


---Correlação entre Streams e Danceability (Tabela Expandida) 
SELECT 
CORR (streams_corrigidos,danceability_pct) as valor_correlacao
FROM `spotify_2023.tabela_unificada_tracks_expandida`; --- Resultado -0.10577319100302494

--- Correlação entre Streams e Total de Playlists (Tabela Filtrada)
SELECT
CORR (streams_corrigidos, participacao_total_playlists) as valor_correlacao
FROM `spotify_2023.tabela_unificada_tracks_filtrada`; --- Resultado  0.80087885574386508

---Correlação entre Streams e Danceability (Tabela Filtrada) 
SELECT
CORR (streams_corrigidos, danceability_pct) as valor_correlacao
FROM `spotify_2023.tabela_unificada_tracks_filtrada` --- Resultado -0.076757763462248038
