library(ggplot2)

data1<-data.frame(state=c("AZ", "CA", "CO", "ID", "MT", "WY", "NM", "OR", "UT", "WA"), number = summary(as.factor(valid$stateCode)) )
ggplot(data1, aes(x="", y=number, fill=state)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)

data2<-data.frame(season=c('spring','summer','autumn','winter'),number=summary(as.factor(valid$season)))
ggplot(data2, aes(x="", y=number, fill=season)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)

data3<-data.frame(year=c(2008:2016),number=summary(as.factor(valid$year)))
ggplot(data3, aes(x="", y=number, fill=year)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)