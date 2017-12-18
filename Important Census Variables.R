library(tidyverse)
library(stringr)

# Relevant Variables Selection

# Age histogram
# Median Age
# % Married
# Household Income histogram
# Median Household Income



library(tidycensus)
census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


v16 <- load_variables(2016, "acs1", cache = TRUE)
View(v16)




# Key Stats ---------------------------------------------------------------


my_vec <- c(median_age = "B01002_001",
            median_age_male = "B01002_002",
            median_age_female = "B01002_003",
            total_population = "B01003_001"
            )


my_vec <- c(age_sex_total_pop = "B01001_001")

my_vec <- c(age_sex_total_pop_m = "B01001_002",
            age_sex_0_4_yrs_m = "B01001_003",
            age_sex_5_9_yrs_m = "B01001_004",
            age_sex_10_14_yrs_m = "B01001_005",
            age_sex_15_17_yrs_m = "B01001_006",
            age_sex_18_19_yrs_m = "B01001_007",
            age_sex_20_yrs_m = "B01001_008",
            age_sex_21_yrs_m = "B01001_009",
            age_sex_22_24_yrs_m = "B01001_010",
            age_sex_25_29_yrs_m = "B01001_011",
            age_sex_30_34_yrs_m = "B01001_012",
            age_sex_35_39_yrs_m = "B01001_013",
            age_sex_40_44_yrs_m = "B01001_014",
            age_sex_45_49_yrs_m = "B01001_015",
            age_sex_50_54_yrs_m = "B01001_016",
            age_sex_55_59_yrs_m = "B01001_017",
            age_sex_60_61_yrs_m = "B01001_018",
            age_sex_62_64_yrs_m = "B01001_019",
            age_sex_65_66_yrs_m = "B01001_020",
            age_sex_67_69_yrs_m = "B01001_021",
            age_sex_70_74_yrs_m = "B01001_022",
            age_sex_75_79_yrs_m = "B01001_023",
            age_sex_80_84_yrs_m = "B01001_024",
            age_sex_85_or_more_yrs_m = "B01001_025",
            age_sex_total_pop_f = "B01001_026",
            age_sex_0_4_yrs_f = "B01001_027",
            age_sex_5_9_yrs_f = "B01001_028",
            age_sex_10_14_yrs_f = "B01001_029",
            age_sex_15_17_yrs_f = "B01001_030",
            age_sex_18_19_yrs_f = "B01001_031",
            age_sex_20_yrs_f = "B01001_032",
            age_sex_21_yrs_f = "B01001_033",
            age_sex_22_24_yrs_f = "B01001_034",
            age_sex_25_29_yrs_f = "B01001_035",
            age_sex_30_34_yrs_f = "B01001_036",
            age_sex_35_39_yrs_f = "B01001_037",
            age_sex_40_44_yrs_f = "B01001_038",
            age_sex_45_49_yrs_f = "B01001_039",
            age_sex_50_54_yrs_f = "B01001_040",
            age_sex_55_59_yrs_f = "B01001_041",
            age_sex_60_61_yrs_f = "B01001_042",
            age_sex_62_64_yrs_f = "B01001_043",
            age_sex_65_66_yrs_f = "B01001_044",
            age_sex_67_69_yrs_f = "B01001_045",
            age_sex_70_74_yrs_f = "B01001_046",
            age_sex_75_79_yrs_f = "B01001_047",
            age_sex_80_84_yrs_f = "B01001_048",
            age_sex_85_or_more_yrs_f = "B01001_049"
            )


my_vec <- c(inc_median_household_income = "B19013_001")

my_vec <- c(hou_inc_total_pop = "B19001_001")

