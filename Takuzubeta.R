# La taille de la matrice 
taille_matrice <- 6

#  Validation des lignes et colonnes

ligne_valide_simple <- function(ligne) {
  if (sum(ligne == 0) > 3 || sum(ligne == 1) > 3) return(FALSE)
  for (i in 1:(length(ligne) - 2)) {
    if (!is.na(ligne[i]) && ligne[i] == ligne[i+1] && ligne[i] == ligne[i+2]) return(FALSE)
  }
  return(TRUE)
}

# Générateur de grille Takuzu complète

generer_grille_complete_logique <- function() {
  grille <- matrix(NA, nrow = taille_matrice, ncol = taille_matrice)
  lignes_existantes <- list()
  for (i in 1:taille_matrice) {
    valide <- FALSE
    essais <- 0
    while (!valide && essais < 1000) {
      ligne <- sample(rep(0:1, 3))
      if (!ligne_valide_simple(ligne)) { essais <- essais + 1; next }
      if (any(sapply(lignes_existantes, function(l) all(l == ligne)))) {
        essais <- essais + 1; next
      }
      grille[i, ] <- ligne
      lignes_existantes[[length(lignes_existantes)+1]] <- ligne
      valide <- TRUE
    }
  }
  for (j in 1:taille_matrice) {
    col <- grille[, j]
    if (!ligne_valide_simple(col) || sum(col == 0) != 3 ||
        any(duplicated(apply(grille[, j, drop=FALSE], 2, paste, collapse="")))) {
      return(generer_grille_complete_logique())
    }
  }





