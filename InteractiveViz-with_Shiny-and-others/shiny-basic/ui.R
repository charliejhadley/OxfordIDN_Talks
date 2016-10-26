shinyUI(
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          sliderInput("mean", 
                      label = "mean", 
                      min = 1, 
                      max = 10, 
                      value = 5, 
                      step = 2),
          textInput("plot_label", 
                    label = "plot label", 
                    value = "my plot")),
        mainPanel(plotOutput("hist")))
    )
)