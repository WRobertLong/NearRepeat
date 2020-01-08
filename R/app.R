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
#  user also inputs vectors for spatial and 
#  temporal cut points
#


library(shiny)


ui <- fluidPage(
  
  titlePanel("Near Repeat Dashboard"),
  mainPanel(
    fileInput("file", label = ""),
    textInput('vec1', 'Enter a vector for spatial cut points (comma delimited)', "0,1,2"),
    textInput('vec2', 'Enter a vector for temporal cut points (comma delimited)', "0,1,2"),
    actionButton(inputId="plot","Plot"),
    tableOutput("contents"),
    plotOutput("NRSTplot")
    #h4('You entered'),
    #verbatimTextOutput("oid2")
  )
)

server <- shinyServer(function(input, output) {
  
  #output$oid2<-renderPrint({
  #  sdss <- as.numeric(unlist(strsplit(input$vec1,",")))
  #  cat("As atomic vector:\n")
  #  print(sdss)
  #})
  
  observeEvent(input$plot,{
    sdss <- as.numeric(unlist(strsplit(input$vec1,",")))
    tdss <- as.numeric(unlist(strsplit(input$vec2,",")))
    if (is.null(input$file)) return(NULL)
  
    inFile <- isolate({input$file})
    file <- inFile$datapath
    load(file, envir = .GlobalEnv)
    dt <- get(substr(inFile$name, 1, nchar(inFile$name)-4))
    dt1 <- dt[sample(nrow(dt), 300),]  # for testing only
    
    nrmod <- NearRepeat(x = dt1$X, y = dt1$Y, time = dt1$date,
                        sds = sdss, tds = tdss)
    
    # Plot the data
    output$NRSTplot <- renderPlot({
        plot(nrmod)
    })
  })
})

shinyApp(ui = ui, server = server)