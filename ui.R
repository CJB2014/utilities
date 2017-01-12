

shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  #titlePanel(strong('Colleague Reward APP')),
  sidebarLayout(
  
  sidebarPanel(width = 2, tags$style(".well {background-color:#FFF;}")
                 ,tags$h4(textOutput(outputId = 'date_year')), tags$style('#date_year{color: orange; font-weight : bold}')
                 ,tags$h4(textOutput(outputId = 'date_period')),tags$style('#date_period{color: orange; font-weight : bold}')
                 ,tags$h4(textOutput(outputId = 'date_week')),tags$style('#date_week{color: orange; font-weight : bold}')
                 )
    ,mainPanel( 
      #bsAlert('alert1'),
      navbarPage(title = '',footer = HTML('<center><h5><i><font color = #5D6D7E>Colleague Reward App - Powered by Shiny - Developped by CJB</font></center></i></h5>'),
        tabPanel('Login'
                  ,HTML('<center><img src="logo1.jpg"></center>')
                 
                  ,HTML('<center> <h3> <span style="line-height: 150%" >This app lets you reward your colleagues for their hard work.
                                  In order to do so, go to the reward tab, select the colleagues you want to reward
                       , how many points you want to give and the reason why. 
                       <br><b>Remember the rules :</b><br><i> you can only give 20 points a week by blocks of 5 points and you cannot 
                       reward yourself !</i></span></h3></center>')
                  ,br()
                  ,br()
                  ,br()
                 
                            ,column(3,HTML('<center><h3><b>What is your name ?</b></h3></center>'))
                            ,column(3,selectInput(inputId = 'username', label = '', choices = team3 ,selected = '', multiple = F,width = '300px')
                                    ,hidden(passwordInput(inputId = 'password', label = 'Password', width = '300px'))
                                    ,hidden(selectInput(inputId = 'winner', label = '', choices = team ,selected = '', multiple = F,width = '300px'))
                                    ,hidden(actionButton(inputId = 'addwinner', label = 'Add 5 points to winner', icon = icon('gift'),width = '300px'
                                                                    ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733"))
                                    
                                    )
                 
                            
                   # ,textInput(inputId = 'password', label = 'Password', value = '')
                   # ,actionButton(inputId = 'login', label = 'Login', width = '200px'
                   #               ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733" )
                 
                 ,HTML('<center><img src="block2.jpg"></center>')
                 
        )
        
        ,tabPanel(title = 'Reward your colleague',
                  fluidRow( 
                    
                    HTML('<center><img src = "banner.jpg"></center>')
                    ,br()
                    ,br()
                    ,column(3,
                           verticalLayout('Colleague'
                                          ,selectInput(inputId = 'name1', label = '', choices = team ,selected = '', multiple = F,width = '300px')
                                          ,br()
                                          ,br()
                                          ,br()
                                          ,selectInput(inputId = 'name2', label = '', choices = team ,selected = '', multiple = F,width = '300px')
                                          ,br()
                                          ,br()
                                          ,selectInput(inputId = 'name3', label = '', choices = team ,selected = '', multiple = F,width = '300px')
                                          ,br()
                                          ,br()
                                          ,br()
                                          ,selectInput(inputId = 'name4', label = '', choices = team ,selected = '', multiple = F,width = '300px')
                                          ,br()
                                          ,br()
                                          ,actionButton(inputId = 'nopoint', label = 'I do not want to give point', icon = icon('thumbs-down'), width = '300px'
                                                      ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733")
                                          ))
                    ,column(3,
                            verticalLayout('Points'
                                           ,sliderInput(inputId = 'points1', label = '', min = 0, max = 20, step = 5, value = 0, ticks = T, width = '300px')
                                           ,br()
                                           ,sliderInput(inputId = 'points2', label = '', min = 0, max = 0, step = 5, value = 0, ticks = T, width = '300px')
                                           ,br()
                                           ,sliderInput(inputId = 'points3', label = '', min = 0, max = 0, step = 5, value = 0, ticks = T, width = '300px')
                                           ,br()
                                           ,sliderInput(inputId = 'points4', label = '', min = 0, max = 0, step = 5, value = 0, ticks = T, width = '300px')
                                           ))
                    ,column(3,
                            verticalLayout('Reasons'
                                           ,selectInput(inputId = 'reason1', label = '', choices = reasons ,selected = '', multiple = F,width = '300px')
                                           ,br()
                                           ,br()
                                           ,br()
                                           ,selectInput(inputId = 'reason2', label = '', choices = reasons ,selected = '', multiple = F,width = '300px')
                                           ,br()
                                           ,br()
                                           ,selectInput(inputId = 'reason3', label = '', choices = reasons ,selected = '', multiple = F,width = '300px')
                                           ,br()
                                           ,br()
                                           ,br()
                                           ,selectInput(inputId = 'reason4', label = '', choices = reasons ,selected = '', multiple = F,width = '300px')
                                           ))
                    ,column(3,
                            verticalLayout('Comments'
                                           ,textAreaInput(inputId = 'comment1', label = '', value = 'your comment...', width = '500px', resize = 'horizontal')
                                           ,br()
                                           ,textAreaInput(inputId = 'comment2', label = '', value = 'your comment...', width = '500px', resize = 'horizontal')
                                           ,br()
                                           ,textAreaInput(inputId = 'comment3', label = '', value = 'your comment...', width = '500px', resize = 'horizontal')
                                           ,br()
                                           ,textAreaInput(inputId = 'comment4', label = '', value = 'your comment...', width = '500px', resize = 'horizontal')
                                           ,br()
                                           ,br()
                                           ,br()
                                           ,actionButton(inputId = 'Submit', label = 'Submit', icon = icon('trophy'), width = '300px'
                                                        ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733")
                                           ))
                    
                    ,br()
                    ,br()
                    # ,actionButton(inputId = 'Submit', label = 'Submit', icon = icon('trophy'), width = '300px'
                    #               ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733")
                    # ,actionButton(inputId = 'nopoint', label = 'I do not want to give point', icon = icon('thumbs-down'), width = '300px'
                    #               ,style = "font-weight: bold; color:#FFF; background-color: #FF5733; border-color: #FF5733")
                    
                  ))
      
        ,tabPanel(title = 'Analytics', 
                  tabsetPanel(
                    tabPanel('Last week'
                   ,dashboardPage(skin = 'black',
                     dashboardHeader(title = 'Block Analytics', disable = T)
                     ,dashboardSidebar(disable = T)
                     ,dashboardBody(
                       fluidRow(
                         infoBoxOutput('participation')
                         ,infoBoxOutput('max')
                         ,infoBoxOutput('ppl')
                     
                        ,box(title = 'Point received', color= 'navy', solidHeader = T,
                            highchartOutput('t1_2'))
                        ,box(title = 'Reasons', color = 'navy', solidHeader = T
                             , highchartOutput('t2_1'))
                      )
                    )
                  )
                    ), tags$style("li[class=active] a{ font-weight:bold;")
                    ,tabPanel('Current Period',
                              dashboardPage(skin = 'black',
                                            dashboardHeader(title = 'Block Analytics', disable = T)
                                            ,dashboardSidebar(disable = T)
                                            ,dashboardBody(
                                                fluidRow(
                                                  infoBoxOutput('participation2')
                                                  ,infoBoxOutput('max2')
                                                  ,infoBoxOutput('ppl2')
                                                  
                                                  ,box(title = 'Point received', color= 'navy', solidHeader = T,
                                                       highchartOutput('p1_2'))
                                                  ,box(title = 'Reasons', color = 'navy', solidHeader = T
                                                       , highchartOutput('p2_1'))
                                                
                                              )
                                            )
                              ))
                    ,tabPanel('Lifetime',
                              dashboardPage(skin = 'black',
                                            dashboardHeader(title = 'Block Analytics', disable = T)
                                            ,dashboardSidebar(disable = T)
                                            ,dashboardBody(
                                              fluidRow(
                                                infoBoxOutput('participation3')
                                                ,infoBoxOutput('max3')
                                                ,infoBoxOutput('ppl3')
                                                
                                                ,box(title = 'Point received', color= 'navy', solidHeader = T,
                                                     highchartOutput('m1_2'))
                                                ,box(title = 'Reasons', color = 'navy', solidHeader = T
                                                     , highchartOutput('m2_1'))
                                              )
                                            )
                              ))
                    
                                             
                               
                  


                    )
                 )
                  
        
                  
                  
                  
                  )
      )
    )
  
  )
)


