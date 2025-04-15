library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyFeedback)
library(dplyr)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  useShinyjs(),
  useShinyFeedback(),

  titlePanel("Jeu Takuzu "),

  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectInput("taille", "Taille de grille:", choices = c(4,6,8,10,12,14), selected = 6),
      selectInput("difficulte", "Difficulté:",
                  choices = c("Facile" = "facile", "Moyen" = "moyen", "Difficile" = "difficile"),
                  selected = "moyen"),
      actionButton("nouvelle_grille", "Nouvelle Grille",
                   class = "btn-primary", style = "width: 100%;"),
      hr(),
      h4("Contrôles:"),
      fluidRow(
        column(6, actionButton("btn_zero", "0", class = "btn-info", style = "width: 100%;")),
        column(6, actionButton("btn_un", "1", class = "btn-info", style = "width: 100%;"))
      ),
      actionButton("btn_effacer", "Effacer", class = "btn-warning", style = "width: 100%;"),
      hr(),
      actionButton("verifier", "Vérifier", class = "btn-success", style = "width: 100%;"),
      actionButton("solution", "Solution", class = "btn-danger", style = "width: 100%;"),
      hr(),
      htmlOutput("stats_jeu"),
      hr(),
      htmlOutput("timer")
    ),

    mainPanel(
      width = 9,
      uiOutput("grille_ui"),
      hidden(div(id = "message_container", wellPanel(textOutput("message")))),
      hr(),
      tabsetPanel(
        tabPanel("Règles",
                 HTML("<h3>Règles du Takuzu:</h3>
                      <ol>
                        <li>Remplir la grille avec des 0 et 1</li>
                        <li>Même nombre de 0 et 1 sur chaque ligne et colonne</li>
                        <li>Pas plus de deux 0 ou deux 1 côte à côte</li>
                        <li>Pas de lignes ou colonnes identiques</li>
                      </ol>")),
        tabPanel("Aide",
                 HTML("<h3>Comment jouer:</h3>
                      <p>1. Choisissez taille et difficulté</p>
                      <p>2. Cliquez sur 'Nouvelle Grille'</p>
                      <p>3. Sélectionnez 0 ou 1 puis cliquez sur une case vide</p>
                      <p>4. Utilisez 'Vérifier' pour valider</p>"))
      )
    )
  ),

  tags$head(tags$style(HTML("
    .cellule {
      width: 35px; height: 35px;
      margin: 1px;
      padding: 0;
      font-weight: bold;
      font-size: 14px;
      border: 1px solid #555;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .cellule-lg { width: 30px; height: 30px; font-size: 12px; }
    .cellule-xl { width: 25px; height: 25px; font-size: 10px; }
    .cellule-0 { background-color: white; color: black; }
    .cellule-1 { background-color: #333; color: white; }
    .cellule-vide { background-color: #f8f9fa; cursor: pointer; }
    .cellule-fixe { background-color: #6c757d !important; color: white !important; cursor: not-allowed; }
    .cellule-conflit { border: 2px solid #dc3545 !important; }
    #message_container { text-align: center; font-size: 16px; }
    #timer { font-size: 18px; font-weight: bold; text-align: center; margin-top: 10px; }
    .grille-container { display: flex; justify-content: center; margin: 10px 0; overflow-x: auto; }
  ")))
)

