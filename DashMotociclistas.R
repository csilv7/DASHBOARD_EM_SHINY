# -----------------------
# [1] Ativação de Pacotes
# -----------------------

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

library(readxl)

# --------------------
rodapeL = "Dashboard criado via Pacote Shiny em R"
rodapeR = "Elaborado por Breno C R Silva - Estagiário de Estatística do DETRAN-PA"


# Leitura da base de dados
bancoMoto = read_excel("data/BANCO_PESQUISA_MOTOCICLISTAS.xlsx")

# Algumas manipulações
bancoMoto[bancoMoto$ACIDENTE == "NÃO PREENCHIDO", "ACIDENTE"] = "NUNCA"


# --------------------

# ------------
# [2] FrontEnd
# ------------

# Interface do Usuário
ui = dashboardPage(
  title = "Dashboard Motociclistas",
  skin = "black",
  
  # Cabeçalho
  header = dashboardHeader(
    title = "Dash Motociclistas",
    titleWidth = 220
  ),
  
  # Barra Lateral com Menus e Filtros
  sidebar = dashboardSidebar(
    width = 230,
    tags$img(src = "motociclistas.jpg", width = "100%", height = "auto"),
    
    sidebarMenu(
      menuItem("SOCIOECONÔMICO", tabName = "socioecon", icon = icon("book"),
               menuSubItem("SEXO",                    tabName = "descSexo",  icon = icon("user")),
               menuSubItem("IDADE",                   tabName = "descIdade", icon = icon("road")),
               menuSubItem("ESCOLARIDADE",            tabName = "descEscol", icon = icon("book")),
               menuSubItem("CATEGORIA DA CNH",        tabName = "descCat",   icon = icon("book")),
               menuSubItem("TEMPO DE CNH",            tabName = "descTemp",  icon = icon("book")),
               menuSubItem("MOTIVO DE FALTA DE CNH",  tabName = "descMot",   icon = icon("book"))),
      
      menuItem("LEGISLAÇÃO",     tabName = "legislac",  icon = icon("book"),
               menuSubItem("PERGUNTA 8",  tabName = "pergunta8",  icon = icon("book")),
               menuSubItem("PERGUNTA 9",  tabName = "pergunta9",  icon = icon("book")),
               menuSubItem("PERGUNTA 10", tabName = "pergunta10", icon = icon("book")),
               menuSubItem("PERGUNTA 11", tabName = "pergunta11", icon = icon("book")),
               menuSubItem("PERGUNTA 12", tabName = "pergunta12", icon = icon("book"))),
      
      menuItem("COMPORTAMENTO",  tabName = "comport",   icon = icon("book"),
               menuSubItem("PERGUNTA 13",  tabName = "pergunta13",  icon = icon("book")),
               menuSubItem("PERGUNTA 14",  tabName = "pergunta14",  icon = icon("book")),
               menuSubItem("PERGUNTA 15",  tabName = "pergunta15",  icon = icon("book")),
               menuSubItem("PERGUNTA 16",  tabName = "pergunta16",  icon = icon("book")),
               menuSubItem("PERGUNTA 17",  tabName = "pergunta18",  icon = icon("book"))),
      
      selectInput("municipio", "MUNÍCIPIO DE APLICAÇÃO",
                  choices = unique(bancoMoto$MUNICÍPIO), selected = "CASTANHAL"),
      
      selectInput("cnh", "POSSUI HABILITAÇÃO?",
                  choices = c("SIM", "NÃO"), selected = "SIM"),
      
      selectInput("acidente", "VOCÊ E/OU ALGUM FAMILIAR JÁ SOFRERAM ALGUM ACIDENTE?",
                  choices = unique(bancoMoto$ACIDENTE)),
      
      # Botão para reiniciar os filtros
      actionButton("reset_button", "REINICIAR",
                   style = "background-color: #28a745; 
                   color: white; 
                   border-radius: 5px; 
                   padding: 10px; 
                   font-size: 12px")
    )
  ),
  
  # Resultados
  body = dashboardBody(),
  
  # Rodapé
  footer = dashboardFooter(left = rodapeL, right = rodapeR)
)

# -----------
# [3] BackEnd
# -----------

server <- function(input, output, session) {
  
}

# ----------------------------
# [4] Produto Final: Dashboard
# ----------------------------

shinyApp(ui, server)