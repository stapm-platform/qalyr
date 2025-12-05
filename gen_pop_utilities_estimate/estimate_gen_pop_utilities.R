
### Update the Ara and Brazier (2010) regression using HSE 2018

################################
### --- Install packages --- ###

packages <- c("data.table", "tidyverse", "magrittr", "stringr", "dplyr", "plyr",
              "eq5d", "openxlsx", "curl", "git2r", "MASS", "here")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

### Install hseclean 

installed_ver <- packageVersion("hseclean")
target_ver <- "1.14.6"

if (installed_ver >= target_ver){
  
  
} else if (installed_ver < target_ver){

devtools::install_git(
  "https://github.com/stapm-platform/hseclean.git", 
  ref = "1.14.6",
  build_vignettes = FALSE, quiet = FALSE)
  
}

################################
#### --- Begin analysis --- ####

library(hseclean)
library(eq5d)
library(data.table)
library(tidyverse)

##############################
### --- Read HSE 2018 --- ####

# --------- 2018 ------------- # 

data_y <- read_2018() %>%
  clean_age() %>%
  clean_demographic() %>%
  select(hse_id, year, age, age_cat, sex, imd_quintile, 
         mobility, selfcare, usualact, pain, anxiety,
         mobility_5l, selfcare_5l, usualact_5l, pain_5l, anxiety_5l,
         wt_int)

## ----- Derive EQ-5D-5L

scores.df <- data.frame(MO = data_y$mobility_5l,
                        SC = data_y$selfcare_5l,
                        UA = data_y$usualact_5l,
                        PD = data_y$pain_5l,
                        AD = data_y$anxiety_5l)

eq5d_5l_score <- eq5d(scores.df, country = "England", version = "5L", type = "VT", ignore.invalid = TRUE)

data_y <- mutate(data_y, eq5d_5l = eq5d_5l_score)

## ----- Derive EQ-5D-3L

scores.df <- data.frame(MO = data_y$mobility,
                        SC = data_y$selfcare,
                        UA = data_y$usualact,
                        PD = data_y$pain,
                        AD = data_y$anxiety)

eq5d_3l_score <- eq5d(scores.df, country = "UK", version = "3L", type = "TTO", ignore.invalid = TRUE)

data_y <- mutate(data_y, eq5d_3l = eq5d_3l_score)


rm(scores.df, eq5d_3l_score, eq5d_5l_score)

############################################
### --- Run analysis (complete case) --- ###

data_y <- data_y %>%
  select(year, age, age_cat, sex, imd_quintile, eq5d_3l, eq5d_5l) %>%
  filter(complete.cases(.)) %>%
  mutate(sex = factor(sex, levels = c("Female","Male"))) %>%
  mutate(imd_quintile = factor(imd_quintile, levels = c("1_least_deprived","2","3","4","5_most_deprived"))) %>%
  mutate(age_cat = factor(age_cat, levels = c("16-17","18-19","20-24","25-29",
                                              "30-34","35-39","40-44","45-49",
                                              "50-54","55-59","60-64","65-69",
                                              "70-74","75-79","80-84","85-89")))

model1a <- lm(eq5d_3l ~ age + I(age^2) + sex, data = data_y)
model3a <- lm(eq5d_5l ~ age + I(age^2) + sex, data = data_y)




GenPopUtil_2018 <- expand.grid(age = 11:89,
                               sex = c("Female","Male")) %>% setDT

predict_1a <- predict(model1a, newdata = GenPopUtil_2018)
predict_3a <- predict(model3a, newdata = GenPopUtil_2018)


GenPopUtil_2018[sex == "Male", sex2 := 1]
GenPopUtil_2018[sex == "Female", sex2 := 2]
GenPopUtil_2018[, sex := sex2]
GenPopUtil_2018[, sex2 := NULL]

GenPopUtil_2018_3L <- copy(GenPopUtil_2018)
GenPopUtil_2018_5L <- copy(GenPopUtil_2018)

GenPopUtil_2018_3L[, GenPop_utility := predict_1a]
GenPopUtil_2018_5L[, GenPop_utility := predict_3a]

usethis::use_data(GenPopUtil_2018_3L, overwrite = TRUE)
usethis::use_data(GenPopUtil_2018_5L, overwrite = TRUE)

#### Save out a vector of the regression coefficients

coefs_2018_3L <- coef(model1a)
coefs_2018_5L <- coef(model3a)

names(coefs_2018_3L) <- c("intercept","age","age2","male")
names(coefs_2018_5L) <- c("intercept","age","age2","male")

coefs <- copy(coefs_2018_3L)

usethis::use_data(coefs_2018_3L, overwrite = TRUE)
usethis::use_data(coefs_2018_5L, overwrite = TRUE)


