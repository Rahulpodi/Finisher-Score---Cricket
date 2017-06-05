library(stringi)
library(stringr)
library(dplyr)
library(RColorBrewer)
library(tidyverse)
library(data.table)
library(scales)
# Reading player batting data set
player_dataset<-read.csv("E:/Cricinfo/Data/cricinfo_batting.csv",stringsAsFactors = FALSE)
# Reading match results data set
match_result_dataset<-read.csv("E:/Cricinfo/Data/cricinfo_match_results.csv",stringsAsFactors = FALSE)
##########################################################################################################
# Cleaning player dataset
# Changing column names
colnames(player_dataset)<-c("Player.ID","Player.Name","Fours","Sixes","BF",
                            "Blank","Dismissal","Ground","Inns","Mins","ODI.number",
                            "Opposition","POS","Runs","SR","Start.Date")
player_dataset_v1<-player_dataset[,-6] # Removing column called blank
# Removing a row for each of the player which had blanks - due to scrapping
player_dataset_v1<-player_dataset_v1[-which(player_dataset_v1$ODI.number==""),]
# Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$Fours=="-"),"Fours"]<-0
player_dataset_v1[which(player_dataset_v1$Sixes=="-"),"Sixes"]<-0
player_dataset_v1[which(player_dataset_v1$BF=="-"),"BF"]<-0
player_dataset_v1[which(player_dataset_v1$Dismissal=="-"),"Dismissal"]<-"No information"
player_dataset_v1[which(player_dataset_v1$Mins=="-"),"Mins"]<-0
player_dataset_v1[which(player_dataset_v1$POS=="-"),"POS"]<-0
player_dataset_v1[which(player_dataset_v1$SR=="-"),"SR"]<-0
# Unfortunately even "Inns" has a "-" - may be the match was abandoned
player_dataset_v1[which(player_dataset_v1$Inns=="-"),"Inns"]<-0
# Converting into date format for further operations
player_dataset_v1$Start.Date<-as.Date(player_dataset_v1$Start.Date,format = "%d %b %Y")
# Removing "v" in opposition
player_dataset_v1$Opposition<-data.frame(t(data.frame(lapply(player_dataset_v1$Opposition,function(x) strsplit(x," ")[[1]][2]))))[,1]
# Obtianing not-out and out status
player_dataset_v1[,"Carried.Bat"]<-data.frame(as.character(lapply(strsplit(player_dataset_v1$Runs, ''), function(x) which(x == '*'))))[,1] 
# Assigning the same
player_dataset_v1[which(player_dataset_v1$Carried.Bat=="integer(0)"),"Carried.Bat.Stauts"]<-"Out/DNB/TDNB"
player_dataset_v1[which(player_dataset_v1$Carried.Bat!="integer(0)"),"Carried.Bat.Stauts"]<-"Not-out"
# Removing the DNB,TDNB,sub,absent from the runs
player_dataset_v1<-player_dataset_v1[-which(player_dataset_v1$Runs=="DNB" | player_dataset_v1$Runs=="TDNB"| player_dataset_v1$Runs=="sub" | player_dataset_v1$Runs=="absent"),]
# Since not-out and out is determined, now the runs are made only numeric
player_dataset_v1[,"Runs.Changing"]<-data.frame(t(data.frame(lapply(player_dataset_v1$Runs,function(x) str_replace_all(x,"[[:punct:]]","")))))
# Creating player and ODI number concatenate to vlookup between data frames
player_dataset_v1[,"Concatenate"]<-paste0(player_dataset_v1[,"Player.Name"],player_dataset_v1[,"ODI.number"])
####################################################################################################################
# Similarly, cleaning match results dataset
match_result_dataset_v1<-match_result_dataset[,-5] # Removing column called blank
# Removing a row for each of the player which had blanks - due to scrapping
match_result_dataset_v1<-match_result_dataset_v1[-which(match_result_dataset_v1$ODI.Number==""),]
# Making all the - to 0 actually or NA's to 0 in all the columns - this doesnt affect much since
# they ae all from the 1st innings 99.9% of the times
match_result_dataset_v1[which(match_result_dataset_v1$Margin=="-"),"Margin"]<-"999"
match_result_dataset_v1[which(match_result_dataset_v1$Margin==""),"Margin"]<-"999"
match_result_dataset_v1[which(is.na(match_result_dataset_v1$BR)),"BR"]=999
# Again, concatenating player name and ODI number
match_result_dataset_v1[,"Concatenate"]<-paste0(match_result_dataset_v1[,"Player.Name"],match_result_dataset_v1[,"ODI.Number"])
####################################################################################################################
# Final dataset matching the two datasets
final_dataset<-player_dataset_v1[,c(1,2,10,17,18,19)]
final_dataset[,7:10]<-match_result_dataset_v1[match(final_dataset[,6],match_result_dataset_v1[,12]),c(3,4,6,9)]
final_dataset[,"Margin.Changing"]<-data.frame(t(data.frame(lapply(final_dataset$Margin,function(x) strsplit(x," ")[[1]][1]))))[,1]
# Changing data type
final_dataset$BR<-as.numeric(final_dataset$BR)
final_dataset$Runs.Changing<-as.numeric(as.character(final_dataset$Runs.Changing))
final_dataset$Margin.Changing<-as.numeric(as.character(final_dataset$Margin.Changing))
####################################################################################################################
final<-data.frame()
final_rawdata<-data.frame()
for(i in 1:length(unique(final_dataset$Player.Name)))
{
     print(unique(final_dataset$Player.Name)[i])
     # Subetting the corresponding player's data set
     corres_player<-final_dataset[which(final_dataset$Player.Name==unique(final_dataset$Player.Name)[i]),]
     if(nrow(corres_player)>50)
     {
       if(nrow(corres_player[which(corres_player$Result=="won" & corres_player$Bat=="2nd"),])>=25)
       {
                temp_data<-corres_player[which(corres_player$Runs.Changing>=30 & corres_player$Margin.Changing<=6 & corres_player$BR<=30 & corres_player$Carried.Bat.Stauts=="Not-out" & corres_player$Result=="won" & corres_player$Bat=="2nd"),]
                temp<-data.frame(unique(final_dataset$Player.Name)[i],fscore=as.numeric((nrow(corres_player[which(corres_player$Runs.Changing>=30 & corres_player$Margin.Changing<=6 & corres_player$BR<=30 & corres_player$Carried.Bat.Stauts=="Not-out" & corres_player$Result=="won" & corres_player$Bat=="2nd"),])/nrow(corres_player[which(corres_player$Result=="won" & corres_player$Bat=="2nd"),]))*100))
                colnames(temp)<-c("Player.Name","Finisher.Score")
                final<-rbind(final,temp)
                final_rawdata<-rbind(final_rawdata,temp_data)
       }
     }    
}
# Removing 0's in the final dataset
final<-final[-which(final[,2]<=0),]
final<-final[order(final[,2],decreasing = TRUE),]
write.csv(final,"E:/Cricinfo/Results/finisher_score.csv",row.names = FALSE)
write.csv(final_rawdata,"E:/Cricinfo/Results/finisher_score_rawdata.csv")
# Visualization but now only for year wise number of finishes
# Obtaining Start.Date
final_rawdata[,"Start.Date"]<-player_dataset_v1[match(final_rawdata$ODI.number,player_dataset_v1$ODI.number),"Start.Date"]
final_rawdata[,"Year"]<-format(final_rawdata[,"Start.Date"],"%Y")
# Assigning 1,2,3 etc., for each of the years present alongside the player in increasing
# order
top5<-final_rawdata[which(final_rawdata$Player.Name %in% final[1:5,1]),]
top5$Year<-as.numeric(top5$Year)
fill=c("#F08080","#5F9EA0", "#E1B378","#56B4E9", "#F0E442")
ggplot(top5,aes(x=Year,fill=Player.Name))+geom_area(stat = "bin",alpha=0.6,position = "stack")+
        labs(x="Year",y="Number of finishes",title="Consistency of finishers")+
        theme_classic()+scale_fill_manual(values = fill)