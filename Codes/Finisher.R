# Reading data set

player_dataset<-read.csv("E:/Cricinfo/cricinfo.csv",stringsAsFactors = FALSE)

# Explaining the data set

# Player.ID = ID assigned by cricinfo which was used for scrapping
# Player.Name = Name of the player ex. Sachin Tendulkar
# Inns = 1st innings or 2nd innings - batting 1st and 2nd
# OD.Number = universal number counting the number of ODIs
# cathes = no. of catches taken
# conc = number of runs conceded
# ground = the ground in which the corresponding ODI was played
# match.date = the date on which the match was played
# opp = Opposition
# overs = Overs bowled
# score = Runs scored
# st = stumping, applicable for wicket keepers
# wkts = no. of wickets taken

# Cleaning the data set

player_dataset_v1<-player_dataset[,-3] # Removing column called blank

player_dataset_v1<-player_dataset_v1[-which(is.na(player_dataset_v1$Inns)),] # Removing a row for each of the player which had blanks

player_dataset_v1[which(player_dataset_v1$cathes=="-"),"cathes"]<-0 # Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$conc=="-"),"conc"]<-0 # Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$overs=="-"),"overs"]<-0 # Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$score=="-"),"score"]<-0 # Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$st=="-"),"st"]<-0 # Making all the - to 0, actually in all the columns
player_dataset_v1[which(player_dataset_v1$wkts=="-"),"wkts"]<-0 # Making all the - to 0, actually in all the columns

player_dataset_v1$match.date<-as.Date(player_dataset_v1$match.date,format = "%d %b %Y") # Converting into date format for further operations

player_dataset_v1$opp<-data.frame(t(data.frame(lapply(player_dataset_v1$opp,function(x) strsplit(x," ")[[1]][2]))))[,1] # Removing "v" in opposition

player_dataset_v1[,"Carried.Bat"]<-data.frame(as.character(lapply(strsplit(player_dataset_v1$score, ''), function(x) which(x == '*'))))[,1] # Obtianing not-out and out status

player_dataset_v1[which(player_dataset_v1$Carried.Bat=="integer(0)"),"Carried.Bat.Stauts"]<-"Out/another innings/DNB/TDNB"
player_dataset_v1[which(player_dataset_v1$Carried.Bat!="integer(0)"),"Carried.Bat.Stauts"]<-"Not-out"

