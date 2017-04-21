


library(RODBC)
library(twitteR)
library(rlist)
#----------------------------------------------------------------------------------
# Get data in R from DB
#----------------------------------------------------------------------------------
conn2 <- odbcConnect('***')
cust <- sqlQuery(conn2, "select top 100 * from dbo.cust_last_3_month a ")

sqlQuery(conn2, "with cte as (select top 100 * from dbo.cust_last_3_month) delete from cte")

print('data acquired and deleted ------------------- go')
#----------------------------------------------------------------------------------
# create screenNames
#----------------------------------------------------------------------------------
screenName1 <- paste0(cust$Forename, cust$Surname)
screenName2 <- paste0(cust$Surname,cust$Forename)
screenName3 <- sub('@.*','',cust$EmailAddress)

SN <- data.frame(screenName1, screenName2, screenName3, stringsAsFactors = F)

#----------------------------------------------------------------------------------
# Connect to twitter  
#----------------------------------------------------------------------------------

api_key = '***'
api_secret = '***'
token = '***'
token_secret = '***'


twitteR::setup_twitter_oauth(api_key,api_secret,token,token_secret)
print('connection to twitter ------- Done')
#----------------------------------------------------------------------------------
# lookup users 100 by 100 
#----------------------------------------------------------------------------------

user <- SN[,3]
user_matching <- twitteR::lookupUsers(users = user)
print('user handle-------- acquired')
#----------------------------------------------------------------------------------
# Creation of results
#----------------------------------------------------------------------------------

names_users <- NULL
desc<- NULL
statusesCount<- NULL
followerCount<- NULL
favoritesCount<- NULL
friendsCount<- NULL
socialID<- NULL
createdDate<- NULL
location<- NULL
id<- NULL
proected <- NULL

for (i in 1:length(user_matching)) {
  
  Matcher <- names(user_matching)
  names_users[[i]] <- user_matching[[i]]$name
  desc[i]<- user_matching[[i]]$description
  statusesCount[i]<- user_matching[[i]]$statusesCount
  followerCount[i]<- user_matching[[i]]$followersCount
  favoritesCount[i]<- user_matching[[i]]$favoritesCount
  friendsCount[i]<- user_matching[[i]]$favoritesCount
  socialID[i]<- user_matching[[i]]$screenName
  createdDate[i]<- user_matching[[i]]$created
  location[i]<- user_matching[[i]]$location
  id[i]<- user_matching[[i]]$id
  protected[i]<-user_matching[[i]]$protected
}

results <- data.frame( matcher = names(user_matching),
                       screenName = socialID,
                       statuscount = statusesCount,
                       description = desc,
                       followercount = followerCount,
                       favoriteccount = favoritesCount,
                       friendsCount = friendsCount,
                       location = location,
                       id = id ,
                       created = createdDate,
                       protectflag = protected
)

sqlSave(conn2, results, tablename = 'results_matching', append = T, rownames = F, colnames = F)
odbcClose(conn2)
print('Handle -------------------- in DB')


