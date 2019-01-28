### read in all mapping files to extract unique question_standardized variables to create master dictionary ### 

library(readr)
library(reshape2)
library(dplyr)

setwd('vida_mapped')
d1 <- read.csv('c08_12_map.csv')
d1$data_name <- 'c08_12_map.csv'
names_d1 <- names(d1)

d2 <- read.csv('c2012_map.csv')
d2$data_name <- 'c2012_map.csv'
d2$X <- NULL

d3 <- read.csv('c2016_map.csv')
d3$data_name <- 'c2016_map.csv'
names(d3) <- names_d1

d4 <- read.csv('champs2_map.csv')
d4$data_name <- 'champs2_map.csv'

d5 <- read.csv('child_mali_map.csv')
d5$data_name <- 'child_mali_map.csv'

d6 <- read.csv('core_2_map.csv')
d6$data_name <- 'core_2_map.csv'

d7 <- read.csv('core_map.csv')
d7$data_name <- 'core_map.csv'

d8 <- read.csv('n08_12_map.csv')
d8$data_name <- 'n08_12_map.csv'

d9 <- read.csv('n2012_map.csv')
d9$data_name <- 'n2012_map.csv'

d10 <- read.csv('n2016_map.csv')
d10$data_name <- 'n2016_map.csv'

d11 <- read.csv('neonate_mali_map.csv')
d11$data_name <- 'neonate_mali_map.csv'

d12 <- read.csv('va_4_weeks_to_59_months_map.csv')
d12$data_name <- 'va_4_weeks_to_59_months_map.csv'

d13 <- read.csv('va_under_4_weeks_map.csv')
d13$data_name <- 'va_under_4_weeks_map.csv'

d14 <- read.csv('who2007_2_map.csv')
d14$data_name <- 'who2007_2_map.csv'

d15 <- read.csv('who2007_map.csv')
d15$data_name <- 'who2007_map.csv'

d16 <- read.csv('who2010_map.csv')
d16$data_name <- 'who2010_map.csv'

d17 <- read.csv('who2012_2_map.csv')
d17$data_name <- 'who2012_2_map.csv'

d18 <- read.csv('who2012_map.csv')
d18$data_name <- 'who2012_map.csv'

d19 <- read.csv('who2016_map.csv')
d19$data_name <- 'who2016_map.csv'


data_list <- list()

data_list[[1]] <- d1
data_list[[2]] <- d2
data_list[[3]] <- d3
data_list[[4]] <- d4
data_list[[5]] <- d5
data_list[[6]] <- d6
data_list[[7]] <- d7
data_list[[8]] <- d8
data_list[[9]] <- d9
data_list[[10]] <- d10
data_list[[11]] <- d11
data_list[[12]] <- d12
data_list[[13]] <- d13
data_list[[14]] <- d14
data_list[[15]] <- d15
data_list[[16]] <- d16
data_list[[17]] <- d17
data_list[[18]] <- d18
data_list[[19]] <- d19

# collapse the list
dat <- do.call('rbind', data_list)
dat$paste_var <- paste0(dat$question_standardized, '_', dat$data_name)
dat <- dat[!duplicated(dat$paste_var),]
dat$paste_var <- NULL
dat <- dat[, c('question_standardized', 'variable_type', 'data_name')]

write.csv(dat, 'unique_dictionary.csv')
