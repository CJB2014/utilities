

rfm_model <- function(df){
  
  r <- quantile(df$recency, c(0.25,0.5,0.75))
  
  df$Re <- ifelse(df$recency<r[1],4,
                 ifelse(df$recency>=r[1] & df$recency<r[2],3,
                        ifelse(df$recency>=r[2] & df$recency<r[3],2,1)))
  
  
  
  df$Fr <-  ifelse(df$frequency<=1,1,
                   ifelse(df$frequency>1 & df$frequency<3,2,3))
  
  m <- quantile(df$monetary, c(0.2,0.4,0.6,0.8))
  
  df$Mo <-  ifelse(df$monetary<m[1],1,
                   ifelse(df$monetary>=m[1] & df$monetary<m[2],2,
                          ifelse(df$monetary>=m[2] & df$monetary<m[3],3,
                                 ifelse(df$monetary>=m[3],4,5))))
  df$Re <- as.factor(df$Re)
  df$Mo <- as.factor(df$Mo)
  df$Fr <- as.factor(df$Fr)
  
  df$score <- paste(df$Re,df$Fr,df$Mo, sep = '')
 #model <- list(df,r,m)
 #return(model)
  return(df)

}


