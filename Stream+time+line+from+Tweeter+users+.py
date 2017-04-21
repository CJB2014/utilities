
# coding: utf-8

# # Exporting Timeline from Wonga users to csv files 
# ###### Stages : 
# ###### - load the handle from matching 
# ###### - take the first on only and rewirte the file to directory 
# ###### - create connection to twitter 
# ###### - stream up to 200 tweets for each user to a csv files

# In[109]:

import tweepy 
import csv
import os 
import pypyodbc
import pandas as pd 
from IPython.display import display, HTML





# In[121]:


users = pd.read_csv('handle.csv', header=0)
#display(users)

# grab only the users with at least one tweets
users = users[users['statuscount']>0]
users = users[users['ProtectFlag']== False]
display(users)

u = users['id'].iloc[0]
u = str(int(u))
#display(u)

## remove 1st row and save the csv in directory to reload new ones
#users = users.iloc[1:]
#users.to_csv('handle2.csv', sep =',',  index = False)

#a = pd.read_csv('handle2.csv', header = 0, quoting = csv.QUOTE_NONE )
#display(a)


# In[122]:

#Twitter API credentials
consumer_key = 'lp2xTbK2VFGKJ5NOmlZHLDZwp'
consumer_secret = 'lBnXP1gfNkcCVBX6mf6hRJqPRUg5VnQa8ifGqazkUHxWmQ12QB'
access_key = '811499707902070784-avZAePY1dJPEKZR8NOvMTbyy3fZaRJA'
access_secret = 'Hv7kSUOF9XBYsKziRzwmFqfvKf6wP3CRoXX0INAaJ6G4Y'


# In[123]:

# find is user protected 
def user_protected(id_tweet):
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_key, access_secret)
    api = tweepy.API(auth)
    a = api.lookup_users(id_tweet)
    print(id_tweet)

#user_protected(u)


# In[126]:

def get_all_tweets(screen_name):
	#Twitter only allows access to a users most recent 3240 tweets with this method
	
	#authorize twitter, initialize tweepy
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_key, access_secret)
	api = tweepy.API(auth)
	
	#initialize a list to hold all the tweepy Tweets
	alltweets = []	
	
	#make initial request for most recent tweets (200 is the maximum allowed count)
	new_tweets = api.user_timeline(screen_name = screen_name, count=200)
	
	#save most recent tweets
	alltweets.extend(new_tweets)
	
	#save the id of the oldest tweet less one
	oldest = alltweets[-1].id - 1
	
	#keep grabbing tweets until there are no tweets left to grab
	while len(new_tweets) > 0:
		print "getting tweets before %s" % (oldest)
		
		#all subsiquent requests use the max_id param to prevent duplicates
		new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest)
		
		#save most recent tweets
		alltweets.extend(new_tweets)
		
		#update the id of the oldest tweet less one
		oldest = alltweets[-1].id - 1
		
		print "...%s tweets downloaded so far" % (len(alltweets))
        print(screen_name)
	
	#transform the tweepy tweets into a 2D array that will populate the csv	
	outtweets = [[tweet.id_str, tweet.created_at, tweet.text.encode("utf-8")] for tweet in alltweets]
	
       
	#write the csv	
	with open('%s_tweets.csv' % screen_name, 'wb') as f:
		writer = csv.writer(f)
		writer.writerow(["id","created_at","text"])
		writer.writerows(outtweets)
	
	pass
	
        
for i in users['screenName']:
    get_all_tweets(i)
    
    


