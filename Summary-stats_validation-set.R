#### Generating Table 1 and long table in the SI (summary statistics of the validation set)

library(xtable)

valid<- readRDS("Merged_monitor_Di_Reid_with_CMAQ.rds")

di_na_pos<- which(is.na(valid$PM_Di))

## Make Table 1:

Table.1<- cbind(summary(valid$PM2.5), summary(valid$PM_Di[-di_na_pos]), summary(valid$PM_Reid))
Table.1<- rbind(Table.1, c(sd(valid$PM2.5), sd(valid$PM_Di[-di_na_pos]),
                           sd(valid$PM_Reid)))

Medium<- cbind(summary(valid[which(valid$PM2.5 >= 12.1),"PM2.5"]),
               summary(valid[which(valid$PM2.5 >= 12.1),"PM_Di"])[-7], 
               summary(valid[which(valid$PM2.5 >= 12.1),"PM_Reid"]))
Medium<- rbind(Medium, c(sd(valid[which(valid$PM2.5 >= 12.1),"PM2.5"]),
                         sd(valid[which(valid$PM2.5 >= 12.1),"PM_Di"], na.rm = TRUE), 
               sd(valid[which(valid$PM2.5 >= 12.1),"PM_Reid"])))

High<- cbind(summary(valid[which(valid$PM2.5 >= 35.5),"PM2.5"]),
               summary(valid[which(valid$PM2.5 >= 35.5),"PM_Di"])[-7], 
               summary(valid[which(valid$PM2.5 >= 35.5),"PM_Reid"]))
High<- rbind(High, c(sd(valid[which(valid$PM2.5 >= 35.5),"PM2.5"]),
                         sd(valid[which(valid$PM2.5 >= 35.5),"PM_Di"], na.rm = TRUE), 
               sd(valid[which(valid$PM2.5 >= 35.5),"PM_Reid"])))

Table.1<- cbind(Table.1, Medium, High)

write.csv(round(Table.1,2), "Table_1.csv")

## Print for Latex:

xtable(Table.1)


## Make Table 2:

subsets<- function(variable, value){ # Example: "year", 2008
  pos<- which(valid[,variable] == value)
  N<- length(pos)
  
  Means<- round(c(mean(valid[pos,"PM2.5"]), mean(valid[pos,"PM_Di"], na.rm=TRUE),
            mean(valid[pos,"PM_Reid"]), 
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM2.5"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_Di"], na.rm=TRUE),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_Reid"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM2.5"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_Di"], na.rm=TRUE),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_Reid"])),2)
  SDs<- round(c(sd(valid[pos,"PM2.5"]), sd(valid[pos,"PM_Di"], na.rm=TRUE),
            sd(valid[pos,"PM_Reid"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM2.5"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_Di"], na.rm=TRUE),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_Reid"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM2.5"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_Di"], na.rm=TRUE),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_Reid"])),2)
  SDs<- paste0(SDs, ")")
  return(c(paste0(value, " (", N, ", ", length(intersect(pos, which(valid$PM2.5 >= 12.1))),
                  ", ", length(intersect(pos, which(valid$PM2.5 >= 35.5))),
                  ")"), paste(Means, SDs, sep = " (")))
}

Seasons<- sapply(c("spring", "summer", "autumn", "winter"), 
                 function(x) subsets("season", x))
Years<- sapply(2008:2016, function(x) subsets("year", x))

states<- sort(unique(valid$state))
States<- sapply(states, function(x) subsets("state", x))

Table.2<- rbind(t(Seasons), t(Years), t(States))

write.csv(Table.2, "Table_2.csv")


## Print for Latex:

xtable(Table.2)
