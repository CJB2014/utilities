

setwd("C:/Users/Clemence.Burnichon/Documents/code_repo/Pointer")

library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyBS)
library(highcharter)
library(ggplot2)
library(plyr)
library(dplyr)
library(stringr)
library(shinydashboard)
library(tm)
library(wordcloud)


#-------------------------------------------------------------------------------------------#
# password and login creation 
#-------------------------------------------------------------------------------------------#

pwd <- data.frame(username = c('Admin','User','Clemens'),
                  password = c('passadmin','passuser','passclemens')
                  ,stringsAsFactors = F)

pwd$paste <- paste(pwd$username,pwd$password, sep = "_")

#-------------------------------------------------------------------------------------------#
# team names 
#-------------------------------------------------------------------------------------------#

team <- c('Clemens','Ellen', 'Joe','Harriet','Scott','Sean','Tim','Clemence','Ariful','Nick','Alexander',
          'Danis', 'Andre','Lucien','Chris','Abhishek','Theo','Constantinos','Nisha'
          ,'Laura'
          ,'Jack'
          ,'')

team2 <- c('Clemens','Ellen', 'Joe','Harriet','Scott','Sean','Tim','Clemence','Ariful','Nick','Alexander',
           'Danis', 'Andre','Lucien','Chris','Abhishek','Theo','Constantinos','Nisha'
           ,'Laura'
           ,'Jack')

team3 <- c('Clemens','Ellen', 'Joe','Harriet','Scott','Sean','Tim','Clemence','Ariful','Nick','Alexander',
           'Danis', 'Andre','Lucien','Chris','Abhishek','Theo','Constantinos','Nisha'
           ,'Laura'
           ,'Jack', '', 'Admin')


#-------------------------------------------------------------------------------------------#
# Reason to choose from in UI  
#-------------------------------------------------------------------------------------------#

  
reasons <- c('Demonstrated our values - Challenge'
             , 'Demonstrated our values - Support'
             , 'Demonstrated our values - Respect'
             ,'Demonstrated our values - Trust'
             , 'Went above and beyond what is expected'
             , 'Showed dedication to project', 'Another reason'
             ,'')

#-------------------------------------------------------------------------------------------#
# read date table to bring back for analytics and results 
#-------------------------------------------------------------------------------------------#


date_data <- read.csv('date_d.csv', header = T, stringsAsFactors = F, sep = ',')
date_data$CALENDAR_DATE <- as.Date(date_data$CALENDAR_DATE, format = '%d/%m/%Y')
date_data$week_of_period <- rep(rep(c(1,2,3,4),each= 7),13)




#-------------------------------------------------------------------------------------------#
# Function to save the users inputs 
#-------------------------------------------------------------------------------------------#

save_data <- function(data){ 
  data <- t(data)
  filename <- paste(as.integer(Sys.time()," ",""),'data.csv',sep = "_")
  write.csv(data,filename,row.names = F)
}



save_data2 <- function(data){ 
  data <- t(data)
  #names(data) <- fields
  filename <- paste(as.integer(Sys.time()," ",""),'nopoints.csv',sep = "_")
  write.csv(data,filename,row.names = F)
} 


save_data3 <- function(data){ 
  data <- t(data)
  #names(data) <- fields
  filename <- paste(as.integer(Sys.time()," ",""),'winner.csv',sep = "_")
  write.csv(data,filename,row.names = F)
} 



#-------------------------------------------------------------------------------------------#
# fields to save
#-------------------------------------------------------------------------------------------#


fields <- c('username'
            ,'name1','name2','name3','name4'
            ,'points1','points2','points3','points4'
            ,'reason1','reason2','reason3','reason4'
            ,'comment1','comment2','comment3','comment4')

nopoint_out <- c('name1','name2','name3','name4'
                 ,'points1','points2','points3','points4'
                 ,'NOPOINT','NOPOINT','NOPOINT','NOPOINT'
                 ,'NOPOINT','NOPOINT','NOPOINT','NOPOINT')
winner_out <-  c('name2','name3','name4'
                 ,5,'points2','points3','points4'
                 ,'winner__of_the_week','winner__of_the_week','winner__of_the_week','winner__of_the_week'
                 ,'winner__of_the_week','winner__of_the_week','winner__of_the_week','winner__of_the_week')

#-------------------------------------------------------------------------------------------#
# load data   -- results   
#-------------------------------------------------------------------------------------------#
list_file <- dir(pattern = "*_data.csv", full.names = T)

