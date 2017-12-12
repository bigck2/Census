library(tidyverse)


# Relevant Variables Selection

# Age histogram
# Median Age
# % Married
# Household Income histogram
# Median Household Income



library(tidycensus)
census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")
v15 <- load_variables(2016, "acs1", cache = TRUE)

View(v15)



B01002_001E
Estimate!!Median age!!Total


med_age <- get_acs(geography = "state", variables = "B01002_001")


age <- get_acs(geography = "state", table = "B01001", survey = "acs1", year = 2016)

age %>% filter(NAME == "Texas")



my_vec <- c(median_age = "B01002_001E",
            median_age_male = "B01002_002E",
            median_age_female = "B01002_003E",
            total_population = "B01003_001E")

my_vec <- c(commute_total = "B08012_001E",
            commute_less_5_min = "B08012_002E",
            commute_5_to_9_min = "B08012_003E",
            commute_10_to_14_min = "B08012_004E",
            commute_15_to_19_min = "B08012_005E",
            commute_20_to_24_min = "B08012_006E",
            commute_25_to_29_min = "B08012_007E",
            commute_30_to_34_min = "B08012_008E",
            commute_35_to_39_min = "B08012_009E",
            commute_40_to_44_min = "B08012_010E",
            commute_45_to_59_min = "B08012_011E",
            commute_60_to_89_min = "B08012_012E",
            commute_90_min_or_more = "B08012_013E"
            )


tx <- get_acs(geography = "state", variables = my_vec)

tx <- tx %>% filter(NAME == "Texas")

tx

my_vec[tx$variable]










