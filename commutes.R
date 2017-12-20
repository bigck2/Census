library(tidyverse)
library(stringr)
library(tidycensus) # to pull census data

census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


my_vec <- c(commute_aggregate_min = "B08013_001",
            commute_total = "B08012_001")

# aggregate_commute_time
commute <- get_acs(geography = "us", 
                    variables = my_vec, 
                    survey = "acs5", 
                    year = 2010, 
                    summary_var = "B08012_001")






# add variable names ------------------------------------------------------



# Create a named vector (opposite of my_vec) (a lookup vector)
my_vec_lookup <- names(my_vec)
names(my_vec_lookup) <- my_vec

# Index the lookup table / vector by the variable column 
commute$var <- my_vec_lookup[commute$variable]


# Calc average commute
commute <- commute %>% 
           mutate(avg_commute = estimate / summary_est)



View(commute)





# by MSA ------------------------------------------------------------------


my_vec <- c(commute_aggregate_min = "B08013_001")
            

msa_commute <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area", 
                       variables = my_vec, 
                       survey = "acs5", 
                       year = 2016, 
                       summary_var = "B08012_001")


# Calc average commute
msa_commute <- msa_commute %>% 
               mutate(avg_commute = estimate / summary_est) %>%
               arrange(desc(avg_commute))

View(msa_commute)


