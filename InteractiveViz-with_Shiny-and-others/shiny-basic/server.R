shinyServer(function(input, output){
    
    output$hist <- renderPlot({
      hist(rnorm(50, 
                 mean = input$mean, 
                 sd = input$mean / 2), 
           main = input$plot_label)
    })
    
  }
)