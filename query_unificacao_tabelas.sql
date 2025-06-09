--- Tabela Filtrada Unificada 

CREATE TABLE `projeto2-hipoteses-459613.spotify_2023.tabela_unificada_tracks_filtrada` AS
SELECT
v1.track_id_corrigido,
v1.* EXCEPT (track_id_corrigido),
v2.* EXCEPT (track_id_corrigido),
v3.* EXCEPT (track_id_corrigido),
-- Variável de participação total nas playlists
IFNULL(v1.in_spotify_playlists, 0)
+ IFNULL(v2.in_apple_playlists, 0)
+ IFNULL(v2.in_deezer_playlists, 0) AS participacao_total_playlists
FROM `projeto2-hipoteses-459613.spotify_2023.view_1track_in_spotify_padronizada_limpa` v1
LEFT JOIN `projeto2-hipoteses-459613.spotify_2023.view_2track_in_competition_limpa` v2 ON v1.track_id_corrigido = v2.track_id_corrigido
LEFT JOIN `projeto2-hipoteses-459613.spotify_2023.view_3track_technical_info_limpa` v3 ON v1.track_id_corrigido = v3.track_id_corrigido;


--- Tabela Expandida Unificada 

CREATE TABLE `projeto2-hipoteses-459613.spotify_2023.tabela_unificada_tracks_expandida` AS
SELECT
v1.track_id_corrigido,
v1.* EXCEPT (track_id_corrigido),
v2.* EXCEPT (track_id_corrigido),
FROM `projeto2-hipoteses-459613.spotify_2023.view_1track_in_spotify_limpa` v1
LEFT JOIN `projeto2-hipoteses-459613.spotify_2023.view_3track_technical_info_expandida` v2 ON v1.track_id_corrigido = v2.track_id_corrigido
