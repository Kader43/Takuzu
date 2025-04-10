# Jeu Takuzu (Binairo) - Bibliothèque R et Application Shiny

## Introduction

Votre projet consiste à créer une bibliothèque en R et une application Shiny interactive pour le jeu Takuzu. Voici un guide structuré pour organiser votre travail et gérer vos commits

## Objectifs

*   Développer une bibliothèque R robuste pour la génération et la validation de grilles de Takuzu.
*   Créer une application Shiny conviviale permettant aux utilisateurs de jouer au Takuzu.
*   Soumettre le projet sous la forme d'un dépôt GitHub clair et bien documenté.

## Description du Takuzu (Binairo)

Le Takuzu, également appelé Binairo, est un jeu de logique qui se joue sur une grille carrée (généralement 6x6 ou 8x8). Le but est de remplir la grille avec des 0 et des 1 en respectant les règles suivantes :

*   Chaque case doit contenir un 0 ou un 1.
*   Chaque ligne et chaque colonne doivent contenir le même nombre de 0 et de 1.
*   Il ne peut pas y avoir plus de deux 0 ou deux 1 consécutifs dans une ligne ou une colonne.
*   Deux lignes ou deux colonnes identiques sont interdites.

## Installation

Pour installer et exécuter ce projet, suivez ces étapes :

1.  Assurez-vous d'avoir R et RStudio installés sur votre système.
2.  Clonez ce dépôt GitHub sur votre machine locale.
3.  Ouvrez le projet dans RStudio.
4.  Installez les packages R nécessaires :

install.packages(c("shiny", "shinythemes", "shinyjs", "shinyFeedback", "takuzuR"))

   (Note : remplacez `"takuzuR"` par le nom de votre package si différent)

5.  Pour lancer l'application Shiny, exécutez la commande suivante dans la console R :

runApp("inst/shiny-app")

## Utilisation

Une fois l'application Shiny lancée, vous pouvez :

*   Sélectionner la taille de la grille (6x6 ou 8x8).
*   Cliquer sur le bouton "Nouvelle Grille" pour générer une nouvelle grille de Takuzu.
*   Remplir les cases de la grille avec des 0 et des 1.
*   Cliquer sur le bouton "Vérifier" pour vérifier si votre solution est correcte.

## Structure du projet

Le projet est organisé de la manière suivante :

*   `R/` : Contient le code source de la bibliothèque R (fonctions pour générer et valider les grilles).
*   `inst/shiny-app/` : Contient les fichiers `ui.R` et `server.R` pour l'application Shiny.
*   `app.R`: contient le code pour lancer l'application shiny
*   `README.md` : Ce fichier, qui fournit des informations sur le projet.

