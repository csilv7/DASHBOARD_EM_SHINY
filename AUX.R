# -----------------------
# [1] Ativação de Pacotes
# -----------------------
library(readxl)
library(ggplot2)
library(plotly)
library(forcats)
library(dplyr)

# ------------------------------
# [2] Leitura e Ajustes do dados
# ------------------------------
# Leitura da base de dados
bancoMoto = read_excel("data/BANCO_PESQUISA_MOTOCICLISTAS.xlsx")

# Algumas manipulações
bancoMoto[bancoMoto$ACIDENTE == "NÃO PREENCHIDO", "ACIDENTE"] = "NUNCA"
bancoMoto[is.na(bancoMoto$SEXO), "SEXO"] = "NÃO PREENCHIDO"
bancoMoto[bancoMoto$ESCOLARIDADE == 9, "ESCOLARIDADE"] = "NÃO PREENCHIDO"

# --------------
# [3] Descritiva
# --------------
# ---------
# [3.] SEXO
# ---------
ggplotly(
  ggplot(data = bancoMoto, aes(x = SEXO)) +
    geom_bar(aes(y = ..count.., fill = SEXO), color = "black") +
    labs(x = "Gênero", y = "Nº de Entrevistados") +
    theme_minimal() +
    guides(fill = guide_legend(title = NULL))
)

# ----------
# [3.] IDADE
# ----------
ggplotly(
  ggplot(data = bancoMoto, aes(x = IDADE)) +
    geom_histogram(bins = 20, fill = "grey", color = "black") +
    labs(x = "Idade", y ="Frequência") +
    theme_minimal()
)

# -----------------
# [3.] ESCOLARIDADE
# -----------------
escol_organiz <- bancoMoto %>%
  count(ESCOLARIDADE, sort = TRUE) %>%
  mutate(ESCOLARIDADE = factor(ESCOLARIDADE, levels = ESCOLARIDADE))

rotulo <- c("ENS MÉD COMP", "ENS MÉD INCOMP", 
            "ENS SUP COMP", "ENS FUN INCOMP",
            "ENS SUP INCOMP", "ENS FUN COMP", 
            "NÃO PREENC", "SEM ESCOL")

escol_organiz <- escol_organiz %>%
  mutate(ESCOLARIDADE = factor(rotulo, levels = rotulo))

ggplotly(
  ggplot(data = escol_organiz, aes(x = ESCOLARIDADE, y = n, fill = ESCOLARIDADE)) +
    geom_bar(stat = "identity", color = "black") +
    coord_flip() +
    labs(x = "Grau de Escolaridade", y = "Nº de Entrevistados") +
    theme_minimal() +
    guides(fill = guide_legend(title = NULL))
)

# --------------
# [3.] CATEGORIA
# --------------
categ_organiz = bancoMoto %>%
  count(CATEGORIA, sort = TRUE) %>%
  mutate(CATEGORIA = factor(CATEGORIA, levels = CATEGORIA))

categ_organiz = categ_organiz[2:nrow(categ_organiz), ]

ggplotly(
  ggplot(data = categ_organiz, aes(x = CATEGORIA, y = n, fill = CATEGORIA)) +
    geom_bar(stat = "identity", color = "black") +
    coord_flip() +
    labs(x = "Categoria da CNH", y = "Nº de Entrevistados") +
    theme_minimal() +
    guides(fill = guide_legend(title = NULL))
)

# -----------------
# [3.] TEMPO DE CNH
# -----------------
temp_organiz <- bancoMoto %>%
  count(TEMPO_CNH, sort = TRUE) %>%
  mutate(TEMPO_CNH = factor(TEMPO_CNH, levels = TEMPO_CNH))

ggplotly(
  ggplot(data = temp_organiz, aes(x = TEMPO_CNH, y = n, fill = TEMPO_CNH)) +
    geom_bar(stat = "identity", color = "black") +
    coord_flip() +
    labs(x = "Tempo de CNH", y = "Nº de Entrevistados") +
    theme_minimal() +
    guides(fill = guide_legend(title = NULL))
)

# ---------------------------------
# [3.] MOTIVO DE NÃO SER HABILITADO
# ---------------------------------
motivo_organiz <- bancoMoto %>%
  count(MOTIVO_CNH, sort = TRUE) %>%
  mutate(MOTIVO_CNH = factor(MOTIVO_CNH, levels = MOTIVO_CNH))

ggplotly(
  ggplot(data = motivo_organiz, aes(x = MOTIVO_CNH, y = n, fill = MOTIVO_CNH)) +
    geom_bar(stat = "identity", color = "black") +
    coord_flip() +
    labs(x = "Motivo de não ter CNH", y = "Nº de Entrevistados") +
    theme_minimal() +
    guides(fill = guide_legend(title = NULL))
)