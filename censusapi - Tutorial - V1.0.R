

# Getting started with censusapi ------------------------------------------

# https://hrecht.github.io/censusapi/articles/getting-started.html


# API key setup -----------------------------------------------------------


# Add key to .Renviron
Sys.setenv(CENSUS_KEY = "f6259ec5d271471f6656ae7c66e2f41b867e5cb1")

# Reload .Renviron
readRenviron("~/.Renviron")

# Check to see that the expected key is output in your R console
Sys.getenv("CENSUS_KEY")



# Finding you API ---------------------------------------------------------

library(censusapi)


apis <- listCensusApis()

View(apis)



# Choosing Variables ------------------------------------------------------


sahie_vars <- listCensusMetadata(name="timeseries/healthins/sahie", 
                                 type = "variables")

head(sahie_vars)

View(sahie_vars)




# Choosing Regions --------------------------------------------------------

listCensusMetadata(name="timeseries/healthins/sahie", type = "geography")


getCensus(name="timeseries/healthins/sahie",
          vars=c("NAME", "IPRCAT", "IPR_DESC", "PCTUI_PT"), 
          region="us:*", time=2015)



sahie_states <- getCensus(name="timeseries/healthins/sahie",
                          vars=c("NAME", "IPRCAT", "IPR_DESC", "PCTUI_PT"), 
                          region="state:*", time=2015)

head(sahie_states)



sahie_counties <- getCensus(name="timeseries/healthins/sahie",
                            vars=c("NAME", "IPRCAT", "IPR_DESC", "PCTUI_PT"), 
                            region="county:*", regionin="state:1,2", time=2015)

head(sahie_counties, n=12L)




# Advanced Geographies ----------------------------------------------------

fips

tracts <- NULL

for (f in fips) {
                  stateget <- paste("state:", f, sep="")
                  
                  temp <- getCensus(name="sf3", vintage=1990,
                                    vars=c("P0070001", "P0070002", "P114A001"), region="tract:*",
                                    regionin = stateget)
                  
                  tracts <- rbind(tracts, temp)
}



head(tracts)



data2010 <- getCensus(name="sf1", vintage=2010,
                      vars=c("P0010001", "P0030001"), 
                      region="block:*", regionin="state:36+county:027")

head(data2010)



data2000 <- getCensus(name="sf1", vintage=2000,
                      vars=c("P001001", "P003001"), 
                      region="block:*", regionin="state:36+county:027+tract:010000")

head(data2000)







# Kiniry work -------------------------------------------------------------

rm(list=ls())

acs_vars <- listCensusMetadata(name="acs/acs1", vintage = 2015, 
                                 type = "variables")

View(acs_vars)







