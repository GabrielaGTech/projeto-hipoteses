import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

df = pd.read_csv('/content/tabela_expandida.csv')

# 2. Selecionar colunas
colunas = [
'streams_corrigidos',
'acousticness_pct',
'bpm',
'danceability_pct',
'energy_pct',
'instrumentalness_pct',
'liveness_pct',
'speechiness_pct',
'valence_pct'
]

df = df[colunas]

df = df.rename(columns={
'streams_corrigidos': 'streams',
    **{col: col.replace('_pct', '') for col in colunas if '_pct' in col}
})

# 3. Calcular correlações
correlacoes = df.corr(numeric_only=True)

# 4. Criar mapa de calor 
cmap_personalizado = LinearSegmentedColormap.from_list(
"custom_corr_map",
["#800080", "#FF1493", "#FFB6C1", "#FFFFFF", "#00FFFF"]
)

plt.figure(figsize=(10, 8))
sns.heatmap(
correlacoes,
annot=True,
cmap=cmap_personalizado,
fmt=".2f",
linewidths=0.5,
vmin=-1,
vmax=1,
center=0,
annot_kws={"weight": "bold"}
)

plt.title("Mapa de Correlação entre Streams e Características Musicais", fontweight='bold', fontsize=14)
plt.xlabel('')
plt.ylabel('')
plt.tight_layout()
plt.show()





