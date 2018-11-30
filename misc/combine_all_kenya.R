library(dplyr)
library(vida)
library(readstata13)

kenya_files <- dir('../data_original/Kenya/NEW_DATA/', recursive = T)
kenya_files <- kenya_files[grepl('.dta', kenya_files, fixed = TRUE)]

# Read in all files, attempt to translate, and aggregate
out_list <- list()
for(i in 1:length(kenya_files)){
  message(i)
  this_file <- kenya_files[i]
  this_path <- paste0('../data_original/Kenya/NEW_DATA/', this_file)
  this_data <- read.dta13(this_path)
  this_format <- detect_format(this_data)
  translated <- translate(this_data) 
  translated$input_file_path <- this_path
  out_list[[i]] <- data.frame(translated)
}
for(i in 1:length(out_list)){
  message(i)
  x <- out_list[[i]]
  out_list[[i]] <- mutate_all(x, as.character)
}
out <- bind_rows(out_list)
readr::write_csv(out, 'out.csv')
