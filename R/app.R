#  Shiny app for NearRepeat model
#
#  Robert Long 2 Dec 2019
#
#  Requires user input to select an rda file
#  which must contain a data frame with the 
#  same name as the file
#  eg mydata.rda should contain a dataframe
#  called mydata and this dataframe should
#  contain X, Y, and time variables
#
#  The ranges of sptial pairs and temporal 
#  distance pairs are displayed after loading
#  
#  user also inputs vectors for spatial and 
#  temporal cut points
#


library(shiny)


ui <- fluidPage(
  
  titlePanel("Near Repeat Dashboard"),
  
  sidebarPanel(
    fileInput("file", label = "Choose a file to load (.rda)", accept = ".rda"),
    textInput('vec1', 'Enter a vector for spatial cut points (comma delimited)', "0,1,2"),
    
    # display range of spatial distance pairs
    tableOutput("spatcut"),
    hr(),
    textInput('vec2', 'Enter a vector for temporal cut points (comma delimited)', "0,1,2"),
    
    # display range of temporal distance pairs
    tableOutput("tempcut"),
    hr(),
    
    # display the plot
    actionButton(inputId="plot","Plot")
  ),
  mainPanel(
    
    # the plot
    plotOutput("NRSTplot")
  )
)

server <- shinyServer(function(input, output) {
  
  # fetch the data
  data <- reactive({
    req(input$file)
    file <- input$file$datapath
    load(file, envir = .GlobalEnv)
    dt1 <- get(substr(input$file$name, 1, nchar(input$file$name)-4))
    dt1 <- dt1[sample(nrow(dt1), 300),]  # for testing only
    
  })

  
  # compute range for spatial data pairs
  output$spatcut <- renderTable({
    mydf <- data()
    xy <- cbind(mydf$X, mydf$Y)
    s_dist <- dist(xy)
    paste(round(min(s_dist),0), " , ", round(max(s_dist),0))
  })
  
  # compute range for temporal data pairs 
  output$tempcut <- renderTable({
    mydf <- data()
    t_dist <- dist(mydf$date)
    paste(round(min(t_dist),0), " , ", round(max(t_dist),0))
  })
  
  # build data, do Knox test and output the plot
  observeEvent(input$plot,{
    sdss <- as.numeric(unlist(strsplit(input$vec1,",")))
    tdss <- as.numeric(unlist(strsplit(input$vec2,",")))

    dt1 <- data()

    nrmod <- NearRepeat(x = dt1$X, y = dt1$Y, time = dt1$date,
                        sds = sdss, tds = tdss)
    
    output$NRSTplot <- renderPlot({
        plot(nrmod)
    })
  })
})

shinyApp(ui = ui, server = server)