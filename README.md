# Jeu Takuzu (Binairo) - Package R avec Application Shiny

##  Introduction

Ce projet propose à la fois :

- Une **bibliothèque R** permettant de générer et valider des grilles de Takuzu.
- Une **application Shiny interactive** pour jouer directement au jeu.

Tout est regroupé dans un **package R prêt à l'emploi**, disponible sur GitHub.

---

##  Objectifs

- Développer une bibliothèque R robuste pour le Takuzu (génération + validation).
- Créer une interface Shiny simple et intuitive pour jouer.
- Proposer un dépôt GitHub clair, bien structuré et documenté.

---

##  Qu'est-ce que le Takuzu (Binairo) ?

Le **Takuzu**, ou **Binairo**, est un jeu de logique qui se joue sur une grille carrée (généralement 6x6 ou 8x8).  
Le but est de remplir la grille avec des `0` et des `1` en respectant les règles suivantes :

1. Chaque case contient un `0` ou un `1`.
2. Chaque ligne et chaque colonne doit contenir **autant de `0` que de `1`**.
3. Pas plus de **deux `0` ou deux `1` consécutifs** dans une ligne ou colonne.
4. Deux lignes ou deux colonnes **identiques sont interdites**.

---

##  Installation & Lancement

### 1.Installer le package depuis GitHub

Si ce n’est pas déjà fait, installez "remotes" puis installez le package :
```r
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("Kader43/Takuzu")
```

### 2.Lancer l'applicaton Shiny
Une fois le package installé, utilisez :
```{r}
library(takuzuR)
takuzuR::run_app()
```

### 3. Lancer l'application en mode développement
Si vous travaillez depuis le code source (par exemple après un git clone).
Placez-vous dans le dossier racine du package (là où se trouve DESCRIPTION).
1.Chargez le package en mode développement :
```{r}
devtools::load_all()
```

Lancez l'application Shiny :

```{r}
shiny::runApp("inst/shiny-app")
```


