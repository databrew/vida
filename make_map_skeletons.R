library(tidyverse)

# Define function for generating complete set of question answers
extract_categories <- function(temp_dat){
  x<- as.data.frame(temp_dat)
  
  message('Succesfully read in data. It looks like this')
  print(head(x))
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
  final <- bind_rows(total_list)
  return(final)
}

temp <- extract_categories(who2016)

# Define which files we're using
files <- dir('data', recursive = TRUE)
files <- files[!grepl('pdf', files)]
files <- files[!grepl('xml', files)]
files <- files[!grepl('doc', files)]
files <- files[!grepl('Translation_Template', files)]


# For now, just doing  Mali
files <- files[grepl('Mali', files)]
files <- paste0('data/', files)

# child_Mali.xlsx, CRF22_09JUL2008 - VRG.pdf, CRF23_28JAN2009 - VRG.pdf, and neonate_Mali.xlsx are all from GEMS, so I think of them as “GEMS-era” VAs.  CHAMPS is a child mortality study that started in Mali in 2016, and so everything with “CHAMPS” in the name is related to CHAMPS-era VAs.  In between GEMS and CHAMPS, VAs were collected solely for VIDA, so I think of those as VIDA-era and they include “Verbal Autopsy Death of a child 4 weeks to 59 months_Final_23AUG2018.xlsx” and “Verbal Autopsy Death of a child under 4 weeks_Final_23AUG2018.xlsx.”

# For now, just doing champs mali (first milestone)
files <- files[grepl('champs', tolower(files))]
# Since they're all versions of the same, keep only 1
files <- files[1]
final_list <- list()
for(ff in 1:length(files)){
  message(ff, ' of ', length(ff), '; ', files[ff])
  the_file <- files[ff]
  out <- extract_categories(file = the_file)
  final_list[[ff]] <- out
}
final <- bind_rows(final_list)
final <- final %>%
  # dplyr::select(-file) %>%
  dplyr::distinct(file, variable, variable_type, responses, .keep_all = TRUE)

write_csv(final, 'mappers/mali_champs.csv')
