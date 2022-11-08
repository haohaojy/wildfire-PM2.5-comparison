## Description: process population density data for later use in population density weighting
## Author: Ellen Considine

install.packages("https://cran.r-project.org/src/contrib/tigris_1.6.1.tar.gz",
                 repos=NULL, method="libcurl")
library(tigris)
library(tidycensus)
library(dplyr)

valid<- readRDS("Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")

states<- c(unique(valid$stateCode),"NV")

s<- states[1]
geodata<- tracts(state=s, year=2010) #unavailable for 2011 and 2012 according to https://cran.r-project.org/web/packages/tigris/readme/README.html
Geodata<- data.frame(GEOID = geodata$GEOID,
                     land_area = as.numeric(geodata$ALAND),
                     stringsAsFactors = F)

for(s in states[-1]){
  geodata<- tracts(state=s, year=2010) 
  Geodata<- rbind(Geodata, data.frame(GEOID = geodata$GEOID,
                       land_area = as.numeric(geodata$ALAND),
                       stringsAsFactors = F))
}

## Based on these notes: https://www2.census.gov/geo/pdfs/reference/Geography_Notes.pdf
Geodata$GEOID[which(Geodata$GEOID == "04019002903")]<- "04019002906"
Geodata$GEOID[which(Geodata$GEOID == "04019410503")]<- "04019004125"
Geodata$GEOID[which(Geodata$GEOID == "04019410502")]<- "04019004121"
Geodata$GEOID[which(Geodata$GEOID == "04019410501")]<- "04019004118"
Geodata$GEOID[which(Geodata$GEOID == "04019470500")]<- "04019005300"
Geodata$GEOID[which(Geodata$GEOID == "04019470400")]<- "04019005200"
Geodata$GEOID[which(Geodata$GEOID == "04019002701")]<- "04019002704"
Geodata$GEOID[which(Geodata$GEOID == "06037930401")]<- "06037137000"


Pop<- get_acs(geography = "tract", state = states, year = 2014, # midpoint ACS of study period
              variables = "B01001_001")
Population<- data.frame(GEOID = Pop$GEOID, Population = Pop$estimate)

PD<- inner_join(Population, Geodata, by="GEOID")
PD$Pop_density<- PD$Population / (PD$land_area / 2589988)

#### Merge in with Reid-Di 2008-2016 data:

valid$id<- 1:nrow(valid)
new<- inner_join(PD, valid, by="GEOID")

Missing<- valid[which(!valid$id %in% new$id),] # these GEOIDs are all places we are missing Reid data

saveRDS(new, "Revisions_Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")


#### Merge in with Reid 2008-2018 data:

all_reid<- readRDS("Merged_monitor_Reid_without_CMAQ.rds")

new_reid<- inner_join(PD, all_reid, by="GEOID")

saveRDS(new_reid, "Revisions_Merged_monitor_Reid_without_CMAQ.rds")


#### Merge in with Reid 2008-2018 data:

EPA<- readRDS("Merged_EPA_Di_Reid_with_CMAQ.rds")
EPA$GEOID[which(EPA$GEOID == "04019470400")]<- "04019005200"
EPA$GEOID[which(EPA$GEOID == "53027950300")]<- "53039950302"
EPA$id<- 1:nrow(EPA)

new_epa<- inner_join(PD, EPA, by="GEOID")

Missing_epa<- EPA[which(!EPA$id %in% new_epa$id),] 

saveRDS(new_epa, "Revisions_Merged_EPA_Di_Reid_with_CMAQ.rds")





