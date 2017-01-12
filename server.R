
shinyServer(function(input, output,session){
  
  #-------------------------------------------------------------------------------------------#
  # javascript functionality of the app  
  #-------------------------------------------------------------------------------------------#
  
  ## some point need to be given and  username need to be given 
  
  observe({
    check1 <- input$yourname %in% team2
    if(input$username ==''){
      shinyjs::disable("Submit")
    } else if (input$points1 + input$points2 +input$points3 +input$points4 == 0) {
      shinyjs::disable("Submit")
    } else if(input$points4 !=0  & input$name4=='') {
      shinyjs::disable("Submit")
    } else if (input$points1 == 0 & input$name1 =='' & input$username != '') { 
      shinyjs::disable("Submit")
    }else {
      shinyjs::enable("Submit")
    }
  })
  
  
  # observe({
  #   if(input$name1 == ''){
  #     shinyjs::disable("Submit")
  #   }else {
  #     shinyjs::enable("Submit")
  #   }
  # })
  
  ## disable submit is auto reward 
  observe({
    if(input$username == input$name1 | input$username==input$name2 | input$username==input$name3 | input$username==input$name4){
      shinyjs::disable("Submit")
    }else{
      shinyjs::enable("Submit")
    } 
  })

  ##disable do not want to give point if point are given or if no username 
  observe({
    if(input$name1 !=''){
      shinyjs::disable("nopoint")
    } else if (input$username == ''){
      shinyjs::disable("nopoint")
    }else{
      shinyjs::enable("nopoint")
    }
      
  })
  
  
  ##thank you message on submission
  observeEvent( 
    input$Submit, { 
      shinyjs::info('Thank you !! Your points have been allocated.')
    })
  
 ## show add point to winner for admin (here harriet)
  
  PW <- 'B1T3AM'
  
  observe({
    if(input$username=='Admin'){
      shinyjs::show('password')
    } else {
      shinyjs::hide('password')
    }
  })
  
  
  
  observe({
    if(input$username =='Admin' & input$password == 'B1T3AM'){
      shinyjs::show('winner')
      shinyjs::show('addwinner')
    } else {
      shinyjs::hide('winner')
      shinyjs::hide('addwinner')
    }
  })
  
  
  
  
  #-------------------------------------------------------------------------------------------#
  # Find the right date and display the year and week fo the period 
  #-------------------------------------------------------------------------------------------#
  
  out_date <- date_data[date_data$CALENDAR_DATE==Sys.Date(),]
  output$date_year <- renderText({
    out_date <- date_data[date_data$CALENDAR_DATE==Sys.Date(),]
    paste('YEAR : ',out_date$YEAR_NO)
    })

  output$date_period <- renderText({
    out_date <- date_data[date_data$CALENDAR_DATE==Sys.Date(),]
    paste('WEEK :' ,substr(out_date$WEEK_NO,5,6))
    })

  output$date_week <- renderText({
    out_date <- date_data[date_data$CALENDAR_DATE==Sys.Date(),]
    paste('WEEK ',out_date$week_of_period, 'of PERIOD', substr(out_date$FIN_PERIOD_NO,5,6))
    })



  
  #-------------------------------------------------------------------------------------------#
  # update sliders to always be equal to 20 maximum   
  #-------------------------------------------------------------------------------------------#
  
  
  observe({
    if (input$points1 == 20) { 
      updateSliderInput(session, "points2", value = 0, min = 0, max = 0)
    }else { 
      updateSliderInput(session, 'points2', value = 0 , min = 0 , max = 20 - input$points1)}
    
    })
  
  observe({
    if(input$points1 ==20 | input$points1 + input$points2 == 20){ 
      updateSliderInput(session, 'points3', value = 0, min = 0 , max = 0 )
    }else { 
        updateSliderInput(session, 'points3',value = 0, min = 0, max = 20 -(input$points1 + input$points2))}
  })
  
  observe({
    if(input$points1 ==20 | input$points2 == 20 | input$points1 + input$points2 + input$points3 == 20 | input$points3 ==20){
      updateSliderInput(session, 'points4',value = 0 , min = 0 , max = 0)
    }else { 
      updateSliderInput(session, 'points4',value = 0, min = 0, max = 20 - (input$points1 + input$points2 + input$points3))}
  })
 
  
  
 #  #-------------------------------------------------------------------------------------------#
 #  # Validation -- permission (username vs name of team rewarded)   
 #  #-------------------------------------------------------------------------------------------#
 # observe({
 #   if (input$name1 == input$username | input$name2 == input$yourname | input$name3 == input$yourname | input$name4 == input$yourname) {
 #     createAlert(session, 'alert1',title = 'Warning', content = 'You cannot reward yourself. Choose another colleague.', style = 'warning')}
 #   else {closeAlert(session, 'alert1') }
 # })
 #  
  
  
  
  #-------------------------------------------------------------------------------------------#
  # cache the input data to write back to files  
  #-------------------------------------------------------------------------------------------#
  
  
  dat <- reactive({
    dat <- sapply(fields, function(x) input[[x]])
    dat
  })

  #-------------------------------------------------------------------------------------------#
  # saving data in CSVs    
  #-------------------------------------------------------------------------------------------#
  
  
  observeEvent( 
    input$Submit, { save_data(dat())
  })

  #-------------------------------------------------------------------------------------------#
  # save no point allocated 
  #-------------------------------------------------------------------------------------------#
  
  dat2 <- reactive({
  dat2 <- input$username
  dat2 <- c(dat2, nopoint_out)
  dat2 <- as.data.frame(dat2)
  
  })
  
  observeEvent(
    input$nopoint,{ save_data2(dat2())
    }
  )
  
  #-------------------------------------------------------------------------------------------#
  # save winner of the week 
  #-------------------------------------------------------------------------------------------#
  dat3 <- reactive({
    dat3 <- sapply(c('username','winner'), function(x) input[[x]])
    dat3 <- c(dat3, winner_out)
    dat3
  })
  
  observeEvent(input$addwinner,{
    save_data3(dat3())
  })
  
  
  #-------------------------------------------------------------------------------------------#
  # analytics tab -- current week      
  #-------------------------------------------------------------------------------------------#

  ##graph with total point for everyone 
  output$t1_2 <- renderHighchart({
    
   hc_t1_2 <- highchart()%>%
     hc_add_series(data = t1$points, type = 'column', name = "Team", color = '#E67E22', dataLabels = list(align = 'center', enabled = T , format = "{point.y}pts"))%>%
     hc_xAxis(categories = t1$new_name)
  })
   
  ##participation 
  
  output$participation <- renderInfoBox({
    par <- round((length(unique(res[res$new_period==current_period & res$new_wop==current_week,1]))/length(team)),2)*100
    infoBox('Participation', paste(par,"%"),icon = icon('user'), color = 'navy')
  })
  
  #max point 
  
  output$max<- renderInfoBox({
    max_pts <- max(t1$points)
    infoBox('Maximum point received',paste(max_pts,'pts'), color = 'navy', icon = icon('cubes'))
  })
  
  #number of ppl receiving block 
  tot_ppl <- length(unique(t1$new_name))
  output$ppl <- renderInfoBox({
    
    infoBox('People who received blocks',paste(tot_ppl), icon = icon('users'), color = 'navy')
  })
  
  #reasons for this week
  
  output$t2_1 <- renderHighchart({
    t2 <- as.data.frame(table(res[res$new_period== current_period & res$new_wop==current_week,4]))
    t2$percent <- round(t2$Freq/sum(t2$Freq),2)*100
    hc_t2_1 <- highchart()%>%
      hc_add_series(data = t2$percent, type = 'column', name = 'Reasons', color = '#E67E22', dataLabels = list(align = 'center', enabled = T, format = "{point.y}%"))%>%
      hc_xAxis(categories = t2$Var1)
  })
  
  
  #-------------------------------------------------------------------------------------------#
  # analytics tab -- current period   
  #-------------------------------------------------------------------------------------------#
  
  ##graph with total point for everyone -- current period 
  output$p1_2 <- renderHighchart({
    
    hc_p1_2 <- highchart()%>%
      hc_add_series(data = p1_2$points, type = 'column', name = "Team", color = '#E67E22', dataLabels = list(align = 'center', enabled = T , format = "{point.y}pts"))%>%
      hc_xAxis(categories = p1_2$new_name)
  })
  
  ##participation 
  
  output$participation2 <- renderInfoBox({
    
    par2 <- round((length(unique(res[res$new_period==current_period,1]))/length(team)),2)*100
    infoBox('Participation', paste(par2,"%"),icon = icon('user'), color = 'navy')
  })
  
  #max point 
  
  output$max2<- renderInfoBox({
    max_pts2 <- max(p1_2$points)
    infoBox('Maximum point received',paste(max_pts2,'pts'), color = 'navy', icon = icon('cubes'))
  })
  
  #number of ppl receiving block 
  tot_ppl2 <- length(unique(p1_2$new_name))
  output$ppl2 <- renderInfoBox({
    
    infoBox('People who received blocks',paste(tot_ppl2), icon = icon('users'), color = 'navy')
  })
  
  #reasons for this week
  
  output$p2_1 <- renderHighchart({
    p2 <- res[res$new_period==current_period,]
    p2 <- as.data.frame(table(p2$new_reasons))
    p2$percent <- round(p2$Freq/sum(p2$Freq),2)*100
    hc_p2_1 <- highchart()%>%
      hc_add_series(data = p2$percent, type = 'column', name = 'Reasons', color = '#E67E22', dataLabels = list(align = 'center', enabled = T, format = "{point.y}%"))%>%
      hc_xAxis(categories = p2$Var1)
  })
  
  #-------------------------------------------------------------------------------------------#
  # analytics tab -- lifetime
  #-------------------------------------------------------------------------------------------#
  ##graph with total point for everyone -- current period 
  output$m1_2 <- renderHighchart({
    
    hc_m1_2 <- highchart()%>%
      hc_add_series(data = m1$points, type = 'column', name = "Team", color = '#E67E22', dataLabels = list(align = 'center', enabled = T , format = "{point.y}pts"))%>%
      hc_xAxis(categories = m1$new_name)
  })
  
  ##participation 
  
  output$participation3 <- renderInfoBox({
    par3 <- round(((length(unique(res[,1]))-2)/length(team)),2)*100
    infoBox('Participation', paste(par3,"%"),icon = icon('user'), color = 'navy')
  })
  
  #max point 
  
  output$max3<- renderInfoBox({
    max_pts3 <- max(m1$points)
    infoBox('Maximum point received',paste(max_pts3,'pts'), color = 'navy', icon = icon('cubes'))
  })
  
  #number of ppl receiving block 
  tot_ppl3 <- length(unique(m1$new_name))
  output$ppl3 <- renderInfoBox({
    
    infoBox('People who received blocks',paste(tot_ppl3), icon = icon('users'), color = 'navy')
  })
  
  #reasons for this week
  
  output$m2_1 <- renderHighchart({
    m2 <- as.data.frame(table(res$new_reasons))
    m2$percent <- round(m2$Freq/sum(m2$Freq),2)*100
    hc_m2_1 <- highchart()%>%
      hc_add_series(data = m2$percent, type = 'column', name = 'Reasons', color = '#E67E22', dataLabels = list(align = 'center', enabled = T, format = "{point.y}%"))%>%
      hc_xAxis(categories = m2$Var1)
  })
  
  #-------------------------------------------------------------------------------------------#
  # analytics tab -- text mining   
  #-------------------------------------------------------------------------------------------#
  
  

  
  
  
})