my_vec <- c(hou_inc_less_than_10 = "B19001_002",
            hou_inc_10_to_14 = "B19001_003",
            hou_inc_15_to_19 = "B19001_004",
            hou_inc_20_to_24 = "B19001_005",
            hou_inc_25_to_29 = "B19001_006",
            hou_inc_30_to_34 = "B19001_007",
            hou_inc_35_to_39 = "B19001_008",
            hou_inc_40_to_44 = "B19001_009",
            hou_inc_45_to_49 = "B19001_010",
            hou_inc_50_to_59 = "B19001_011",
            hou_inc_60_to_74 = "B19001_012",
            hou_inc_75_to_99 = "B19001_013",
            hou_inc_100_to_124 = "B19001_014",
            hou_inc_125_to_149 = "B19001_015",
            hou_inc_150_to_199 = "B19001_016",
            hou_inc_200_or_more = "B19001_017"
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


my_vec <- c(median_gross_rent = "B25031_001",
            median_gross_rent_0_bed = "B25031_002",
            median_gross_rent_1_bed = "B25031_003",
            median_gross_rent_2_bed = "B25031_004",
            median_gross_rent_3_bed = "B25031_005",
            median_gross_rent_4_bed = "B25031_006",
            median_gross_rent_5_bed = "B25031_007")


my_vec <- c(yr_built_total = "B25034_001",
            yr_built_2014_or_later = "B25034_002",
            yr_built_2010_to_2013 = "B25034_003",
            yr_built_2000_to_2009 = "B25034_004",
            yr_built_1990_to_1999 = "B25034_005",
            yr_built_1980_to_1989 = "B25034_006",
            yr_built_1970_to_1979 = "B25034_007",
            yr_built_1960_to_1969 = "B25034_008",
            yr_built_1950_to_1959 = "B25034_009",
            yr_built_1940_to_1949 = "B25034_010",
            yr_built_1939_or_earlier = "B25034_011",
            yr_built_median_yr_built = "B25035_001"
            )


my_vec <- c(bdrm_total = "B25041_001",
            bdrm_0_bed = "B25041_002",
            bdrm_1_bed = "B25041_003",
            bdrm_2_bed = "B25041_004",
            bdrm_3_bed = "B25041_005",
            bdrm_4_bed = "B25041_006",
            bdrm_5__or_more_bed = "B25041_007"
            )


my_vec <- c(gr_to_income_total = "B25070_001",
            gr_to_income_less_than_10 = "B25070_002",
            gr_to_income_10_to_14_9 = "B25070_003",
            gr_to_income_15_to_19_9 = "B25070_004",
            gr_to_income_20_to_24_9 = "B25070_005",
            gr_to_income_25_to_29_9 = "B25070_006",
            gr_to_income_30_to_34_9 = "B25070_007",
            gr_to_income_35_to_39_9 = "B25070_008",
            gr_to_income_40_to_49_9 = "B25070_009",
            gr_to_income_50_or_more = "B25070_010",
            gr_to_income_not_computed = "B25070_011",
            gr_to_income_median = "B25071_001"
            )

# Owner Occupied Housing Units Value
my_vec <- c(value_total = "B25075_001",
            value_less_than_10 = "B25075_002",
            value_10_to_14_9 = "B25075_003",
            value_15_to_19_9 = "B25075_004",
            value_20_to_24_9 = "B25075_005",
            value_25_to_29_9 = "B25075_006",
            value_30_to_34_9 = "B25075_007",
            value_35_to_39_9 = "B25075_008",
            value_40_to_49_9 = "B25075_009",
            value_50_to_59_9 = "B25075_010",
            value_60_to_69_9 = "B25075_011",
            value_70_to_79_9 = "B25075_012",
            value_80_to_89_9 = "B25075_013",
            value_90_to_99_9 = "B25075_014",
            value_100_to_124_9 = "B25075_015",
            value_125_to_149_9 = "B25075_016",
            value_150_to_174_9 = "B25075_017",
            value_175_to_199_9 = "B25075_018",
            value_200_to_249_9 = "B25075_019",
            value_250_to_299_9 = "B25075_020",
            value_300_to_399_9 = "B25075_021",
            value_400_to_499_9 = "B25075_022",
            value_500_to_599_9 = "B25075_023",
            value_750_to_999_9 = "B25075_024",
            value_1m_to_1_49m = "B25075_025",
            value_1_5m_to_1_9m = "B25075_026",
            value_2m_or_more = "B25075_027"
            )

# Owner Occupied value
my_vec <- c(value_lower_quartile = "B25076_001",
            value_median_value = "B25077_001",
            value_upper_quartile = "B25078_001")






# Actually pull the data --------------------------------------------------

tx <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016)

tx <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016, 
              output = "wide")

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
              summary_var = "B19001_001")


tx <- tx %>% filter(NAME == "Texas")

tx <- tx %>%
      select(-moe, -summary_moe) %>%
      mutate(percent = estimate / summary_est * 100)






# Pull in a table ---------------------------------------------------------


