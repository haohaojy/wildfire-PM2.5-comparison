#### Generating Tables 1 and 2 (summary statistics of the validation set)

setwd("C:/Users/ellen/OneDrive/MyDocs/Graduate Research/Wildfire data project")
valid<- readRDS("Validation_set.rds")

## Make Table 1:

Table.1<- cbind(summary(valid$PM2.5), summary(valid$PM_grid[-di_na_pos]), summary(valid$Ens_pred))
Table.1<- rbind(Table.1, c(sd(valid$PM2.5), sd(valid$PM_grid[-di_na_pos]),
                           sd(valid$Ens_pred)))

Medium<- cbind(summary(valid[which(valid$PM2.5 >= 12.1),"PM2.5"]),
               summary(valid[which(valid$PM2.5 >= 12.1),"PM_grid"])[-7], 
               summary(valid[which(valid$PM2.5 >= 12.1),"Ens_pred"]))
Medium<- rbind(Medium, c(sd(valid[which(valid$PM2.5 >= 12.1),"PM2.5"]),
                         sd(valid[which(valid$PM2.5 >= 12.1),"PM_grid"], na.rm = TRUE), 
               sd(valid[which(valid$PM2.5 >= 12.1),"Ens_pred"])))

High<- cbind(summary(valid[which(valid$PM2.5 >= 35.5),"PM2.5"]),
               summary(valid[which(valid$PM2.5 >= 35.5),"PM_grid"])[-7], 
               summary(valid[which(valid$PM2.5 >= 35.5),"Ens_pred"]))
High<- rbind(High, c(sd(valid[which(valid$PM2.5 >= 35.5),"PM2.5"]),
                         sd(valid[which(valid$PM2.5 >= 35.5),"PM_grid"], na.rm = TRUE), 
               sd(valid[which(valid$PM2.5 >= 35.5),"Ens_pred"])))

Table.1<- cbind(Table.1, Medium, High)

write.csv(round(Table.1,2), "Table_1.csv")

## Make Table 2:

subsets<- function(variable, value){ # Example: "year", 2008
  pos<- which(valid[,variable] == value)
  N<- length(pos)
  
  Means<- round(c(mean(valid[pos,"PM2.5"]), mean(valid[pos,"PM_grid"], na.rm=TRUE),
            mean(valid[pos,"Ens_pred"]), 
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM2.5"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_grid"], na.rm=TRUE),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"Ens_pred"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM2.5"]),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_grid"], na.rm=TRUE),
            mean(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"Ens_pred"])),2)
  SDs<- round(c(sd(valid[pos,"PM2.5"]), sd(valid[pos,"PM_grid"], na.rm=TRUE),
            sd(valid[pos,"Ens_pred"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM2.5"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"PM_grid"], na.rm=TRUE),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 12.1)),"Ens_pred"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM2.5"]),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"PM_grid"], na.rm=TRUE),
            sd(valid[intersect(pos, which(valid$PM2.5 >= 35.5)),"Ens_pred"])),2)
  SDs<- paste0(SDs, ")")
  return(c(paste0(value, " (", N, ", ", length(intersect(pos, which(valid$PM2.5 >= 12.1))),
                  ", ", length(intersect(pos, which(valid$PM2.5 >= 35.5))),
                  ")"), paste(Means, SDs, sep = " (")))
}

Seasons<- sapply(c("spring", "summer", "autumn", "winter"), 
                 function(x) subsets("season", x))
Years<- sapply(2008:2016, function(x) subsets("year", x))

States<- sapply(states, function(x) subsets("state", x))

Table.2<- rbind(t(Seasons), t(Years), t(States))

write.csv(Table.2, "Table_2.csv")
