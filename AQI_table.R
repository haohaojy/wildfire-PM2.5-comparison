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
                   mean(abs(Data$Reid_class - Data$Monitor_class) > 1, na.rm = TRUE))
UHM<- c(mean((Data$Di_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE),
                   mean((Data$Reid_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE))

Results<- data.frame(Comparison, Misclassified, Underclassified,
                     Overclassified, Large_misclass, UHM)

rm(list=setdiff(ls(),c("Data", "Results")))
save.image(file = "AQI_calcs.RData")

xtable(Results[,2:6]*100)

### Look at whole classification table:

load("AQI_calcs.RData")

Data<- Data[which(!is.na(Data$PM_Di)),]

RvM<- table(Data[,c("Monitor_class", "Reid_class")])
DvM<- table(Data[,c("Monitor_class", "Di_class")])
DvM<- cbind(DvM, 0)

RvM<- rbind(RvM, colSums(RvM))
DvM<- rbind(DvM, colSums(DvM))
RvM<- cbind(RvM, rowSums(RvM))
DvM<- cbind(DvM, rowSums(DvM))

xtable(RvM, digits=0)
xtable(DvM, digits=0)

## Percentages:
RvM<- rbind(RvM, RvM[7,]/RvM[,7])
DvM<- rbind(DvM, DvM[7,]/DvM[,7])

(round(RvM[8,],2) - 1)*100
(round(DvM[8,],2) - 1)*100

### Consider binary smoke exposure:

Data$Reid_Smoke<- 0
Data$Reid_Smoke[which(Data$Reid_class > 2)]<- 1
Data$Di_Smoke<- 0
Data$Di_Smoke[which(Data$Di_class > 2)]<- 1
Data$Monitor_Smoke<- 0
Data$Monitor_Smoke[which(Data$Monitor_class > 2)]<- 1

RvM_binary<- table(Data[,c("Monitor_Smoke", "Reid_Smoke")])
DvM_binary<- table(Data[,c("Monitor_Smoke", "Di_Smoke")])

RvM_binary<- rbind(RvM_binary, colSums(RvM_binary))
DvM_binary<- rbind(DvM_binary, colSums(DvM_binary))
RvM_binary<- cbind(RvM_binary, rowSums(RvM_binary))
DvM_binary<- cbind(DvM_binary, rowSums(DvM_binary))

xtable(RvM_binary, digits=0)
xtable(DvM_binary, digits=0)

#### Calcs:
(RvM_binary[1,2] + RvM_binary[2,1])/RvM_binary[3,3]
(DvM_binary[1,2] + DvM_binary[2,1])/DvM_binary[3,3]

## Sensitivity:

RvM_binary[2,2]/RvM_binary[2,3]
DvM_binary[2,2]/DvM_binary[2,3]

## Specificity:

RvM_binary[1,1]/RvM_binary[1,3]
DvM_binary[1,1]/DvM_binary[1,3]

## PPV:

RvM_binary[2,2]/RvM_binary[3,2]
DvM_binary[2,2]/DvM_binary[3,2]

## NPV:

RvM_binary[1,1]/RvM_binary[3,1]
DvM_binary[1,1]/DvM_binary[3,1]


