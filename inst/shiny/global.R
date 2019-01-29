library(vida)
# source('../../R/translate.R')
# source('../../R/detect_format.R')

formats <- sort(unique(vida::mapper$format))

# Create a dictionary of tab names / numbers
tab_dict <- data_frame(number = 1:4,
                       name = c('main',
                                'output',
                                'babel',
                                'about'))
n_tabs <- nrow(tab_dict)

withConsoleRedirect <- function(containerId, expr) {
  # Change type="output" to type="message" to catch stderr
  # (messages, warnings, and errors) instead of stdout.
  txt <- capture.output(results <- expr, type = "output")
  if (length(txt) > 0) {
    insertUI(paste0("#", containerId), where = "beforeEnd",
             ui = paste0(txt, "\n", collapse = "")
    )
  }
  results
}