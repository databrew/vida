# This script is purely for examining vida data for milestones paper.
library(readstata13)
library(xlsx)

#--------------------------------------------------------------
# MALI
# get xlsx file location
xlsx_files <- list.files('data/Mali', full.names = T)
xlsx_files <- xlsx_files[!grepl('.pdf', xlsx_files, fixed = TRUE)]
# get vector of file names 
data_list <- list()
for(i in 1:length(xlsx_files)) {
  data_list[[i]] <- read.xlsx2(xlsx_files[i], sheetIndex = 1)
  the_data <- data_list[[i]]
  name_of_data <- xlsx_files[1]
  
  print(i)
  
}


# get dta file location
dta_files <- list.files('data/Kenya')
dta_files <- dta_files[grepl('.dta', dta_files, fixed = TRUE)]

# get vector of file names 
data_list <- list()
for(i in 1:length(dta_files)) {
  the_data <- read.dta13(paste0('Kenya/', dta_files[i]))
  name_of_vars <- as.data.frame(colnames(the_data))
  name_of_vars$data_set <- dta_files[i]
  names(name_of_vars) <- c('variable', 'data_set')
  name_of_vars <- name_of_vars[, c('data_set', 'variable')]
  
  data_list[[i]] <- name_of_vars
  print(i)
  
}

temp_dat <- do.call('rbind', data_list)


write.csv(temp_dat, 'kenya_list.csv')

allVA.dta <- data_list[[1]]
Coded_VA_childtables_legacy.dta <- data_list[[2]]
Coded_VA_symptoms_lastillness1_f1.dta <- data_list[[3]]
Coded_VA_symptoms_lastillness1_f2.dta <- data_list[[4]]
Coded_VA_symptoms_lastillness2_f2.dta <- data_list[[5]]
Coded_VA_treatment_healthrecords_f1.dta <- data_list[[6]]
Coded_VA_tretreatment_healthrecords_f2.dta <- data_list[[7]]
Coded_VA_uploadvachild_v8pt1.dta <- data_list[[8]]
Coded_VA_uploadvachild_v8pt2.dta <- data_list[[9]]
Coded_VA_uploadva_v7pt1.dta <- data_list[[10]]
Coded_VA_uploadva_v7pt2.dta <- data_list[[11]]
DSSVA_CLEAN_f1_symptoms_lastillness1.dta <- data_list[[12]]
DSSVA_CLEAN_f1_symptoms_lastillness2.dta <- data_list[[13]]
DSSVA_CLEAN_f2f3_f2f3_Previous_medical_condition1.dta <- data_list[[14]]
DSSVA_CLEAN_f2f3_Previous_medical_condition.dta <- data_list[[15]]
DSSVA_CLEAN_Treatment_Operation.dta <- data_list[[16]]
DSSVA_CLEAN_Treatment_Type.dta <- data_list[[17]]
DSSVA_NEW_CLEAN_f1_symptoms_lastillness1.dta <- data_list[[18]]
DSSVA_NEW_CLEAN_f1_symptoms_lastillness.dta <- data_list[[19]]
DSSVA_NEW_CLEAN_f2f3_Previous_medical_condition1.dta <- data_list[[20]]
DSSVA_NEW_CLEAN_f2f3_Previous_medical_condition.dta <- data_list[[21]]
DSSVA_NEW_CLEAN_f2_symptoms_lastillness1.dta <- data_list[[22]]
DSSVA_NEW_CLEAN_f2_symptoms_lastillness2.dta <- data_list[[23]]
DSSVA_NEW_CLEAN_Treatment_Type.dta <- data_list[[24]]
VA_legacy.dta <- data_list[[25]]
WHO_2007FM1.dta <- data_list[[26]]
WHO_2007FM2.dta <- data_list[[27]]
WHO2010_FORM1.dta <- data_list[[28]]
WHO2010_FORM2.dta <- data_list[[29]]
WHO2012_FORM1.dta <- data_list[[30]]
WHO2012_FORM2.dta <- data_list[[31]]


# 400 variables without coding - personnel moved away. 
# match each form question with variable
# id each question - which ones are relevant. 
# 


 