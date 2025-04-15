#' Génère une grille Takuzu complète et valide
#' @param taille Taille de la grille
#' @return Une matrice complète
#' @export
generer_solution_valide <- function(taille) {
  max_attempts <- 100000
  attempt <- 0

  while(attempt < max_attempts) {
    attempt <- attempt + 1
    grille <- matrix(NA, nrow = taille, ncol = taille)
    valide <- TRUE

    for (i in 1:taille) {
      for (j in 1:taille) {
        possibles <- c(0, 1)

        # Règle 1: Pas trois identiques consécutifs
        if (j >= 3 && length(unique(grille[i, (j-2):(j-1)])) == 1) {
          possibles <- setdiff(possibles, grille[i, j-1])
        }
        if (i >= 3 && length(unique(grille[(i-2):(i-1), j])) == 1) {
          possibles <- setdiff(possibles, grille[i-1, j])
        }

        # Règle 2: Équilibre ligne/colonne
        nb0_ligne <- sum(grille[i,] == 0, na.rm = TRUE)
        nb1_ligne <- sum(grille[i,] == 1, na.rm = TRUE)
        if (nb0_ligne >= ceiling(taille/2)) possibles <- setdiff(possibles, 0)
        if (nb1_ligne >= ceiling(taille/2)) possibles <- setdiff(possibles, 1)

        nb0_col <- sum(grille[,j] == 0, na.rm = TRUE)
        nb1_col <- sum(grille[,j] == 1, na.rm = TRUE)
        if (nb0_col >= ceiling(taille/2)) possibles <- setdiff(possibles, 0)
        if (nb1_col >= ceiling(taille/2)) possibles <- setdiff(possibles, 1)

        if (length(possibles) == 0) {
          valide <- FALSE
          break
        }

        grille[i,j] <- if (length(possibles) == 1) possibles else sample(possibles, 1)
      }
      if (!valide) break
    }

    if (valide && verifier_solution_complete(grille)) {
      return(grille)
    }
  }

  stop("Impossible de générer une solution valide après ", max_attempts, " tentatives")
}

#' Génère une grille de jeu partiellement remplie
#' @param taille Taille de la grille
#' @param difficulte Niveau de difficulté : facile, moyen ou difficile
#' @return Une liste avec la grille partielle et la solution
#' @export
generer_puzzle_valide <- function(taille, difficulte = "moyen") {
  solution <- generer_solution_valide(taille)

  prob <- switch(difficulte,
                 "facile" = 0.7,
                 "moyen" = 0.5,
                 "difficile" = 0.3,
                 0.5)

  repeat {
    masque <- sample(c(TRUE, FALSE), taille*taille, replace = TRUE, prob = c(prob, 1-prob))
    grille_jeu <- ifelse(masque, solution, NA)
    dim(grille_jeu) <- c(taille, taille)

    if (verifier_grille_partielle(grille_jeu, solution)) break
  }

  return(list(grille = grille_jeu, solution = solution))
}
