#### Generating Tables 1 and 2 (summary statistics of the validation set)

library(MetricsWeighted)
library(xtable)

valid<- readRDS("Revisions_Merged_FINAL_monitor_Di_Reid_with_CMAQ.rds")

##### When we don't include points where either dataset is missing:

na<- which(is.na(valid$PM_Di)|is.na(valid$PM_Reid))
valid<- valid[-na,]

## Make Table 1:

weighted_summary<- function(x, w){
  min<- min(x)
  q1<- weighted_quantile(x, w, probs=0.25)
  med<- weighted_quantile(x, w, probs=0.5)
  avg<- weighted.mean(x, w)
  q3<- weighted_quantile(x, w, probs=0.75)
  max<- max(x)
  
  return(c(min, q1, med, avg, q3, max))
}

Table.1<- cbind(weighted_summary(valid$PM2.5, valid$Pop_density), 
                weighted_summary(valid$PM_Di, valid$Pop_density), 
                weighted_summary(valid$PM_Reid, valid$Pop_density))
Table.1<- rbind(Table.1, c(sqrt(weighted_var(valid$PM2.5, valid$Pop_density)), 
                sqrt(weighted_var(valid$PM_Di, valid$Pop_density)),
                           sqrt(weighted_var(valid$PM_Reid, valid$Pop_density))))
m_pos<- which(valid$PM2.5 >= 12.1)
Medium<- cbind(weighted_summary(valid[m_pos,"PM2.5"], valid[m_pos, "Pop_density"]),
               weighted_summary(valid[m_pos,"PM_Di"], valid[m_pos, "Pop_density"]), 
               weighted_summary(valid[m_pos,"PM_Reid"], valid[m_pos, "Pop_density"]))
Medium<- rbind(Medium, 
               c(sqrt(weighted_var(valid[m_pos,"PM2.5"], valid[m_pos, "Pop_density"])),
                  sqrt(weighted_var(valid[m_pos,"PM_Di"], valid[m_pos, "Pop_density"])), 
                  sqrt(weighted_var(valid[m_pos,"PM_Reid"], valid[m_pos, "Pop_density"]))))

h_pos<- which(valid$PM2.5 >= 35.5)
High<- cbind(weighted_summary(valid[h_pos,"PM2.5"], valid[h_pos, "Pop_density"]),
             weighted_summary(valid[h_pos,"PM_Di"], valid[h_pos, "Pop_density"]), 
             weighted_summary(valid[h_pos,"PM_Reid"], valid[h_pos, "Pop_density"]))
High<- rbind(High, c(sqrt(weighted_var(valid[h_pos,"PM2.5"], valid[h_pos, "Pop_density"])),
                     sqrt(weighted_var(valid[h_pos,"PM_Di"], valid[h_pos, "Pop_density"])), 
                     sqrt(weighted_var(valid[h_pos,"PM_Reid"], valid[h_pos, "Pop_density"]))))

Table.1<- cbind(Table.1, Medium, High)
row.names(Table.1)<- c("Minimum", "1st \\mbox{Quartile}", "Median", "Mean", 
                       "3rd \\mbox{Quartile}", "Maximum", "Standard \\mbox{Deviation}")

print(xtable(Table.1), sanitize.rownames.function=identity, hline.after = 1:nrow(Table.1))

## Make Table 2:

subsets<- function(variable, value){ # Example: "year", 2008
  pos<- which(valid[,variable] == value)
  N<- length(pos)
  
  if(length(intersect(pos, h_pos)) == 0){
    Means<- round(c(weighted.mean(valid[pos,"PM2.5"], valid[pos, "Pop_density"]), 
                    weighted.mean(valid[pos,"PM_Di"], valid[pos, "Pop_density"]),
                    weighted.mean(valid[pos,"PM_Reid"], valid[pos, "Pop_density"]), 
                    weighted.mean(valid[intersect(pos, m_pos),"PM2.5"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, m_pos),"PM_Di"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, m_pos),"PM_Reid"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    rep(NA, 3)),2)
    SDs<- round(c(sqrt(weighted_var(valid[pos,"PM2.5"], valid[pos, "Pop_density"])), 
                  sqrt(weighted_var(valid[pos,"PM_Di"], valid[pos, "Pop_density"])),
                  sqrt(weighted_var(valid[pos,"PM_Reid"], valid[pos, "Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM2.5"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM_Di"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM_Reid"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  rep(NA,3)),2)
    SDs<- paste0(SDs, ")")
  }else{
    Means<- round(c(weighted.mean(valid[pos,"PM2.5"], valid[pos, "Pop_density"]), 
                    weighted.mean(valid[pos,"PM_Di"], valid[pos, "Pop_density"]),
                    weighted.mean(valid[pos,"PM_Reid"], valid[pos, "Pop_density"]), 
                    weighted.mean(valid[intersect(pos, m_pos),"PM2.5"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, m_pos),"PM_Di"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, m_pos),"PM_Reid"], 
                                  valid[intersect(pos, m_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, h_pos),"PM2.5"], 
                                  valid[intersect(pos, h_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, h_pos),"PM_Di"], 
                                  valid[intersect(pos, h_pos), "Pop_density"]),
                    weighted.mean(valid[intersect(pos, h_pos),"PM_Reid"], 
                                  valid[intersect(pos, h_pos), "Pop_density"])),2)
    SDs<- round(c(sqrt(weighted_var(valid[pos,"PM2.5"], valid[pos, "Pop_density"])), 
                  sqrt(weighted_var(valid[pos,"PM_Di"], valid[pos, "Pop_density"])),
                  sqrt(weighted_var(valid[pos,"PM_Reid"], valid[pos, "Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM2.5"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM_Di"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, m_pos),"PM_Reid"],
                                    valid[intersect(pos, m_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, h_pos),"PM2.5"],
                                    valid[intersect(pos, h_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, h_pos),"PM_Di"],
                                    valid[intersect(pos, h_pos),"Pop_density"])),
                  sqrt(weighted_var(valid[intersect(pos, h_pos),"PM_Reid"],
                                    valid[intersect(pos, h_pos),"Pop_density"]))),2)
    SDs<- paste0(SDs, ")")
  }
  
  
  return(c(paste0(value, " \\mbox{(", N, ", ", length(intersect(pos, m_pos)),
                  ", ", length(intersect(pos, h_pos)),
                  ")}"), paste(Means, SDs, sep = " (")))
}

states<- sort(unique(valid$state))
States<- sapply(states, function(x) subsets("state", x))

Table.2<- t(States)
row.names(Table.2)<- Table.2[,1]

print(xtable(Table.2[,-1]), sanitize.text.function=identity, hline.after = 1:nrow(Table.2))


