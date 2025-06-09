# Para importar biblioteca necessária
from scipy import stats
import pandas as pd
# Para carregar os arquivos
df_expandida = pd.read_csv('/content/tabela_expandida.csv')
df_filtrada = pd.read_csv('/content/tabela_filtrada.csv')
# APLICANDO O TESTE DE SHAPIRO-WILK - CONSIDERANDO TODOS OS DADOS
shapiro_tudo_expandida = stats.shapiro(df_expandida['streams_corrigidos'])
shapiro_tudo_filtrada = stats.shapiro(df_filtrada['streams_corrigidos'])
print("\n SHAPIRO - TODOS OS STREAMS")
print("EXPANDIDA:", shapiro_tudo_expandida)
print("FILTRADA:", shapiro_tudo_filtrada)
# APLICANDO O TESTE DE SHAPIRO-WILK - DIVIDIDO POR MODE
# Separando por grupo (Major / Minor)
streams_maior_exp = df_expandida[df_expandida['mode'] == 'Major']['streams_corrigidos']
streams_menor_exp = df_expandida[df_expandida['mode'] == 'Minor']['streams_corrigidos']
streams_maior_filt = df_filtrada[df_filtrada['mode'] == 'Major']['streams_corrigidos']
streams_menor_filt = df_filtrada[df_filtrada['mode'] == 'Minor']['streams_corrigidos']
# Teste de Shapiro-Wilk para cada grupo
shapiro_maior_exp = stats.shapiro(streams_maior_exp)
shapiro_menor_exp = stats.shapiro(streams_menor_exp)
shapiro_maior_filt = stats.shapiro(streams_maior_filt)
shapiro_menor_filt = stats.shapiro(streams_menor_filt)
print("\n SHAPIRO - DIVIDIDO POR MODE")
print("EXPANDIDA - Major:", shapiro_maior_exp)
print("EXPANDIDA - Minor:", shapiro_menor_exp)
print("FILTRADA - Major:", shapiro_maior_filt)
print("FILTRADA - Minor:", shapiro_menor_filt)
from scipy import stats
import pandas as pd
# Ler os dados
tabela_expandida = pd.read_csv('/content/tabela_expandida.csv')
tabela_filtrada = pd.read_csv('/content/tabela_filtrada.csv')
# Separar os streams corrigidos para cada grupo 'mode'
streams_major_exp = tabela_expandida[tabela_expandida['mode'] == 'Major']['streams_corrigidos']
streams_minor_exp = tabela_expandida[tabela_expandida['mode'] == 'Minor']['streams_corrigidos']
streams_major_filt = tabela_filtrada[tabela_filtrada['mode'] == 'Major']['streams_corrigidos']
streams_minor_filt = tabela_filtrada[tabela_filtrada['mode'] == 'Minor']['streams_corrigidos']
# Aplicar o teste Mann-Whitney U (não paramétrico)
mannwhitney_exp = stats.mannwhitneyu(streams_major_exp, streams_minor_exp, alternative='two-sided')
mannwhitney_filt = stats.mannwhitneyu(streams_major_filt, streams_minor_filt, alternative='two-sided')
# Mostrar resultados
print("Tabela Expandida - Mann-Whitney U Teste:")
print(f"Estatística: {mannwhitney_exp.statistic}, p-valor: {mannwhitney_exp.pvalue}")
print("\nTabela Filtrada - Mann-Whitney U Teste:")
print(f"Estatística: {mannwhitney_filt.statistic}, p-valor: {mannwhitney_filt.pvalue}")
# Interpretar resultados
def interpretar_pvalor(p):
    if p < 0.05:
        return "Existe diferença significativa entre os grupos."
    else:
        return "Não há diferença significativa entre os grupos."
print("\nInterpretação Tabela Expandida:", interpretar_pvalor(mannwhitney_exp.pvalue))
print("Interpretação Tabela Filtrada:", interpretar_pvalor(mannwhitney_filt.pvalue))
