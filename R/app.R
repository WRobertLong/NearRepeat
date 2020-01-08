#  Shiny app for NearRepeat model
#
#  Robert Long 2 Dec 2019
#
#
# 


library(shiny)

ui <- fluidPage(
  
  titlePanel("Near Repeat Dashboard"),
  mainPanel(
    fileInput("file", label = ""),
    actionButton(inputId="plot","Plot"),
    tableOutput("contents"),
    plotOutput("NRSTplot")
  )
)

server <- shinyServer(function(input, output) {
  observeEvent(input$plot,{
    if ( is.null(input$file)) return(NULL)
    inFile <- isolate({input$file})
    file <- inFile$datapath
    load(file, envir = .GlobalEnv)
    dt <- chicago_be
    dt1 <- dt[sample(nrow(dt), 300),]
    nrmod <- NearRepeat(x = dt1$X, y = dt1$Y, time = dt1$date,
                        sds = c(0, 10, 20, 30, 40, Inf), tds = c(0,2,4,6))
    
    # Plot the data
    output$NRSTplot <- renderPlot({
        plot(nrmod)
    })
  })
})

shinyApp(ui = ui, server = server)