responses <- lapply(list_file, read.csv, header = T, sep = ',', stringsAsFactors = F )
responses <- do.call(rbind, responses)

list_file1 <- str_replace(list_file,'./','' )
list_file1 <- str_replace(list_file1,'_data.csv','' )
list_file1 <- as.Date(as.POSIXct(as.numeric(list_file1), origin = '1970-01-01'))
list_file1 <- list_file1 -7 

responses$CALENDAR_DATE <- list_file1

responses <- join_all(list(responses, date_data),by = "CALENDAR_DATE", type = 'inner', match = 'all' )

lifetime <- read.csv('lifetime.csv', header = TRUE, sep = ',', stringsAsFactors = F)

#-------------------------------------------------------------------------------------------#
# load winner and no point 
#-------------------------------------------------------------------------------------------#
## winner data 
winner_file <- dir(pattern = "*_winner.csv", full.names = T)

winner <- lapply(winner_file, read.csv, header = T, sep = ',', stringsAsFactors = F)
winner <- do.call(rbind, winner)

names(winner) <- fields

winner_file <- str_replace(winner_file, './','')
winner_file <- str_replace(winner_file, '_winner.csv', '')
winner_file <- as.Date(as.POSIXct(as.numeric(winner_file) , origin = '1970-01-01'))
winner_file <- winner_file - 7 

winner$CALENDAR_DATE <- winner_file

winner <- join_all(list(winner, date_data),by = "CALENDAR_DATE", type = 'inner', match = 'all' )

responses <- rbind(responses, winner)


## no points data 
nopoint_file <- dir(pattern = "*_nopoints.csv", full.names = T)

nopoint <- lapply(nopoint_file, read.csv, header = T, sep = ',', stringsAsFactors = F)
nopoint <- do.call(rbind, nopoint)
names(nopoint) <- fields


nopoint_file <- str_replace(nopoint_file, './','')
nopoint_file <- str_replace(nopoint_file, '_nopoints.csv', '')
nopoint_file <- as.Date(as.POSIXct(as.numeric(nopoint_file) , origin = '1970-01-01'))
nopoint_file <- nopoint_file - 7 

nopoint$CALENDAR_DATE <- nopoint_file

nopoint <- join_all(list(nopoint, date_data),by = "CALENDAR_DATE", type = 'inner', match = 'all' )

responses <-rbind(responses, nopoint)


#-------------------------------------------------------------------------------------------#
# analytics tab  
#-------------------------------------------------------------------------------------------#

##extract the data -------------------------------------------------------------------------#
new_giver <- rep(responses$username, 4)
new_name <- c(responses$name1, responses$name2, responses$name3, responses$name4)
new_points <- c(responses$points1, responses$points2, responses$points3, responses$points4)
new_reasons <- c(responses$reason1, responses$reason2, responses$reason3, responses$reason4)
new_comments <- c(responses$comment1, responses$comment2, responses$comment3, responses$comment4)
new_period <- rep(responses$FIN_PERIOD_NO, 4)
new_wop <- rep(responses$week_of_period, 4)

##create a long df instead of wide ---------------------------------------------------------#
res <- as.data.frame(cbind(new_giver,new_name,new_points,new_reasons,new_comments,new_period, new_wop), stringsAsFactors = F)
res$new_points <- as.integer(res$new_points)

## bring back lifetime data ----------------------------------------------------------------# 
res <- rbind(res, lifetime)


#-current week -----------------------------------------------------------------------------#
  
current_week <- date_data[date_data$CALENDAR_DATE==(Sys.Date()-7),6]
current_period <- date_data[date_data$CALENDAR_DATE==(Sys.Date()-7),3]


##aggreg for total point per receiver
t1 <- ddply(res, c("new_period", "new_wop","new_name"), summarise, points = sum(new_points))
t1 <- t1[complete.cases(t1),]
t1 <- t1[t1$new_period == current_period & t1$new_wop ==current_week,]

#-current period ---------------------------------------------------------------------------#

p1 <- ddply(res, c('new_period', 'new_name'), summarise , points =sum(new_points))
p1_2 <- p1[p1$new_period == current_period,]
p1_2 <- p1_2[complete.cases(p1_2),]


# last 3 periods ---------------------------------------------------------------------------#

m1 <- ddply(res,c('new_name'), summarise , points = sum(new_points))
m1 <- m1[complete.cases(m1),]




