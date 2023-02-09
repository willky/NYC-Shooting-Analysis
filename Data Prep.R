## Load libraries

library(tidyverse)
library(lubridate)

## Download historical and YTD data from Open Data Portal
## Load both datasets and clean

historic <- "https://data.cityofnewyork.us/api/views/833y-fsy8/rows.csv?accessType=DOWNLOAD"
download.file(historic, destfile = "historic_shooting.csv", method = "curl")
historic <- read_csv("historic_shooting.csv")

ytd <- "https://data.cityofnewyork.us/api/views/5ucz-vwe8/rows.csv?accessType=DOWNLOAD"
download.file(ytd, destfile = "ytd_shooting.csv", method = "curl")

ytd <- read_csv("ytd_shooting.csv") %>% 
       select(-c(LOC_OF_OCCUR_DESC, LOC_CLASSFCTN_DESC)) %>% 
       rename(Lon_Lat = `New Georeferenced Column`)

## merge historic and ytd into one data which will be used for Tableau viz
## Check for duplicates and other things

shootings <- rbind(historic, ytd)

shootings[duplicated(shootings$INCIDENT_KEY), ]         

# There are 5,635 duplicates of INCIDENT_KEYS. Note that a shooting incident can have multiple victims involved; 
# hence, the reason for duplicated INCIDENT_KEYS.
# An INCIDENT_KEY represents a victim; 2 victims with same incident key means the two people were shot in one incident.


save.image("shootings.RData")

## Data to be used for full Year analysis in Tableau

full_year <- shootings %>% mutate(OCCUR_DATE = as.Date(shootings$OCCUR_DATE, format="%m/%d/%Y"),
                                  occur_year = year(full_year$OCCUR_DATE),
                                  INCIDENT_KEY = as.numeric(INCIDENT_KEY)) %>% 
                           filter(occur_year != "2022")

    
full_year <- save.image("shootings_fy.RData")
