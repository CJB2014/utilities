setwd('C:/Users/Clemence.Burnichon/Documents/AGRICULTURE/CHICKEN SPRINT/SQL_data_extract')

library(stringr)
library(plyr)

dat <- read.csv('sample.csv', header = F, sep=',', stringsAsFactors = F)

dat[1,1] <- str_replace(dat[1,1],'﻿','')

names(dat) <- c('cust_id' , 'sku', 'sku_desc','sku_key','quantity','date','trans_id','rank','count_sku')
dat$sku <- as.integer(dat$sku)

#--------------------------------------------------------------------------------------------------------------
# finding switching customers 
#--------------------------------------------------------------------------------------------------------------

results <- list()
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

#--------------------------------------------------------------------------------------------------------------
# find segment and names of sku 1 & 2 
#--------------------------------------------------------------------------------------------------------------

 
ss <- t(as.data.frame(strsplit(switching_pairs$switching_pairs,'/')))

switching_pairs$sku1 <- ss[,1]
switching_pairs$sku2 <- ss[,2]

switching_pairs <- switching_pairs[complete.cases(switching_pairs),]

details <- read.csv('sku_details.csv', header= T, sep=',')
segment1 <- details[,c(3,5,7,8)]
names(segment1) <- c('cat1','segment1','sku1','sku_desc1')

segment2 <- details[,c(3,5,7,8)]
names(segment2) <- c('cat2','segment2','sku2','sku_desc2')


switching_pairs <- join_all(list(switching_pairs,segment1), by = 'sku1', type = 'inner', match = 'all')
switching_pairs <- join_all(list(switching_pairs,segment2), by = 'sku2', type = 'inner', match = 'all')


#--------------------------------------------------------------------------------------------------------------
# calculate switching fraction 
#--------------------------------------------------------------------------------------------------------------

##from 
switch_from <- as.data.frame(table(switching_pairs$sku1),stringsAsFactors = F)
names(switch_from) <- c('sku','count')

switch_from <- join_all(list(switch_from, sku_trans), by = 'sku', type = 'inner', match = 'all')
switch_from$switching_fraction_from <- round(switch_from$count/switch_from$count_of_trans,2)


## to 
switch_to <- as.data.frame(table(switching_pairs$sku2), stringsAsFactors = F)
names(switch_to) <- c('sku','count')

switch_to <- join_all(list(switch_to, sku_trans), by = 'sku', type = 'inner', match = 'all')
switch_to$switching_fraction_to <- round(switch_to$count/switch_to$count_of_trans,2)


#--------------------------------------------------------------------------------------------------------------
# switching fraction to and from 
#--------------------------------------------------------------------------------------------------------------

switching_fraction_from_to <- join_all(list(switch_from,switch_to), by = 'sku',type = 'full', match = 'all')



