Babel validation exercise
================

Aim
===

Create a single dataset for Kenya which contains all unique deaths (from all Kenya files). Explore that dataset so as to check for areas for potential improvement in the Babel dictionary.

Code
====

``` r
# Load some libraries
library(vida)
library(tidyverse)
library(ggplot2)
library(haven)
library(data.table)
library(databrew)

# Create a list for putting all Kenya datasets
kenya_list <- list()

# Define where all Kenya datasets are (relative to this code)
kenya_dir <- '../../data_original/Kenya/NEW_DATA/'
kenya_datasets <- dir(kenya_dir, recursive = TRUE)
kenya_datasets <- kenya_datasets[grepl('.dta', kenya_datasets, fixed = TRUE)]

# Loop through each dataset, read it into R, and put it into the list
for(i in 1:length(kenya_datasets)){
  message('Reading in dataset number ', i, ' of ', length(kenya_datasets))
  this_path <- paste0(kenya_dir, kenya_datasets[i])
  this_data <- haven::read_dta(this_path)
  this_data$dataset <- kenya_datasets[i]
  kenya_list[[i]] <- this_data
  if(i == length(kenya_datasets)){
    message('\n----------------\nAll Kenya data is now in the kenya_list object\n----------------')
  }
}

# Now create a list for storing TRANSLATED data
translated_list <- list()

# Loop through each Kenya dataset and translate
for(i in 1:length(kenya_list)){
  message(paste0('\n----\n', 
                 'Translating dataset ', i, ' of ', 
                 length(kenya_datasets), ' to Babel.',
                 '\n----\n'))

  this_data <- kenya_list[[i]]
  translated_data <- translate(df = data.frame(this_data))
  translated_list[[i]] <- translated_data
}

# Join the translated data together
joined <- data.table::rbindlist(translated_list, fill = TRUE)

# Convert back into standard dataframe format
joined <- data.frame(joined)

# Keep only those columns which appear in babel (ie, are translateable)
joined <- joined[,names(joined) %in% 
                   c(master$question_standardized, 'dataset')]

# For columns which are character and could be numeric, convert back
detect_and_convert <- function(x){
  if(class(x)[1] %in% c('character', 'factor')){
    x <- as.character(x)
    x[x == ''] <- NA
    n_nas <- length(which(is.na(x)))
  # Make numeric
  numeric_version <- as.numeric(as.character(x))
  n_nas_numeric <- length(which(is.na(numeric_version)))
  if(n_nas == n_nas_numeric){
    return(numeric_version)
  } else {
    return(x)
  }
  } else {
    return(x)
  }
}

for(j in 1:ncol(joined)){
  joined[,j] <- detect_and_convert(joined[,j])
}

# If all NAs, remove the column
remove <- c()
for(j in 1:ncol(joined)){
  if(all(is.na(joined[,j]))){
    remove <- c(remove, j)
  }
}
joined <- joined[,!(1:ncol(joined) %in% remove)]
```

Explore
=======

``` r
# Define a function to plot a variable based on its column number
plot_variable <- function(j){
  
  # Get names to be used
  variable_name <- names(joined)[j]
  babel_name <- master$question_full[master$question_standardized == variable_name]
  
  
  
  # Get the kind of variable (class)
  n <- length(unique(joined[,j]))
  variable_class <- ifelse(n >= 10,
                           'Numeric',
                           'Categorical')

  # Define a sub dataset for plotting
  sub_data <- joined %>%
    dplyr::select_(variable_name, 'dataset')
  names(sub_data)[1] <- 'var'
  
    # Convert to numeric
  if(variable_class == 'Numeric'){
    sub_data <- sub_data %>%
      mutate(var = as.numeric(as.character(var)))
  }
  
  
  # Different plot types depending on variable type
  if(variable_class == 'Categorical'){
    agg_data <- sub_data %>%
      group_by(dataset, var) %>%
      tally
    g <- ggplot(data = agg_data,
                aes(x = var,
                    y = n)) +
      geom_bar(stat = 'identity',
               fill = 'darkblue',
               alpha = 0.6) +
      facet_wrap(~dataset) +
      theme(axis.text.x = element_text(angle = 90))
  } else {
    g <- ggplot(data = sub_data,
                aes(x = var)) +
      geom_density(alpha = 0.6,
                   fill = 'darkblue') +
      facet_wrap(~dataset)
  }
  g <- g +
    theme_databrew() +
    labs(title = paste0('Standardized variable name: ', variable_name),
         subtitle = paste0('Babel meaning: ', babel_name),
         x = '',
         y = '') +
    theme(strip.text = element_text(size = 6))
  return(g)
}
```

``` r
# Write a csv
write_csv(joined, 'kenya_combined.csv')
```

``` r
# Loop through each variable and plot
n_vars <- ncol(joined)
for(j in 1:n_vars){
  if(names(joined)[j] != 'dataset'){
    message(j)
    print(plot_variable(j))
  }
}
```
