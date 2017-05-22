

shinyServer(function(input, output, session) {
  
 output$value1 <- renderTable({
   infile <- input$filename
   
   if (is.null(infile)){
     return(NULL)
   }
     d <- read.csv(infile$datapath, header = T)
     head(d)
   
 })
    
 
  
  output$sample <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file){
      sample <- data.frame(URN = c(123), First_name = c('John'), Last_name= c('Smith'), email = c('John.Smith@dot.com'))
      write.csv(sample, past(file,'.csv',sep =''), row.names = F)
    }
  )
  
  observeEvent(input$start, {
    updateNavbarPage(session = session, inputId = 'nbp', selected = 'STEP 1')
  })

  

})
