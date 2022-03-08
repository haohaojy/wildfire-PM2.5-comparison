library(xtable)
# library(devtools)
# install_github("NSAPH-Software/NSAPHutils", ref="develop")
library(NSAPHutils)

setwd("C:/Users/ellen/OneDrive/MyDocs/Graduate Research/Wildfire data project")

data<- readRDS("Validation_set.rds")
Data<- data[,c("date", "year", "season", "state", "GEOID", 
               "PM2.5", "PM_grid", "Ens_pred")]

## Apply aqi equation from NSAPHutils:

Data$Monitor_class<- aqi_equation("PM2.5", Data$PM2.5)$Color
Data$Reid_class<- aqi_equation("PM2.5", Data$Ens_pred)$Color

di_na_pos<- which(is.na(Data$PM_grid))
Data$Di_class<- NA
Data$Di_class[-di_na_pos]<- aqi_equation("PM2.5", Data$PM_grid[-di_na_pos])$Color

color_order<- c("Green", "Yellow", "Orange", "Red", "Purple", "Maroon")
Data$Monitor_class<- as.numeric(factor(Data$Monitor_class, levels = color_order))
Data$Di_class<- as.numeric(factor(Data$Di_class, levels = color_order))
Data$Reid_class<- as.numeric(factor(Data$Reid_class, levels = color_order))

## Make table:

Comparison<- c("Di vs Monitor", "Reid vs Monitor")
Misclassified<- c(mean(Data$Di_class != Data$Monitor_class, na.rm = TRUE),
                       mean(Data$Reid_class != Data$Monitor_class))
Underclassified<- c(mean(Data$Di_class < Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class < Data$Monitor_class))
Overclassified<- c(mean(Data$Di_class > Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class > Data$Monitor_class))
Large_misclass<- c(mean(abs(Data$Di_class - Data$Monitor_class) > 1, na.rm = TRUE),
                   mean(abs(Data$Reid_class > Data$Monitor_class) > 1))
UHM<- c(mean((Data$Di_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE),
                   mean((Data$Reid_class <= 2)&(Data$Monitor_class > 2)))

Results<- data.frame(Comparison, Misclassified, Underclassified,
                     Overclassified, Large_misclass, UHM)

rm(list=setdiff(ls(),c("Data", "Results")))
save.image(file = "AQI_calcs.RData")




