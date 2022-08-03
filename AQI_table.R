library(xtable)
# library(devtools)
# install_github("NSAPH-Software/NSAPHutils", ref="develop")
library(NSAPHutils)

valid<- readRDS("Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")

na<- which(is.na(valid$PM_Di)|is.na(valid$PM_Reid))
data<- valid[-na,]

Data<- data[,c("date", "year", "season", "state", "GEOID", 
               "PM2.5", "PM_Di", "PM_Reid")]

## Apply aqi equation from NSAPHutils:

Data$Monitor_class<- aqi_equation("PM2.5", Data$PM2.5)$Color
# Data$Reid_class<- aqi_equation("PM2.5", Data$PM_Reid)$Color
# Data$Di_class<- aqi_equation("PM2.5", Data$PM_Di)$Color

reid_na_pos<- which(is.na(Data$PM_Reid))
Data$Reid_class<- NA
Data$Reid_class[-reid_na_pos]<- aqi_equation("PM2.5", Data$PM_Reid[-reid_na_pos])$Color

di_na_pos<- which(is.na(Data$PM_Di))
Data$Di_class<- NA
Data$Di_class[-di_na_pos]<- aqi_equation("PM2.5", Data$PM_Di[-di_na_pos])$Color

color_order<- c("Green", "Yellow", "Orange", "Red", "Purple", "Maroon")
Data$Monitor_class<- as.numeric(factor(Data$Monitor_class, levels = color_order))
Data$Di_class<- as.numeric(factor(Data$Di_class, levels = color_order))
Data$Reid_class<- as.numeric(factor(Data$Reid_class, levels = color_order))

## Make table:

Comparison<- c("Di vs Monitor", "Reid vs Monitor")
Misclassified<- c(mean(Data$Di_class != Data$Monitor_class, na.rm = TRUE),
                       mean(Data$Reid_class != Data$Monitor_class, na.rm = TRUE))
Underclassified<- c(mean(Data$Di_class < Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class < Data$Monitor_class, na.rm = TRUE))
Overclassified<- c(mean(Data$Di_class > Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class > Data$Monitor_class, na.rm = TRUE))
Large_misclass<- c(mean(abs(Data$Di_class - Data$Monitor_class) > 1, na.rm = TRUE),
                   mean(abs(Data$Reid_class > Data$Monitor_class) > 1, na.rm = TRUE))
UHM<- c(mean((Data$Di_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE),
                   mean((Data$Reid_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE))

Results<- data.frame(Comparison, Misclassified, Underclassified,
                     Overclassified, Large_misclass, UHM)

rm(list=setdiff(ls(),c("Data", "Results")))
save.image(file = "AQI_calcs.RData")

xtable(Results[,2:6]*100)

### Look at whole classification table:

load("AQI_calcs.RData")

RvM<- table(Data[,c("Monitor_class", "Reid_class")])
DvM<- table(Data[,c("Monitor_class", "Di_class")])

RvM<- rbind(RvM, colSums(RvM))
DvM<- rbind(DvM, colSums(DvM))
RvM<- cbind(RvM, rowSums(RvM))
DvM<- cbind(DvM, rowSums(DvM))

xtable(RvM)
xtable(DvM)
