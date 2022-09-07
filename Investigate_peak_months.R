## Description: inspect peak months based on different metrics
## Author: Ellen Considine

setwd()
data<- readRDS("year_month_state_all.rds")

Data<- data[which(data$CMAQ == "with_CMAQ"),]

## Just looking at Reid (all years):
data[order(data$reid_mean, decreasing = TRUE),][1:20,]
data[order(data$reid_75, decreasing = TRUE),][1:20,]
data[order(data$reid_max, decreasing = TRUE),][1:20,]

## Reid (years with CMAQ):
Data[order(Data$reid_mean, decreasing = TRUE),][1:20,]
Data[order(Data$reid_75, decreasing = TRUE),][1:20,]
Data[order(Data$reid_max, decreasing = TRUE),][1:20,]

Data[order(Data$di_mean, decreasing = TRUE),][1:20,]
Data[order(Data$di_75, decreasing = TRUE),][1:20,]
Data[order(Data$di_max, decreasing = TRUE),][1:20,]

## Di vs Reid:
Data[which(Data$di_max > 150 & Data$reid_max < 55),] # 1 obs
Data[which(Data$reid_max > 150 & Data$di_max < 55),] # 7 obs

Data[which(Data$di_max - Data$reid_max > 50),] # 32 obs
Data[which(Data$reid_max - Data$di_max > 50),] # 136 obs

Data[which(Data$di_75 - Data$reid_75 > 10),] # 1 obs
Data[which(Data$reid_75 - Data$di_75 > 10),] # 1 obs

Data[which(Data$di_mean - Data$reid_mean > 5),] # 1 obs
Data[which(Data$reid_mean - Data$di_mean > 5),] # 4 obs

summary(Data$reid_mean)
summary(Data$di_mean)
summary(Data$reid_mean - Data$di_mean)