my_vec <- c(age_and_sex_table = "B01001")

tx <- get_acs(geography = "state", 
              table = my_vec, 
              survey = "acs1", 
              year = 2016)

tx <- tx %>% filter(NAME == "Texas")

View(tx)





# Age Manipulation --------------------------------------------------------


# Pull Data
age <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016)



# Create a named vector (opposite of my_vec) (a lookup vector)
my_vec_lookup <- names(my_vec)
names(my_vec_lookup) <- my_vec

# Index the lookup table / vector by the variable column 
age$var <- my_vec_lookup[age$variable]

rm(my_vec, my_vec_lookup)


# Add a sex variable column
age$sex <- str_sub(age$var, -1)

# drop the suffix which is moved to the sex column
age$var <- str_sub(age$var, end = -3)

# drop moe and variable columns
age <- age %>% 
        select(-moe, -variable) 
   

age <- age %>% 
       spread(key = sex, value = estimate) 


age_0_9 <- age %>%
            filter(var %in% c("age_sex_0_4_yrs", "age_sex_5_9_yrs")) %>%
            group_by(GEOID, NAME) %>%
            summarize(age_0_9_yrs_f = sum(f),
                      age_0_9_yrs_m = sum(m)) %>% 
            gather(key = "variable", value = "value", 
                   -GEOID, -NAME) %>%
            mutate(sex = str_sub(variable, start = -1),
                   variable = str_sub(variable, end = -3))


age_10_19 <- age %>%
             filter(var %in% c("age_sex_10_14_yrs", "age_sex_15_17_yrs",
                               "age_sex_18_19_yrs")) %>%
             group_by(GEOID, NAME) %>%
             summarize(age_10_19_yrs_f = sum(f),
                       age_10_19_yrs_m = sum(m)) %>% 
              gather(key = "variable", value = "value", 
                     -GEOID, -NAME) %>%
            mutate(sex = str_sub(variable, start = -1),
                   variable = str_sub(variable, end = -3))

age_20_29 <- age %>%
              filter(var %in% c("age_sex_20_yrs", "age_sex_21_yrs",
                                "age_sex_22_24_yrs", "age_sex_25_29_yrs")) %>%
              group_by(GEOID, NAME) %>%
              summarize(age_20_29_yrs_f = sum(f),
                        age_20_29_yrs_m = sum(m)) %>% 
              gather(key = "variable", value = "value", 
                     -GEOID, -NAME) %>%
              mutate(sex = str_sub(variable, start = -1),
                     variable = str_sub(variable, end = -3))

age_30_39 <- age %>%
              filter(var %in% c("age_sex_30_34_yrs", "age_sex_35_39_yrs")) %>%
              group_by(GEOID, NAME) %>%
              summarize(age_30_39_yrs_f = sum(f),
                        age_30_39_yrs_m = sum(m)) %>% 
              gather(key = "variable", value = "value", 
                     -GEOID, -NAME) %>%
              mutate(sex = str_sub(variable, start = -1),
                     variable = str_sub(variable, end = -3))


age_40_49 <- age %>%
              filter(var %in% c("age_sex_40_44_yrs", "age_sex_45_49_yrs")) %>%
              group_by(GEOID, NAME) %>%
              summarize(age_40_49_yrs_f = sum(f),
                        age_40_49_yrs_m = sum(m)) %>% 
              gather(key = "variable", value = "value", 
                     -GEOID, -NAME) %>%
              mutate(sex = str_sub(variable, start = -1),
                     variable = str_sub(variable, end = -3))


age_50_59 <- age %>%
              filter(var %in% c("age_sex_50_54_yrs", "age_sex_55_59_yrs")) %>%
              group_by(GEOID, NAME) %>%
              summarize(age_50_59_yrs_f = sum(f),
                        age_50_59_yrs_m = sum(m)) %>% 
              gather(key = "variable", value = "value", 
                     -GEOID, -NAME) %>%
              mutate(sex = str_sub(variable, start = -1),
                     variable = str_sub(variable, end = -3))


age_60_69 <- age %>%
            filter(var %in% c("age_sex_60_61_yrs", "age_sex_62_64_yrs",
                              "age_sex_65_66_yrs", "age_sex_67_69_yrs")) %>%
            group_by(GEOID, NAME) %>%
            summarize(age_60_69_yrs_f = sum(f),
                      age_60_69_yrs_m = sum(m)) %>% 
            gather(key = "variable", value = "value", 
                   -GEOID, -NAME) %>%
            mutate(sex = str_sub(variable, start = -1),
                   variable = str_sub(variable, end = -3))




