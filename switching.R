setwd('C:/Users/Clemence.Burnichon/Documents/AGRICULTURE/CHICKEN SPRINT/SQL_data_extract')

library(stringr)
library(plyr)

dat <- read.csv('sample.csv', header = F, sep=',', stringsAsFactors = F)

#dat[1,1] <- str_replace(dat[1,1],'﻿','')

names(dat) <- c('cust_id' , 'sku', 'sku_desc','sku_key','quantity','date','trans_id','rank','count_sku')
dat$sku <- as.integer(dat$sku)

#--------------------------------------------------------------------------------------------------------------
# finding switching customers 
#--------------------------------------------------------------------------------------------------------------


for (i in 1:(dim(dat)[1]-1)){ 
    if(dat[i,1]==dat[i+1,1] & dat[i,3]==dat[i+1,3] & dat[i,8]==(dat[i+1,8]-1)){
      results[i] <- FALSE
      
    }else{
      results[i] <- TRUE
    }
    
  } 


d <- as.vector(do.call(rbind,results))
d <- c(d,FALSE)
dat$switch <- d



#--------------------------------------------------------------------------------------------------------------
# calculating % of switching  
#--------------------------------------------------------------------------------------------------------------

sku_trans <- as.data.frame(table(dat$sku), stringsAsFactors = F)
names(sku_trans) <- c('sku','count_of_trans')

sku_switch <- as.data.frame(table(dat$sku,dat$switch), stringsAsFactors = F)
sku_switch <- sku_switch[sku_switch$Var2==TRUE,]
names(sku_switch) <- c('sku','switched','count_of_times')

total_switching <- join_all(list(sku_trans,sku_switch), by = 'sku', type = 'inner', match = 'all')

total_switching$switching_percent <- total_switching$count_of_times/total_switching$count_of_trans


#--------------------------------------------------------------------------------------------------------------
# find the switching pair
#--------------------------------------------------------------------------------------------------------------
results2 <- list()

for (i in 1:dim(dat)[1]){ 
  
  if(dat[i,10]==TRUE){
    print(paste(dat[i,2],dat[i+1,2],sep = '/'))
    
    results2[i] <- paste(dat[i,2],dat[i+1,2],sep = '/')
    
  }else{
    FALSE
    results2[i] <- NA
  }
  
  }

switching_pairs <- as.data.frame(do.call(rbind,results2),stringsAsFactors = F)
names(switching_pairs) <- 'switching_pairs'


### split switching pairs 
ss <- as.data.frame(strsplit(switching_pairs$switching_pairs,'/'))
switching_pairs$sku2 <- sub('/', '',switching_pairs$switching_pairs)








