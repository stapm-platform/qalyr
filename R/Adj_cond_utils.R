
#' Adjust the condition-specific utility for age and sex
#'
#' Calculates an average utility for each alcohol/tobacco-related condition by age and sex.
#' Need to calculate the mean age and proportion of males for each condition in the HODAR data.
#' Need to calculate the matched age-sex specific general population utility using the \insertCite{Ara2010;textual}{qalyr} formula. Dividing these will give the multiplier by which to adjust the
#' general population utility score by, to get age-adjusted condition-specific utilities.
#'
#' @param Age_Sex_data mean age and proportion of males for in condition in data.
#' Calculated using function \code{MeanAge_Sex()}.
#' @param Condition_utilities condition-specific utilities.
#' Calculated using function \code{CalcUtils()}.
#' @param GenPopUtil table of general population utilities by age and sex.
#' Default stored in package as \code{qalyr::GenPopUtil_2018_3L}.
#' @param Coefficients vector of regression coefficients from the EQ-5D regression
#' model applied by Ara and Brazier. Default stored in package as \code{qalyr::coefs_2018_3L} 
#'
#' @importFrom data.table := setDT
#'
#' @return Returns a summary table of condition-specific utilities.
#'
#' @references
#' \insertRef{Ara2010}{qalyr}
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' library(qalyr)
#'
#' # Merge inpatient data and HODAR data and collapse to survey level data
#' data <- qalyr::merge_data(
#'   inpatient_data = qalyr::read_inpatient_data(),
#'   survey_data = qalyr::read_survey_data(),
#'   lkup = qalyr::lkup)
#'
#' # Condition-specific utilities
#' cond_utils <- qalyr::CalcUtils(data, lkup = qalyr::lkup)
#'
#' # Mean age and proportion of males
#' mean_age_sex <- qalyr::MeanAge_Sex(data, lkup = qalyr::lkup)
#'
#' # age-sex-condition-specific utilities
#' adj_cond_utils <- qalyr::Adj_cond_utils(Age_Sex_data = mean_age_sex,
#'                                         Condition_utilities = cond_utils,
#'                                         GenPopUtil = qalyr::GenPopUtil)
#'
#' }
#'
Adj_cond_utils <- function(
    Age_Sex_data,
    Condition_utilities,
    GenPopUtil = qalyr::GenPopUtil_2018_3L,
    Coefficients = qalyr::coefs_2018_3L
  ) {

  ## Ara and Brazier 2010 coefficients hard coded
  #Age_Sex_data[ , Matched_GenPop := 0.9508566 +
  #                0.0212126 * Prop_male -
  #                0.0002587 * Av_Age -
  #                0.0000332 * (Av_Age^2)]
  
  Age_Sex_data[ , Matched_GenPop := Coefficients["intercept"] +
                  Coefficients["male"] * Prop_male +
                  Coefficients["age"] * Av_Age +
                  Coefficients["age2"] * (Av_Age^2)]

  Age_Sex_data <- merge(Age_Sex_data, Condition_utilities, by = c("condition"))

  Age_Sex_data[ , Multiplier := utility / Matched_GenPop]

  Age_Sex_data <- Age_Sex_data[ , list(condition, Multiplier)]

  domain <- data.frame(expand.grid(
    age = 11:89,
    sex = 1:2,
    condition = unique(Age_Sex_data$condition)
  ))
  setDT(domain)

  AgeSexCondUtil <- merge(domain, Age_Sex_data, by = "condition")
  AgeSexCondUtil <- merge(AgeSexCondUtil, GenPopUtil, by = c("sex", "age"))

  AgeSexCondUtil[ , ConditionUtil := Multiplier * GenPop_utility]

  AgeSexCondUtil[ , Multiplier := NULL]


  return(AgeSexCondUtil)
}









