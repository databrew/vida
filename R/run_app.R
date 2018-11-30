#' Run app
#' 
#' Run the Shiny web application
#' @return Web application served
#' @importFrom shiny runApp
#' @export

run_app <- function(){
  app_location <- paste0(system.file(package = 'vida'), '/shiny/app.R')
  shiny::runApp(app_location)
}
