#' Lancer l'application Shiny Takuzu
#'
#' Cette fonction lance l'application Shiny incluse dans le package.
#'
#' @export
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "takuzuR")
  if (app_dir == "") {
    stop("Impossible de trouver l'application Shiny. Vérifiez que le dossier inst/shiny-app/ existe.")
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
