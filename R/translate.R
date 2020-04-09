#' Translate
#' 
#' Translate raw data from a site format to babel
#' @param df a dataframe of raw data
#' @param input_format the format of the raw data
#' @param mapper A dictionary dataframe (expected to be mapper from the vida library)
#' @return a dataframe
#' @import dplyr
#' @export

translate <- function(df,
                      input_format = NULL,
                      mapper = NULL){
  
  # Check to see that a mapper is provided.
  # If not, use the one from the package (default)
  if(is.null(mapper)){
    mapper <- vida::mapper
  }
  
  # Check to see that the format conforms
  formats <- sort(unique(mapper$format))
  if(!is.null(input_format)){
    if(!input_format %in% formats){
      stop(paste0('The input_format provided, "',
                  input_format, 
                  '", does not conform with any of the possible input_formats in the data dictionaries. Options are:\n',
                  paste0('-"',formats,'"', collapse = '\n')))
    }
  } else {
    # If the input_format is null, try to detect
    input_format <- detect_format(df = df,
                                  country = NULL,
                                  mapper = NULL)
  }
  
  # Having identified the correct format, now translate the data
  # the_dict <- mapper %>% filter(format == input_format) # ORIGINAL
  the_dict <- mapper
  
  categories_counter <- 0
  column_counter <- 0
  
  for(j in 1:ncol(df)){
    this_name <- names(df)[j]
    if(this_name %in% the_dict$variable){
      column_counter <- column_counter + 1
      sub_dict <- the_dict %>% filter(variable == this_name) %>%
        dplyr::distinct(responses, .keep_all = TRUE)
      new_name <- sub_dict$question_standardized[1]
      categorical <- sub_dict$variable_type[1] == 'Categorical'
      if(categorical){
        categories_counter <- categories_counter + 1
        # NEW subset subdict by values in new_values
        new_values <- data_frame(responses = 
                                    as.character(data.frame(df)[,j]))
        sub_dict <- sub_dict %>% filter(responses %in% unique(new_values$responses))
        new_values <- left_join(new_values, sub_dict,by = 'responses') %>%
          dplyr::select(responses,
                        response_standardized)
        df[,j] <- new_values$response_standardized
      }
      names(df)[j] <- new_name
    }
  }
  message(paste0('Of ', ncol(df), ' variables:\n', ' ', column_counter, ' were identified in the dictionary and underwent a name change;\n', ' ', categories_counter, ' were categorical variables and underwent categorical changes.'))
  return(data.frame(df))
}  

