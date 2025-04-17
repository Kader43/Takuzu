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





