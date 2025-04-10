#' Vérifie si une grille est valide selon les règles du jeu
#' @param grille Une matrice
#' @return TRUE/FALSE
#' @export
verifier_solution_complete <- function(grille) {
  taille <- nrow(grille)

  # Règle 1: Équilibre 0/1
  for (i in 1:taille) {
    if (sum(grille[i,] == 0) != floor(taille/2) && sum(grille[i,] == 0) != ceiling(taille/2)) return(FALSE)
    if (sum(grille[,i] == 0) != floor(taille/2) && sum(grille[,i] == 0) != ceiling(taille/2)) return(FALSE)
  }

  # Règle 2: Pas trois identiques consécutifs
  for (i in 1:taille) {
    if (any(rle(grille[i,])$lengths > 2)) return(FALSE)
    if (any(rle(grille[,i])$lengths > 2)) return(FALSE)
  }

  # Règle 3: Unicité lignes/colonnes
  if (any(duplicated(grille))) return(FALSE)
  if (any(duplicated(t(grille)))) return(FALSE)

  return(TRUE)
}

#' Vérifie qu'une grille partiellement remplie est correcte
#' @param grille La grille partielle
#' @param solution La solution
#' @return TRUE/FALSE
#' @export
verifier_grille_partielle <- function(grille, solution) {
  taille <- nrow(grille)

  if (!all(grille[!is.na(grille)] == solution[!is.na(grille)])) return(FALSE)

  for (i in 1:taille) {
    ligne <- grille[i,]
    if (sum(!is.na(ligne)) >= 3) {
      r <- rle(ligne[!is.na(ligne)])
      if (any(r$lengths > 2)) return(FALSE)
    }

    colonne <- grille[,i]
    if (sum(!is.na(colonne)) >= 3) {
      r <- rle(colonne[!is.na(colonne)])
      if (any(r$lengths > 2)) return(FALSE)
    }
  }

  return(TRUE)
}
