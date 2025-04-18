library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyFeedback)
library(dplyr)


server <- function(input, output, session) {
  valeurs <- reactiveValues(
    grille = NULL,
    solution = NULL,
    cases_fixes = NULL,
    valeur_active = NA,
    erreurs = NULL,
    debut_jeu = NULL,
    temps_ecoule = 0
  )

  # Ajustement taille cellules
  observe({
    taille <- as.numeric(input$taille)
    if (taille > 10) {
      runjs("$('.cellule').addClass('cellule-xl').removeClass('cellule-lg');")
    } else if (taille > 8) {
      runjs("$('.cellule').addClass('cellule-lg').removeClass('cellule-xl');")
    } else {
      runjs("$('.cellule').removeClass('cellule-lg cellule-xl');")
    }
  })

  # Timer
  observe({
    invalidateLater(1000, session)
    if (!is.null(valeurs$debut_jeu)) {
      valeurs$temps_ecoule <- as.integer(difftime(Sys.time(), valeurs$debut_jeu, units = "secs"))
    }
  })

  output$timer <- renderUI({
    temps <- valeurs$temps_ecoule
    HTML(paste0("<div id='timer'>Temps: ", sprintf("%02d:%02d", temps %/% 60, temps %% 60), "</div>"))
  })

  # Nouvelle grille
  observeEvent(input$nouvelle_grille, {
    taille <- as.numeric(input$taille)
    difficulte <- input$difficulte

    puzzle <- generer_puzzle_valide(taille, difficulte)
    valeurs$grille <- puzzle$grille
    valeurs$solution <- puzzle$solution
    valeurs$cases_fixes <- !is.na(puzzle$grille)
    valeurs$erreurs <- matrix(FALSE, nrow = taille, ncol = taille)
    valeurs$debut_jeu <- Sys.time()
    valeurs$temps_ecoule <- 0

    hide("message_container") # Cacher le message de félicitations
  })

  # Affichage grille
  output$grille_ui <- renderUI({
    req(valeurs$grille)
    taille <- nrow(valeurs$grille)

    div(class = "grille-container",
        div(style = paste("display: grid; grid-template-columns:", paste(rep("auto", taille), collapse = " "), ";"),
            lapply(1:taille, function(i) {
              lapply(1:taille, function(j) {
                valeur <- valeurs$grille[i,j]
                disabled <- valeurs$cases_fixes[i,j]
                erreur <- valeurs$erreurs[i,j]

                classe <- if (is.na(valeur)) "cellule-vide" else paste0("cellule-", valeur)
                if (disabled) classe <- paste(classe, "cellule-fixe")
                if (erreur) classe <- paste(classe, "cellule-conflit")
                if (taille > 10) classe <- paste(classe, "cellule-xl")
                else if (taille > 8) classe <- paste(classe, "cellule-lg")

                actionButton(
                  paste0("cell_", i, "_", j),
                  ifelse(is.na(valeur), "", valeur),
                  class = paste("cellule", classe),
                  disabled = disabled,
                  onclick = if (!disabled) sprintf('Shiny.setInputValue("cellule_cliquee", "%s,%s")', i, j)
                )
              })
            })
        )
    )
  })

  # Gestion clics
  observeEvent(input$cellule_cliquee, {
    if (!is.na(valeurs$valeur_active)) {
      coords <- as.numeric(strsplit(input$cellule_cliquee, ",")[[1]])
      i <- coords[1]
      j <- coords[2]

      if (!valeurs$cases_fixes[i,j]) {
        valeurs$grille[i,j] <- valeurs$valeur_active
        verifier_conflits_locaux(i, j)
      }
    }
  })

  verifier_conflits_locaux <- function(i, j) {
    taille <- nrow(valeurs$grille)
    erreurs <- matrix(FALSE, nrow = taille, ncol = taille)

    # Vérifier ligne
    ligne <- valeurs$grille[i,]
    if (sum(!is.na(ligne)) >= 3) {
      r <- rle(ligne[!is.na(ligne)])
      if (any(r$lengths > 2)) {
        indices <- which(!is.na(ligne))
        for (k in 1:(length(indices)-2)) {
          if (length(unique(ligne[indices[k:(k+2)]])) == 1) {
            erreurs[i, indices[k:(k+2)]] <- TRUE
          }
        }
      }
    }

    # Vérifier colonne
    colonne <- valeurs$grille[,j]
    if (sum(!is.na(colonne)) >= 3) {
      r <- rle(colonne[!is.na(colonne)])
      if (any(r$lengths > 2)) {
        indices <- which(!is.na(colonne))
        for (k in 1:(length(indices)-2)) {
          if (length(unique(colonne[indices[k:(k+2)]])) == 1) {
            erreurs[indices[k:(k+2)], j] <- TRUE
          }
        }
      }
    }

    valeurs$erreurs <- erreurs
  }

  # Contrôles
  observeEvent(input$btn_zero, {
    valeurs$valeur_active <- 0
    showFeedbackSuccess("btn_zero", "0 sélectionné")
    hideFeedback("btn_un")
  })

  observeEvent(input$btn_un, {
    valeurs$valeur_active <- 1
    showFeedbackSuccess("btn_un", "1 sélectionné")
    hideFeedback("btn_zero")
  })

  observeEvent(input$btn_effacer, {
    coords <- strsplit(input$cellule_cliquee, ",")[[1]]
    if (length(coords) == 2) {
      i <- as.numeric(coords[1])
      j <- as.numeric(coords[2])
      if (!valeurs$cases_fixes[i,j]) {
        valeurs$grille[i,j] <- NA
        valeurs$erreurs[i,j] <- FALSE
      }
    }
  })

  # Vérification solution
  observeEvent(input$verifier, {
    req(valeurs$grille)

    if (any(is.na(valeurs$grille[!valeurs$cases_fixes]))) {
      showNotification("Veuillez remplir toutes les cases vides d'abord!", type = "warning")
      return()
    }

    # D'abord vérifier si les règles sont respectées
    regles_ok <- TRUE
    taille <- nrow(valeurs$grille)

    # 1. Vérifier qu'il n'y a pas trois 0 ou 1 consécutifs
    for (i in 1:taille) {
      if (any(rle(valeurs$grille[i,])$lengths > 2)) {
        regles_ok <- FALSE
        break
      }
      if (any(rle(valeurs$grille[,i])$lengths > 2)) {
        regles_ok <- FALSE
        break
      }
    }

    # 2. Vérifier l'équilibre 0/1
    if (regles_ok) {
      for (i in 1:taille) {
        nb0_ligne <- sum(valeurs$grille[i,] == 0)
        nb1_ligne <- sum(valeurs$grille[i,] == 1)
        if (abs(nb0_ligne - nb1_ligne) > 1) {
          regles_ok <- FALSE
          break
        }

        nb0_col <- sum(valeurs$grille[,i] == 0)
        nb1_col <- sum(valeurs$grille[,i] == 1)
        if (abs(nb0_col - nb1_col) > 1) {
          regles_ok <- FALSE
          break
        }
      }
    }

    # 3. Vérifier l'unicité des lignes/colonnes (optionnel, peut être enlevé pour performance)
    if (regles_ok && taille <= 8) {  # Seulement pour les petites grilles
      if (any(duplicated(valeurs$grille)) || any(duplicated(t(valeurs$grille)))) {
        regles_ok <- FALSE
      }
    }

    if (!regles_ok) {
      showNotification("Votre solution ne respecte pas les règles du Takuzu", type = "error")
      return()
    }

    # Si les règles sont OK, vérifier si c'est la solution exacte
    if (all(valeurs$grille == valeurs$solution, na.rm = TRUE)) {
      temps <- valeurs$temps_ecoule
      show("message_container")
      output$message <- renderText(paste(
        "Félicitations! Vous avez résolu le puzzle en",
        sprintf("%02d:%02d", temps %/% 60, temps %% 60)
      ))
    } else {
      showNotification("Votre solution respecte les règles mais n'est pas la bonne solution.", type = "warning")
    }
  })

  # Solution
  observeEvent(input$solution, {
    valeurs$grille <- valeurs$solution
    showNotification("Solution affichée", type = "default")
  })

  # Statistiques
  output$stats_jeu <- renderUI({
    req(valeurs$grille)

    taille <- nrow(valeurs$grille)
    nb_fixes <- sum(valeurs$cases_fixes)
    nb_vides <- sum(is.na(valeurs$grille))
    nb_remplis <- sum(!is.na(valeurs$grille)) - nb_fixes

    HTML(paste(
      "<h4>Progression:</h4>",
      "<p><b>Cases fixes:</b> ", nb_fixes, "</p>",
      "<p><b>Remplies:</b> ", nb_remplis, "</p>",
      "<p><b>Vides:</b> ", nb_vides, "</p>"
    ))
  })

  # Initialisation
  observe({
    if (is.null(valeurs$grille)) {
      puzzle <- generer_puzzle_valide(6, "moyen")
      valeurs$grille <- puzzle$grille
      valeurs$solution <- puzzle$solution
      valeurs$cases_fixes <- !is.na(puzzle$grille)
      valeurs$erreurs <- matrix(FALSE, nrow = 6, ncol = 6)
      valeurs$debut_jeu <- Sys.time()
      valeurs$temps_ecoule <- 0
    }
  })
}



