## Description: calculate AQI classifications based on PM2.5 concentrations
## Author: Ellen Considine

library(xtable)
# library(devtools)
# install_github("NSAPH-Software/NSAPHutils", ref="develop")
library(NSAPHutils)

valid<- readRDS("Revisions_Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")

na<- which(is.na(valid$PM_Di)|is.na(valid$PM_Reid))
data<- valid[-na,]

Data<- data[,c("date", "year", "season", "state", "GEOID", 
               "PM2.5", "PM_Di", "PM_Reid", "Pop_density")]

## Apply AQI equation from NSAPHutils:

Data$Monitor_class<- AQI("PM2.5", Data$PM2.5)[,4]
Data$Reid_class<- AQI("PM2.5", Data$PM_Reid)[,4]
Data$Di_class<- AQI("PM2.5", Data$PM_Di)[,4]

color_order<- c("Green", "Yellow", "Orange", "Red", "Purple", "Maroon")
Data$Monitor_class<- as.numeric(factor(Data$Monitor_class, levels = color_order))
Data$Di_class<- as.numeric(factor(Data$Di_class, levels = color_order))
Data$Reid_class<- as.numeric(factor(Data$Reid_class, levels = color_order))

## Make table:

Comparison<- c("Di vs Monitor, weighted", "Reid vs Monitor, weighted",
               "Di vs Monitor, unweighted", "Reid vs Monitor, unweighted")
Misclassified<- c(weighted.mean(Data$Di_class != Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                       weighted.mean(Data$Reid_class != Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                  mean(Data$Di_class != Data$Monitor_class, na.rm = TRUE),
                  mean(Data$Reid_class != Data$Monitor_class, na.rm = TRUE))
Underclassified<- c(weighted.mean(Data$Di_class < Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                   weighted.mean(Data$Reid_class < Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                   mean(Data$Di_class < Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class < Data$Monitor_class, na.rm = TRUE))
Overclassified<- c(weighted.mean(Data$Di_class > Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                   weighted.mean(Data$Reid_class > Data$Monitor_class, Data$Pop_density, na.rm = TRUE),
                   mean(Data$Di_class > Data$Monitor_class, na.rm = TRUE),
                   mean(Data$Reid_class > Data$Monitor_class, na.rm = TRUE))
Large_misclass<- c(weighted.mean(abs(Data$Di_class - Data$Monitor_class) > 1, Data$Pop_density, na.rm = TRUE),
                   weighted.mean(abs(Data$Reid_class - Data$Monitor_class) > 1, Data$Pop_density, na.rm = TRUE),
                   mean(abs(Data$Di_class - Data$Monitor_class) > 1, na.rm = TRUE),
                   mean(abs(Data$Reid_class - Data$Monitor_class) > 1, na.rm = TRUE))
UHM<- c(weighted.mean((Data$Di_class <= 2)&(Data$Monitor_class > 2), Data$Pop_density, na.rm = TRUE),
                   weighted.mean((Data$Reid_class <= 2)&(Data$Monitor_class > 2), Data$Pop_density, na.rm = TRUE),
        mean((Data$Di_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE),
        mean((Data$Reid_class <= 2)&(Data$Monitor_class > 2), na.rm = TRUE))

Results<- data.frame(Comparison, Misclassified, Underclassified,
                     Overclassified, Large_misclass, UHM)

rm(list=setdiff(ls(),c("Data", "Results")))
save.image(file = "AQI_calcs.RData")

row.names(Results)<- Comparison
print(xtable(Results[,2:5]*100), hline.after = 1:nrow(Results))

### Look at whole classification table:

load("AQI_calcs.RData")

# Data<- Data[which(!is.na(Data$PM_Di)),]

RvM<- table(Data[,c("Monitor_class", "Reid_class")])
DvM<- table(Data[,c("Monitor_class", "Di_class")])
RvM<- cbind(RvM, 0)
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
Misclassified<- c(weighted.mean(Data$Di_Smoke != Data$Monitor_Smoke, Data$Pop_density, na.rm = TRUE),
                  weighted.mean(Data$Reid_Smoke != Data$Monitor_Smoke, Data$Pop_density, na.rm = TRUE),
                  mean(Data$Di_Smoke != Data$Monitor_Smoke, na.rm = TRUE),
                  mean(Data$Reid_Smoke != Data$Monitor_Smoke, na.rm = TRUE))

# (RvM_binary[1,2] + RvM_binary[2,1])/RvM_binary[3,3]
# (DvM_binary[1,2] + DvM_binary[2,1])/DvM_binary[3,3]

## Sensitivity:

Sensitivity<- c(weighted.mean(Data$Di_Smoke == 1 & Data$Monitor_Smoke == 1, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Monitor_Smoke == 1,
                                Data$Pop_density, na.rm = TRUE),
                weighted.mean(Data$Reid_Smoke == 1 & Data$Monitor_Smoke == 1, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Monitor_Smoke == 1,
                                Data$Pop_density, na.rm = TRUE),
                DvM_binary[2,2]/DvM_binary[2,3],
                RvM_binary[2,2]/RvM_binary[2,3])


## Specificity:

Specificity<- c(weighted.mean(Data$Di_Smoke == 0 & Data$Monitor_Smoke == 0, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Monitor_Smoke == 0,
                                Data$Pop_density, na.rm = TRUE),
                weighted.mean(Data$Reid_Smoke == 0 & Data$Monitor_Smoke == 0, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Monitor_Smoke == 0,
                                Data$Pop_density, na.rm = TRUE),
                DvM_binary[1,1]/DvM_binary[1,3],
                RvM_binary[1,1]/RvM_binary[1,3])


## PPV:

PPV<- c(weighted.mean(Data$Di_Smoke == 1 & Data$Monitor_Smoke == 1, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Di_Smoke == 1,
                                Data$Pop_density, na.rm = TRUE),
                weighted.mean(Data$Reid_Smoke == 1 & Data$Monitor_Smoke == 1, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Reid_Smoke == 1,
                                Data$Pop_density, na.rm = TRUE),
                DvM_binary[2,2]/DvM_binary[3,2],
                RvM_binary[2,2]/RvM_binary[3,2])


## NPV:

NPV<- c(weighted.mean(Data$Di_Smoke == 0 & Data$Monitor_Smoke == 0, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Di_Smoke == 0,
                                Data$Pop_density, na.rm = TRUE),
                weighted.mean(Data$Reid_Smoke == 0 & Data$Monitor_Smoke == 0, 
                              Data$Pop_density, na.rm = TRUE) /
                  weighted.mean(Data$Reid_Smoke == 0,
                                Data$Pop_density, na.rm = TRUE),
                DvM_binary[1,1]/DvM_binary[3,1],
                RvM_binary[1,1]/RvM_binary[3,1])


Binary_results<- data.frame(Misclassified, Sensitivity, Specificity, PPV, NPV)
row.names(Binary_results)<- Comparison

print(xtable(Binary_results*100), hline.after = 1:nrow(Binary_results))
