#' Detect format
#' 
#' Detect the input format of a raw dataset
#' @param df a dataframe of raw data
#' @param country a country. If null, all countries will be considered.
#' @param mapper A dictionary dataframe (expected to be mapper from the vida library)
#' @return a dataframe
#' @import dplyr
#' @export

detect_format <- function(df,
                          country = NULL,
                      mapper = NULL){
  
  # Check to see that a mapper is provided.
  # If not, use the one from the package (default)
  if(is.null(mapper)){
    mapper <- vida::mapper
  }
  
  # Subset for country if relevant
  if(!is.null(country)){
    the_country <- country
    mapper <- mapper %>%
      filter(country == the_country)
    if(nrow(mapper) == 0){
      stop('There are no data in the dictionary for ', country, '.')
    }
  }
  
  # Get unique list of formats
  formats <- sort(unique(mapper$format))
  
  # Get variable names of input
  v_names <- sort(unique(names(df)))

  # Go through possible matches and get matches
  out_list <- list()
  for(i in 1:length(formats)){
    this_format <- formats[i]
    this_dict <- mapper %>%
      filter(format == this_format)
    matched_names <- v_names %in% this_dict$variable
    if(any(matched_names)){
      p_names <- length(which(matched_names)) / length(v_names)
    } else {
      p_names <- 0
    }
    if(p_names > 0){
      # Go through each column and get a matching levels score
      p_list <- list()
      counter <- 0
      for(j in which(matched_names)){
        counter <- counter + 1
        # What is the variable
        this_name <- v_names[j]
        # What are the levels in the dict
        sub_dict <- this_dict %>% filter(variable == this_name) 
        # Is it categorical
        categorical <- sub_dict$variable_type[1] == 'Categorical'
        if(categorical){
          # What are the levels in the raw data
          raw_levels <- as.character(sort(unique(df[,this_name])))
          # What are the levels in the dict data
          dict_levels <- as.character(sort(unique(sub_dict$responses)))
          # What is the degree of containment
          contained <- raw_levels %in% dict_levels
          n <- length(which(contained))
          d <- length(contained)
          p <- n/d
        } else {
          p <- 1
        }
        p_list[[counter]] <- p
      }
      final_p <- mean(unlist(p_list), na.rm = TRUE)
    } else {
      final_p <- 0
    }
    
    out_list[[i]] <-
      data_frame(variable_score = p_names,
                 category_score = final_p)
  }
  out <- bind_rows(out_list) %>%
    mutate(index = 1:length(variable_score)) %>%
    arrange(desc(variable_score))
   
  message('The raw input data were run against ',
          length(formats), ' dictionaries. The best match was:\n ',
          formats[out$index[1]],
          '\nwhich contained ',
          round(100 * out$variable_score[1], digits = 2),
          '% of the variables in the raw data, and among those variables had a ',
          'category matching percentage of approximately ',
          round(100 * out$category_score[1], digits = 2), ' %.')
  return(formats[out$index[1]])
  
}
