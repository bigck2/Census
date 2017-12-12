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




# Key Stats ---------------------------------------------------------------


my_vec <- c(median_age = "B01002_001",
            median_age_male = "B01002_002",
            median_age_female = "B01002_003",
            total_population = "B01003_001"
            )

my_vec <- c(commute_total = "B08012_001",
            commute_less_5_min = "B08012_002",
            commute_5_to_9_min = "B08012_003",
            commute_10_to_14_min = "B08012_004",
            commute_15_to_19_min = "B08012_005",
            commute_20_to_24_min = "B08012_006",
            commute_25_to_29_min = "B08012_007",
            commute_30_to_34_min = "B08012_008",
            commute_35_to_39_min = "B08012_009",
            commute_40_to_44_min = "B08012_010",
            commute_45_to_59_min = "B08012_011",
            commute_60_to_89_min = "B08012_012",
            commute_90_min_or_more = "B08012_013"
            )

my_vec <- c(own_child_total = "B09002_001",
            own_child_married_couple = "B09002_002",
            own_child_other_families = "B09002_008",
            own_child_father_only = "B09002_009",
            own_child_mother_only = "B09002_015"
            )

my_vec <- c(school_tot_pop = "B14001_001",
            school_enrolled_school = "B14001_002",
            school_enrolled_preshcool = "B14001_003",
            school_enrolled_kinder = "B14001_004",
            school_enrolled_1_to_4 = "B14001_005",
            school_enrolled_5_to_8 = "B14001_006",
            school_enrolled_9_to_12 = "B14001_007",
            school_enrolled_college = "B14001_008",
            school_enrolled_grad_school = "B14001_009",
            school_not_enrolled = "B14001_010"
            )


my_vec <- c(edu_pop_total = "B15003_001",
            edu_12th_grade_no_diploma = "B15003_016",
            edu_hs_diploma = "B15003_017",
            edu_GED = "B15003_018",
            edu_some_college_less_than_1_yr = "B15003_019",
            edu_some_college_more_than_1_yr = "B15003_020",
            edu_associates = "B15003_021",
            edu_bachelors = "B15003_022",
            edu_masters = "B15003_023",
            edu_prof_degree = "B15003_024",
            edu_doct_degree = "B15003_025"
            )

my_vec <- c(work_pop = "B23025_001",
            work_in_labor_force = "B23025_002",
            work_in_civilian_labor_force = "B23025_003", # Note this should be used to calc unemploy
            work_employed = "B23025_004",
            work_unemployed = "B23025_005",
            work_labor_armed_forces = "B23025_006",
            work_not_in_labor_force = "B23025_007")


my_vec <- c(housing_units = "B25001_001",
            occ_stat_total = "B25002_001",
            occ_stat_occupied = "B25002_002",
            occ_stat_vacant = "B25002_003",
            tenure_total = "B25003_001", # Note this only includes occupied housing units
            tenure_owner_occupied = "B25003_002",
            tenure_renter_occupied = "B25003_003")

my_vec <- c(tenure_by_edu_total = "B25013_001",
            tenure_by_edu_owner_total = "B25013_002",
            tenure_by_edu_owner_less_than_hs = "B25013_003",
            tenure_by_edu_owner_hs_grad = "B25013_004",
            tenure_by_edu_owner_some_college_assoc = "B25013_005",
            tenure_by_edu_owner_bachelor_or_more = "B25013_006",
            tenure_by_edu_renter_total = "B25013_007",
            tenure_by_edu_renter_less_than_hs = "B25013_008",
            tenure_by_edu_renter_hs_grad = "B25013_009",
            tenure_by_edu_renter_some_college_assoc = "B25013_010",
            tenure_by_edu_renter_bachelor_or_more = "B25013_011"
            )







# Actually pull the data --------------------------------------------------

tx <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016)

tx <- tx %>% filter(NAME == "Texas")




# How to add a variable name ----------------------------------------------

# Create a named vector (opposite of my_vec) (a lookup vector)
my_vec_lookup <- names(my_vec)
names(my_vec_lookup) <- my_vec

# Index the lookup table / vector by the variable column 
tx$var <- my_vec_lookup[tx$variable]

View(tx)




# Include Percent ---------------------------------------------------------

tx <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016, 
              summary_var = "B15003_001")


tx <- tx %>% filter(NAME == "Texas")

tx <- tx %>%
      select(-moe, -summary_moe) %>%
      mutate(percent = estimate / summary_est * 100)





















