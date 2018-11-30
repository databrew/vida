#' create_skeleton
#' 
#' Create a skeleton spreadsheet
#' @param df a dataframe of raw data
#' @return a dataframe
#' @import dplyr
#' @export

create_skeleton <- function(df){
    x<- as.data.frame(df)

    categorical_variables <- c()
    total_list <- list()
    for(column in 1:ncol(x)){
      message('---Working on column ', column, ' of ', ncol(x))
      the_levels <- unique(x[,column])
      the_levels <- the_levels[!is.na(the_levels)]
      n_levels <- length(the_levels)
      if(n_levels == 0){
        the_levels <- 'Variable with 0 responses'
      }
      if(n_levels >= 6){
        categorical <- FALSE
      } else {
        categorical <- TRUE
      }
      if(categorical){
        categories <- the_levels
      } else {
        categories <- 'Non-categorical variable'
      }
      out_list <- list()
      for(z in 1:length(categories)){
        out_list[[z]] <-
          data_frame(file = 'love_you',
                     variable = as.character(names(x)[column]),
                     variable_type = ifelse(categorical, 'Categorical', 'Non-categorical'),
                     responses = as.character(categories))
      }
      total_list[[column]] <- bind_rows(out_list)
    }
    final <- bind_rows(total_list) %>% dplyr::distinct(file, variable, variable_type, responses, .keep_all = TRUE)
    return(final)
}  

