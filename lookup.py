def lookup(screen_name):
    info = []
    try: 
        a = api.get_user(screen_name)
        info.append(a)
        outusers_id = [[u.id, 
                u.screen_name,        
                u.name ,
                u.created_at,
                u.followers_count,
                u.favourites_count,
                u.url,
                u.location,
                u.statuses_count,
                u.friends_count,
                u.protected] for u in info]
        return outusers_id
    except Exception, e: 
        pass