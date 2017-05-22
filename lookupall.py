def lookupall(screennamelist):
    info = []
    for i in screennamelist:
        a = lookup(i) 
        info.append(a)
    info2 = [x for x in info if x is not None]
    info3 = [val for sublist in info2 for val in sublist]
    info4 = pd.DataFrame(info3,columns =['id','screenname','names','createdat','followercount','favouritecount','urls','locations','statuscount','friendcount','protected'])
    #return info3
    return info4 
