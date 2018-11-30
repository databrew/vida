library(usethis)
library(readr)
library(tidyverse)
library(readstata13)
use_data_raw()

# Read in kenya translation dictionaries
files <- dir('../kenya/')
out <- list()
for(i in 1:length(files)){
  message('file ', i, ' of ', length(files))
  this_file <- files[i]
  this_format <- gsub('_map.csv', '', this_file, fixed = TRUE)
  this_data <- read_csv(paste0('../kenya/', 
                               this_file)) %>%
    mutate(country = 'kenya') %>%
    mutate(format = this_format)
  # remove extra columns
  xs <- substr(names(out), 1,1) == 'X'
  if(length(xs) > 0){
    if(any(xs)){
      this_data <- this_data[,!xs]
    }
  }
  out[[i]] <- this_data
}
mapper_kenya <- bind_rows(out)
# usethis::use_data(mapper, overwrite = TRUE)


# Read in mali translation dictionaries
files <- dir('../mali_data/', recursive = T)
files <- files[grepl('csv', files) & grepl('map', files)]
out <- list()
for(i in 1:length(files)){
  message('file ', i, ' of ', length(files))
  this_file <- files[i]
  this_format <- gsub('_map.csv', '', this_file, fixed = TRUE)
  this_format <- strsplit(this_format, '/', fixed = T)
  this_format <- unlist(lapply(this_format, function(x){x[2]}))
  this_data <- read_csv(paste0('../mali_data/', 
                               this_file)) %>%
    mutate(country = 'mali') %>%
    mutate(format = this_format)
  # remove extra columns
  xs <- substr(names(out), 1,1) == 'X'
  if(length(xs) > 0){
    if(any(xs)){
      this_data <- this_data[,!xs]
    }
  }
  out[[i]] <- this_data
}
mapper_mali <- bind_rows(out)
mapper <- 
  bind_rows(mapper_mali,
            mapper_kenya)
usethis::use_data(mapper, overwrite = TRUE)


# Create fake data
fake <- readstata13::read.dta13('../data_original/Kenya/WHO2010_FORM2.dta')
# Anonymize
fake <- data.frame(fake)
for(j in 1:ncol(fake)){
  values <- sort(unique(fake[,j]))
  fake[,j] <- sample(values, nrow(fake), replace = T)
}
usethis::use_data(fake, overwrite = TRUE)

fake <- readxl::read_excel('../data_original/Mali/child_Mali.xlsx')
# Anonymize
fake <- data.frame(fake)
for(j in 1:ncol(fake)){
  message(j)
  values <- sort(unique(fake[,j]))
  if(is.null(values) | length(values) == 0){
    values <- rep(NA, nrow(fake))
  }
  fake[,j] <- sample(values, nrow(fake), replace = T)
}
fake_mali <- fake
usethis::use_data(fake_mali, overwrite = TRUE)

# Write csv of babel
write_csv(mapper, 'babel.csv')
