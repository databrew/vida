
setwd("/Users/xing/Documents/NEW_DATA/")


library(readstata13)
library(foreign)
library(dplyr)
library(reshape2)

# load stata files
who2016 <- read.dta13('WHO 2016/WHO_2016.dta', convert.factors = TRUE, missing.type = TRUE)
who2012 <- read.dta13('WHO 2012 Form 1/WHO_2012_form1.dta', convert.factors = TRUE, missing.type = TRUE)
who2012_2 <- read.dta13('WHO 2012 Form 2/WHO_2012_form2.dta', convert.factors = TRUE, missing.type = TRUE)
who2010 <- read.dta13('WHO 2010 Form 1/WHO_2010_form1.dta', convert.factors = TRUE, missing.type = TRUE)
who2010_2 <- read.dta13('WHO 2010 Form 2/WHO_2010_form2.dta', convert.factors = TRUE, missing.type = TRUE)
who2007 <- read.dta13('WHO 2007 Form 1/WHO_2007_form1.dta', convert.factors = TRUE, missing.type = TRUE)
who2007_2 <- read.dta13('WHO 2007 Form 2/WHO_2007_form2.dta', convert.factors = TRUE, missing.type = TRUE)
core <- read.dta13('Core Form 1/COREI_form1.dta', convert.factors = TRUE, missing.type = TRUE)
core_2 <- read.dta13('Core Form 2/COREI_form2.dta', convert.factors = TRUE, missing.type = TRUE)

who2016 <- as.data.frame(who2016, stringsAsFactors = TRUE)

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

who2012<- extract_categories(who2012)
who2012_2 <- extract_categories(who2012_2) 
who2010 <- extract_categories(who2010)
who2010_2 <- extract_categories(who2010_2)
who2007 <- extract_categories(who2007)
who2007_2 <- extract_categories(who2007_2)
core <- extract_categories(core)
core_2 <- extract_categories(core_2)

#### save as csvs ###
write.csv(who2016, 'who2016.csv')
write.csv(who2012, 'who2012a.csv')
write.csv(who2012_2, 'who2012_2a.csv')
write.csv(who2010, 'who2010.csv')
write.csv(who2010_2, 'who2010_2.csv')
write.csv(who2007, 'who2007.csv')
write.csv(who2007_2, 'who2007_2b.csv')
write.csv(core, 'core.csv')
write.csv(core_2, 'core_2.csv')