age_70_or_over <- age %>%
                  filter(var %in% c("age_sex_70_74_yrs", "age_sex_75_79_yrs",
                                    "age_sex_80_84_yrs", "age_sex_85_or_more_yrs")) %>%
                  group_by(GEOID, NAME) %>%
                  summarize(age_70_or_more_f = sum(f),
                            age_70_or_more_m = sum(m)) %>% 
                  gather(key = "variable", value = "value", 
                         -GEOID, -NAME) %>%
                  mutate(sex = str_sub(variable, start = -1),
                         variable = str_sub(variable, end = -3))


age <- rbind(age_0_9, age_10_19, age_20_29, 
                  age_30_39, age_40_49, age_50_59, 
                  age_60_69, age_70_or_over)


rm(age_0_9, age_10_19, age_20_29, 
      age_30_39, age_40_49, age_50_59, 
      age_60_69, age_70_or_over)










#  Plots ------------------------------------------------------------------


# A plot for one area (TX)
tx <- filter(age, NAME == "Texas")

View(tx)

library(RColorBrewer)

ggplot(tx, aes(x = variable, y = value, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  scale_y_continuous(labels = scales::comma ) +
  scale_fill_manual(values = brewer.pal(9, "Set3")[c(4,5)])



View(age)


test <- age %>%
        group_by(NAME) %>%
        mutate(freq = value / sum(value))

View(test)

test <- filter(test, NAME == "Texas")


ggplot(test, aes(x = variable, y = freq, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  scale_y_continuous(labels = scales::percent ) +
  scale_fill_manual(values = brewer.pal(9, "Set3")[c(4,5)]) +
  geom_text(aes(label = scales::percent(freq)), 
            position = position_dodge(0.9), 
            vjust = 1.5)



ggplot(test, aes(x = variable, y = value, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  scale_y_continuous(labels = scales::comma ) +
  scale_fill_manual(values = brewer.pal(9, "Set3")[c(4,5)]) +
  geom_text(aes(label = paste0(scales::comma(round(value/1000, 0)), "k")), 
            position = position_dodge(0.9), 
            vjust = 1.5)



names(test)

unique(test$variable)







#  Income Manipulation ----------------------------------------------------



inc <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016, 
              summary_var = "B19001_001")


# Create a named vector (opposite of my_vec) (a lookup vector)
my_vec_lookup <- names(my_vec)
names(my_vec_lookup) <- my_vec

# Index the lookup table / vector by the variable column 
inc$var <- my_vec_lookup[inc$variable]

rm(my_vec, my_vec_lookup)


my_names <- c(hou_inc_less_than_10 = "<$10k",
              hou_inc_10_to_14 = "$10-14k",
              hou_inc_15_to_19 = "$15-19k",
              hou_inc_20_to_24 = "$20-24k",
              hou_inc_25_to_29 = "$25-29k",
              hou_inc_30_to_34 = "$30-34k",
              hou_inc_35_to_39 = "$35-39k",
              hou_inc_40_to_44 = "$40-44k",
              hou_inc_45_to_49 = "$45-49k",
              hou_inc_50_to_59 = "$50-59k",
              hou_inc_60_to_74 = "$60-74k",
              hou_inc_75_to_99 = "$75-99k",
              hou_inc_100_to_124 = "$100-124k",
              hou_inc_125_to_149 = "$125-149k",
              hou_inc_150_to_199 = "$150-199k",
              hou_inc_200_or_more = ">=$200k"
)


inc$pretty_variable <- my_names[inc$var]



inc <- inc %>%
       select(-moe, -summary_moe) %>%
       mutate(inc_perc = estimate / summary_est)



inc <- inc %>%
       mutate(var = factor(var, levels = rev(unique(inc$var))),
              pretty_variable = factor(pretty_variable, levels = rev(unique(inc$pretty_variable))))  



tx <- filter(inc, NAME == "Texas")


ggplot(tx, aes(x = pretty_variable, y = estimate)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  coord_flip() +
  scale_y_continuous(labels = scales::comma) +
  labs(y = NULL, x = NULL)



















