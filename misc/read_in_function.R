library(devtools)
library(databrew)
library(vida)
library(dplyr)
library(reshape2)
library(readr)

##### MALI #######

setwd('mali_data')

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

#################################################

### GAMBIA ### 

setwd('/Users/xing/Documents/gambia/bn_hdss')

#read in files
c2016 <- read_csv('VA_Child_WHO2016.csv')
c2012 <- read_csv('VA_ChildForm_WHO2012.csv')
n2016 <- read_csv('VA_Neonates_WHO2016.csv')
n2012 <- read_csv('VA_Neonates_WHO2012.csv')

# make mapping skeletons
c2016_map <- vida::create_skeleton(c2016)
c2012_map <- vida::create_skeleton(c2012)
n2016_map <- vida::create_skeleton(n2016)
n2012_map <- vida::create_skeleton(n2012)

# save as csvs
write.csv(c2016_map, 'c2016_map.csv')
write.csv(c2012_map, 'c2012_map.csv')
write.csv(n2016_map, 'n2016_map.csv')
write.csv(n2012_map, 'n2012_map.csv')

setwd('/Users/xing/Documents/gambia/bs_hdss')

#read in files
c08_12 <- read_csv('VA_Child_Indepth_2008-2012.csv')
c12_16 <- read_csv('VA_Child_WHO2012-mid 2016.csv')
c16 <- read_csv('VA_Child_WHO2016.csv')
n08_12 <- read_csv('VA_Neonates_Indepth_2008-2012.csv')
n12_16 <- read_csv('VA_Neonates_WHO2012-mid-2016.csv')
n16 <- read_csv('VA_Neonates_WHO2016.csv')

# make mapping skeletons
c08_12_map <- vida::create_skeleton(c08_12)
c12_16_map <- vida::create_skeleton(c12_16)
c16_map <- vida::create_skeleton(c16)
n08_12_map <- vida::create_skeleton(n08_12)
n12_16_map <- vida::create_skeleton(n12_16)
n16_map <- vida::create_skeleton(n16)

# save as csvs
write.csv(c08_12_map, 'c08_12_map.csv')
write.csv(c12_16_map, 'c12_16_map.csv')
write.csv(c16_map, 'c16_map.csv')
write.csv(n08_12_map, 'n08_12_map.csv')
write.csv(n12_16_map, 'n12_16_map.csv')
write.csv(n16_map, 'n16_map.csv')
