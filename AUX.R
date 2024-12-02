# -----------------------
# [1] Ativação de Pacotes
# -----------------------
library(readxl)
library(ggplot2)
library(plotly)
library(forcats)
library(dplyr)

# -----------------------
# [2] Importação do dados
# -----------------------

# Leitura da base de dados
bancoMoto = read_excel("data/BANCO_PESQUISA_MOTOCICLISTAS.xlsx")

# Algumas manipulações
bancoMoto[bancoMoto$ACIDENTE == "NÃO PREENCHIDO", "ACIDENTE"] = "NUNCA"
bancoMoto[is.na(bancoMoto$SEXO), "SEXO"] = "NÃO PREENCHIDO"
bancoMoto[bancoMoto$ESCOLARIDADE == 9, "ESCOLARIDADE"] = "NÃO PREENCHIDO"


escol_organiz <- bancoMoto %>%
  count(ESCOLARIDADE, sort = TRUE) %>%
  mutate(ESCOLARIDADE = factor(ESCOLARIDADE, levels = ESCOLARIDADE))

rotulo <- c("ENS MÉD COMP", "ENS MÉD INCOMP", 
            "ENS SUP COMP", "ENS FUN INCOMP",
            "ENS SUP INCOMP", "ENS FUN COMP", 
            "NÃO PREENC", "SEM ESCOL")

escol_organiz <- escol_organiz %>%
  mutate(ESCOLARIDADE = factor(rotulo, levels = rotulo))
  
escol_organiz


temp_organiz <- bancoMoto %>%
  count(TEMPO_CNH, sort = TRUE) %>%
  mutate(TEMPO_CNH = factor(TEMPO_CNH, levels = TEMPO_CNH))



