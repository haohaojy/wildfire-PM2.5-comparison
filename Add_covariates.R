#### Ensure the covariates are all the same for the validation set:

library(dplyr)
library(lubridate)
# install.packages("censusxy")
library(censusxy)

## Functions:

my_geos<- function(lon, lat, date){
  geo<- cxy_geography(lon, lat)
  want<- unlist(geo[,c("States.STUSAB", "States.BASENAME", "County.Subdivisions.GEOID")])
  names(want)<- c("stateCode", "state", "GEOID")
  return(want)
}

m_y_s<- function(date){
  m<- as.character(month(date, label = TRUE, abbr = FALSE))
  y<- year(date)
  if(m %in% c("December", "January", "February")){
    s<- "winter"
  }else if(m %in% c("March", "April", "May")){
    s<- "spring"
  } else if(m %in% c("June", "July", "August")){
    s<- "summer"
  }else{
    s<- "autumn"
  }
  
  return(c(m, y, s))
}

warm_season<- function(m){
  if(m %in% c("May", "June", "July", "August", "September", "October")){
    w<- TRUE
  }else{
    w<- FALSE
  }
  return(w)
}

### Apply these functions:
all_16<- readRDS("Merged_monitor_Di_Reid_with_CMAQ.rds")

miss_16<- which(is.na(all_16$season))
all_16[miss_16, c("month", "year", "season")]<- t(sapply(all_16[miss_16, "date"], m_y_s))

locs<- distinct(all_16[,c("longitude", "latitude")])
Locs<- t(apply(locs[,c("longitude", "latitude")], MARGIN = 1, 
               function(x) my_geos(x[1],x[2])))

Loc_df<- as.data.frame(Locs)
Loc_df$longitude<- locs$longitude
Loc_df$latitude<- locs$latitude

all_16$stateCode<- NULL
all_16$state<- NULL
all_16$GEOID<- NULL

All_16<- inner_join(all_16, Loc_df)
All_16$Warm_season<- sapply(All_16$month, warm_season)

saveRDS(All_16, "Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")


