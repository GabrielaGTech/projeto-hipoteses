from scipy import stats
import pandas as pd


# Carregar os dados
df_expandida = pd.read_csv('/content/tabela_expandida.csv')
df_filtrada = pd.read_csv('/content/tabela_filtrada.csv')


variaveis_categoria = [
'bpm_categoria', 'energy_categoria', 'danceability_categoria', 'valence_categoria',
'acousticness_categoria', 'instrumentalness_categoria', 'liveness_categoria', 'speechiness_categoria'
]


def testar_caracteristica(df, nome_tabela):
    print(f"\n====== Testes para {nome_tabela} ======")
   
    for var_cat in variaveis_categoria:
        print(f"\nAnalisando variável categorizada: {var_cat}")
       
# Grupos únicos da categoria (ex: 'baixa', 'média', 'alta')
        grupos = df[var_cat].dropna().unique()
       
# Valores de streams por grupo
        dados_por_grupo = [df[df[var_cat] == g]['streams_corrigidos'].dropna() for g in grupos]
       
# Testando a normalidade em cada grupo
        normais = []
        for i, grupo in enumerate(grupos):
            stat, p = stats.shapiro(dados_por_grupo[i])
            normais.append(p > 0.05)
            print(f"  Shapiro-Wilk para grupo '{grupo}': estatística={stat:.4f}, p-valor={p:.4f} -> {'Normal' if p > 0.05 else 'Não normal'}")
       
# Decidir, baseado na normalidade
        if all(normais):
            # Todos normais -> ANOVA
            stat, p = stats.f_oneway(*dados_por_grupo)
            print(f"  Teste ANOVA: estatística={stat:.4f}, p-valor={p:.4f}")
        else:
# Algum grupo não normal -> Kruskal-Wallis
            stat, p = stats.kruskal(*dados_por_grupo)
            print(f"  Teste Kruskal-Wallis: estatística={stat:.4f}, p-valor={p:.4f}")
       
# Interpretar resultado
        if p < 0.05:
            print("  Resultado: Existe diferença significativa no número de streams entre os grupos dessa característica.")
        else:
            print("  Resultado: Não há diferença significativa no número de streams entre os grupos dessa característica.")


# Para as duas tabelas
testar_caracteristica(df_expandida, "Tabela Expandida")
testar_caracteristica(df_filtrada, "Tabela Filtrada")
