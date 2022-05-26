library(ggplot2)
library(cowplot)
library(stringr)

valid<- readRDS("Merged_monitor_Di_Reid_with_CMAQ.rds")

valid$stateCode<- as.factor(valid$stateCode)
valid$season<- str_to_title(valid$season)
valid$season<- as.factor(valid$season)

data1<-data.frame(State=levels(valid$stateCode), number = summary(valid$stateCode) )
p1<- ggplot(data1, aes(x="", y=number, fill=State)) +
  geom_bar(stat="identity", width=1) + ggtitle("Observations per State") +
  coord_polar("y", start=0) + xlab("") + ylab("") + theme(axis.text = element_blank(),
                                                          axis.ticks = element_blank(),
                                                          panel.grid  = element_blank())
leg1<- get_legend(p1 + theme(legend.position = "bottom", legend.box = "vertical",
                          legend.key.width = unit(0.25, "line"), 
                          legend.spacing.y = unit(0.1, "cm"),
                          legend.title = element_text(face="bold")))

data2<-data.frame(Season=levels(valid$season),number=summary(valid$season))
p2<- ggplot(data2, aes(x="", y=number, fill=Season)) +
  geom_bar(stat="identity", width=1) + ggtitle("Observations per Season") +
  coord_polar("y", start=0) + xlab("") + ylab("") + theme(axis.text = element_blank(),
                                                          axis.ticks = element_blank(),
                                                          panel.grid  = element_blank())
leg2<- get_legend(p2 + theme(legend.position = "bottom", legend.box = "vertical",
                             legend.key.width = unit(0.25, "line"), 
                             legend.spacing.y = unit(0.1, "cm"),
                             legend.title = element_text(face="bold")))

data3<-data.frame(Year=c(2008:2016),number=summary(as.factor(valid$year)))
p3<- ggplot(data3, aes(x="", y=number, fill=Year)) +
  geom_bar(stat="identity", width=1) + ggtitle("Observations per Year") +
  coord_polar("y", start=0) + xlab("") + ylab("") + theme(axis.text = element_blank(),
                                                          axis.ticks = element_blank(),
                                                          panel.grid  = element_blank())
leg3<- get_legend(p3 + theme(legend.position = "bottom", legend.box = "vertical",
                             legend.key.width = unit(2.5, "line"), 
                             legend.spacing.y = unit(0.1, "cm"),
                             legend.title = element_text(face="bold")))

plots<- plot_grid(p3 + theme(legend.position="none"), p2 + theme(legend.position="none"),
                  p1 + theme(legend.position="none"), nrow=1)
legends<- plot_grid(leg3, leg2, leg1, nrow=1)

png("Plots/Pie_charts.png", width = 700, height = 250)
plot_grid(plots, NULL, legends, nrow = 3, rel_heights = c(1, -0.25, 0.6))
dev.off()
