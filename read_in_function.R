library(devtools)
library(databrew)
library(vida)
library(dplyr)
library(reshape2)
library(readr)

setwd('/Users/xing/Documents/vida/mali_data')

# read in 
champs1 <- read_csv('CHAMPS_Verbal_Autopsy_Form_results.csv')
champs2 <- read_csv('CHAMPS_Verbal_Autopsy_Form_v2_04_1_results.csv')
champs3 <- read_csv('CHAMPS_Verbal_Autopsy_Form_v2_04_results.csv')
va1 <- read_csv('verbal_autopsy_child.csv')
va2 <- read_csv('verbal_autopsy_under_4.csv')
cm <- read_csv('child_mali.csv')
nm <- read_csv('neonate_mali.csv')

# make mapping skeletons
champs1_map <- vida::create_skeleton(champs1)
champs2_map <- vida::create_skeleton(champs2)
champs3_map <- vida::create_skeleton(champs3)
va1_map <- vida::create_skeleton(va1)
va2_map <- vida::create_skeleton(va2)
cm_map <- vida::create_skeleton(cm)
nm_map <- vida::create_skeleton(nm)

# save as csvs
write.csv(champs1_map, 'champs1_mapa.csv')
write.csv(champs2_map, 'champs2_map.csv')
write.csv(champs3_map, 'champs3_map.csv')
write.csv(va1_map, 'va1_map.csv')
write.csv(va2_map, 'va2_map.csv')
write.csv(cm_map, 'child_mali_map.csv')
write.csv(nm_map, 'neonate_mali_map.csv')
