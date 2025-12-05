#' General population utilities
#'
#' @docType data
#'
#' @format A data table (age, sex, GenPop_utility).
#'
#' @source Published parameter values describing health state utility values by age and sex by \insertCite{Ara2010;textual}{qalyr}.
#'
#' @references
#' \insertRef{Ara2010}{qalyr}
#'
"GenPopUtil"


#' General population utilities (EQ-5D-3L)
#'
#' Parameters describing health state utility values by age and sex, originally 
#' estimated by [Ara and Brazier (2010)](https://www.sciencedirect.com/science/article/pii/S1098301510600903?via%3Dihub)
#' and updated with new analysis of Health Survey for England 2018 data.
#'
#' @format A data table (age, sex, GenPop_utility)
"GenPopUtil_2018_3L"

#' General population utilities (EQ-5D-5L)
#'
#' Parameters describing health state utility values by age and sex, originally 
#' estimated by [Ara and Brazier (2010)](https://www.sciencedirect.com/science/article/pii/S1098301510600903?via%3Dihub)
#' and updated with new analysis of Health Survey for England 2018 data.
#'
#' @format A data table (age, sex, GenPop_utility)
"GenPopUtil_2018_5L"


#' Utility function coefficients (EQ-5D-3L)
#'
#' [Ara and Brazier (2010)](https://www.sciencedirect.com/science/article/pii/S1098301510600903?via%3Dihub)
#' regression model coefficients with EQ-5D-3L utilities as the outcome and 
#' age, age squared, and sex as explanatory variables. 
#' 
#'
#' @format A named numeric vector 
"coefs"


#' Utility function coefficients 2018 (EQ-5D-3L)
#'
#' Updated [Ara and Brazier (2010)](https://www.sciencedirect.com/science/article/pii/S1098301510600903?via%3Dihub)
#' regression model coefficients using Health Survey for England 2018 data with EQ-5D-3L utilities as the outcome and 
#' age, age squared, and sex as explanatory variables. 
#' 
#'
#' @format A named numeric vector 
"coefs_2018_3L"

#' Utility function coefficients 2018 (EQ-5D-5L)
#'
#' Updated [Ara and Brazier (2010)](https://www.sciencedirect.com/science/article/pii/S1098301510600903?via%3Dihub)
#' regression model coefficients using Health Survey for England 2018 data with EQ-5D-5L utilities as the outcome and 
#' age, age squared, and sex as explanatory variables. 
#'
#' @format A named numeric vector 
"coefs_2018_5L"