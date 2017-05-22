

shinyUI(fluidPage(
  navbarPage(title = 'WDMP', id = 'nbp',
              tabPanel('Home', id = 'Home', tags$head(includeCSS('www/custom.css')),
                         div(class = 'footer', "Developed with", icon('heart'), "in R and Rstudio for WDMP. Copyright", icon('copyright'))
                        ,div(class = 'header',
                             verticalLayout('WDMP Social Prospecting',
                                            img(class = 'topimg', src = 'top.png'),
                                            div(class = 'text', HTML("This tool let you enhance your customers data using social media feed. <br> Once you have uploaded your data we will be able to match your customers to their
                                                 social ID and then access their social conversation.")),
                                            actionButton(inputId = 'start', label = "Let's Start !", icon = icon('bolt'), width = '300px',style = "font-weight: bold ; color: #FFF; background-color:#CD2882") 
                                            ))),
             
             
             tabPanel('STEP 1', id = 'STEP 1', tags$head(tags$script(src="floating_sidebar.js")),tags$head(includeCSS('www/custom.css')),
                      div(class = 'footer', "Developed with", icon('heart'), "in R and Rstudio for WDMP. Copyright", icon('copyright')),
                      sidebarLayout(
                        sidebarPanel(width = 2,fileInput(inputId = 'filename', label = 'Upload your Customers File', multiple = F, accept = c('.csv')),
                                     radioButtons(inputId = 'todo', label = 'Choose an option: ', choices = c('Lookup Users', 'Get timelines', 'Both')),
                                     actionButton(inputId = 'submit', label = 'Submit !', icon = icon('bolt'), width = '300px',style = "font-weight: bold ; color: #FFF; background-color:#00ABC2")
                        ),
                        mainPanel(verticalLayout(div(class = 'header', 'Upload your customers file'),
                                                 div(class = 'text2',
                                                    HTML("You customers file should includes information such as: Unique Id, First name, Surname, email address <br>
                                                                          You can download an sample file using the link below <br>"),
                                                     actionLink(inputId ='sample', label = 'Download Sample File')),
                                                 tableOutput('value1'))
                                  
                          
                          
                        )
                      )),
             tabPanel('STEP 2'),
             tabPanel('STEP 3')
             )
    
  
  
  
  
  
  
  

))
