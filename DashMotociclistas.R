# -----------------------
# [1] Ativação de Pacotes
# -----------------------

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

library(readxl)
library(ggplot2)
library(plotly)
library(forcats)
library(dplyr)

# --------------------
rodapeL = "Dashboard criado via Pacote Shiny em R"
rodapeR = "Elaborado por Breno C R Silva - Estagiário de Estatística do DETRAN-PA"

# Leitura da base de dados
bancoMoto = read_excel("data/BANCO_PESQUISA_MOTOCICLISTAS.xlsx")

# Algumas manipulações
bancoMoto[bancoMoto$ACIDENTE == "NÃO PREENCHIDO", "ACIDENTE"] = "NUNCA"
bancoMoto[is.na(bancoMoto$SEXO), "SEXO"] = "NÃO PREENCHIDO"
bancoMoto[bancoMoto$ESCOLARIDADE == 9, "ESCOLARIDADE"] = "NÃO PREENCHIDO"
# --------------------

# -----------------------------------
# [2] FrontEnd - Interface do Usuário
# -----------------------------------

ui = dashboardPage(
  title = "Dashboard Motociclistas",
  skin = "blue",
  
  # ---------------
  # [2.1] CABEÇALHO
  # ---------------
  header = dashboardHeader(
    title = "Dash Motociclistas",
    titleWidth = 220
  ),
  
  # -------------------------------------
  # [2.2] BARRA LATERAL (MENUS E FILTROS)
  # -------------------------------------
  sidebar = dashboardSidebar(
    # ------------------------------------------
    # [2.2.1] LARGURA DA BARRA E ANEXO DE IMAGEM
    # ------------------------------------------
    width = 230,
    tags$img(src = "motociclistas.jpg", width = "100%", height = "auto"),
    
    # -----------------------
    # [2.2.2] MENUS E FILTROS
    # -----------------------
    sidebarMenu(
      # ------------------------
      # [2.2.2.1] SOCIOECONÔMICO
      # ------------------------
      menuItem("SOCIOECONÔMICO", tabName = "socioecon", icon = icon("book"),
               menuSubItem("SEXO",                    tabName = "descSexo",  icon = icon("user")),
               menuSubItem("IDADE",                   tabName = "descIdade", icon = icon("road")),
               menuSubItem("ESCOLARIDADE",            tabName = "descEscol", icon = icon("book")),
               menuSubItem("CATEGORIA DA CNH",        tabName = "descCat",   icon = icon("book")),
               menuSubItem("TEMPO DE CNH",            tabName = "descTemp",  icon = icon("book")),
               menuSubItem("MOTIVO DE FALTA DE CNH",  tabName = "descMot",   icon = icon("book"))),
      
      # --------------------
      # [2.2.2.2] LEGISLAÇÃO
      # --------------------
      menuItem("LEGISLAÇÃO",     tabName = "legislac",  icon = icon("book"),
               menuSubItem("PERGUNTA 8",  tabName = "pergunta8",  icon = icon("book")),
               menuSubItem("PERGUNTA 9",  tabName = "pergunta9",  icon = icon("book")),
               menuSubItem("PERGUNTA 10", tabName = "pergunta10", icon = icon("book")),
               menuSubItem("PERGUNTA 11", tabName = "pergunta11", icon = icon("book")),
               menuSubItem("PERGUNTA 12", tabName = "pergunta12", icon = icon("book"))),
      
      # -----------------------
      # [2.2.2.3] COMPORTAMENTO
      # -----------------------
      menuItem("COMPORTAMENTO",  tabName = "comport",   icon = icon("book"),
               menuSubItem("PERGUNTA 13",  tabName = "pergunta13",  icon = icon("book")),
               menuSubItem("PERGUNTA 14",  tabName = "pergunta14",  icon = icon("book")),
               menuSubItem("PERGUNTA 15",  tabName = "pergunta15",  icon = icon("book")),
               menuSubItem("PERGUNTA 16",  tabName = "pergunta16",  icon = icon("book")),
               menuSubItem("PERGUNTA 17",  tabName = "pergunta18",  icon = icon("book"))),
      
      # ----------------------------
      # [2.2.2.4] FILTRO - MUNÍCIPIO
      # ----------------------------
      selectInput("municipio", "MUNÍCIPIO",
                  choices = unique(bancoMoto$MUNICÍPIO), selected = "CASTANHAL"),
      
      # ----------------------------
      # [2.2.2.5] FILTRO - MUNÍCIPIO
      # ----------------------------
      selectInput("cnh", "CNH",
                  choices = c("SIM", "NÃO"), selected = "SIM"),
      
      # ----------------------------
      # [2.2.2.6] FILTRO - MUNÍCIPIO
      # ----------------------------
      selectInput("acidente", "SINISTRO DE TRÂNSITO",
                  choices = unique(bancoMoto$ACIDENTE)),
      
      # -----------------------------------------
      # [2.2.2.7] BOTÃO PARA REINICIAR OS FILTROS
      # -----------------------------------------
      actionButton("reset_button", "REINICIAR",
                   style = "background-color: green; 
                   color: white; 
                   border-radius: 5px; 
                   padding: 10px; 
                   font-size: 12px"),
      tableOutput("tabela_filtrada")
    )
  ),
  
  # -------------------
  # [2.3] CORPO DO DASH
  # -------------------
  body = dashboardBody(
    # -------------------
    # MENU SOCIOECONÔMICO
    # -------------------
    tabItem(tabName = "socioecon",
            fluidRow(
              box(title = "Distribuição por Gênero", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("sexoPlot", height = 300)),
              box(title = "Distribuição por Idade", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("idadePlot", height = 300)),
              box(title = "Distribuição por Grau de Escolaridade", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("escolaridadePlot", height = 300)),
              box(title = "Categoria da CNH", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("CatCNHPlot", height = 300)),
              box(title = "Distribuição do TEMPO de CNH", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("tempCNHPlot", height = 300)),
              
              box(title = "Motivo de NÃO ser Habilitado", 
                  status = "primary", 
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  plotlyOutput("transportePlot", height = 300))
            ))
  ),
  
  # ------
  # RODAPÉ
  # ------
  footer = dashboardFooter(left = rodapeL, right = rodapeR)
)

# -----------------------------
# [3] BackEnd - Camada Servidor
# -----------------------------

server <- function(input, output, session) {
  filtro = reactive({
    subset(bancoMoto, MUNICÍPIO == input$municipio & CNH == input$cnh & ACIDENTE == input$acidente)
  })
  
  # ------------------------
  # [3.] MENU SOCIOECONÔMICO
  # ------------------------
  # ---------
  # [3.] SEXO
  # ---------
  output$sexoPlot <- renderPlotly({
    ggplotly(
      ggplot(data = filtro(), aes(x = SEXO)) +
        geom_bar(aes(y = ..count.., fill = SEXO), color = "black") +
        labs(x = "Gênero", y = "Nº de Entrevistados") +
        theme_minimal() +
        guides(fill = guide_legend(title = NULL))
    )
  })
  
  # ----------
  # [3.] IDADE
  # ----------
  output$idadePlot = renderPlotly({
    ggplotly(
      ggplot(data = filtro(), aes(x = IDADE)) +
        geom_histogram(bins = 20, fill = "grey", color = "black") +
        labs(x = "Idade", y ="Frequência") +
        theme_minimal()
    )
  })
  
  # -----------------
  # [3.] ESCOLARIDADE
  # -----------------
  output$escolaridadePlot <- renderPlotly({
    
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
  })
  
  # --------------
  # [3.] CATEGORIA
  # --------------
  output$CatCNHPlot = renderPlotly({
    categ_organiz = filtro() %>%
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
  })
  
  # -----------------
  # [3.] TEMPO DE CNH
  # -----------------
  output$tempCNHPlot <- renderPlotly({
    temp_organiz <- filtro() %>%
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
  })
  
  # ---------------------------------
  # [3.] MOTIVO DE NÃO SER HABILITADO
  # ---------------------------------
  output$transportePlot <- renderPlotly({
    motivo_organiz <- filtro() %>%
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
  })
  
}

# ----------------------------
# [4] Produto Final: Dashboard
# ----------------------------
shinyApp(ui, server)