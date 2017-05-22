def get_all_timeline(df):
    for i in df['screenname']:
        get_all_tweets(i)