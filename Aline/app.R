
library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("A Straight Line"),

    sidebarLayout(
        sidebarPanel(
            includeMarkdown("top.md"),hr(),
            sliderInput(inputId = "intercept",
                        label = "intercept: a",
                        min = -2,
                        max = 2,
                        value = 0.5,
                        step = 0.1),
            sliderInput(inputId = "slope",
                        label = "slope: b",
                        min = -2,
                        max = 2,
                        value = 0.5,
                        step = 0.1),
        ),
        
        mainPanel(
            plotOutput(outputId = "plot")
        )),hr(),includeMarkdown("explanation.md"),hr(),includeMarkdown("footer.md")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$update, {

    output$plot <- renderPlot({

        data <- tibble(
            x = seq(from = -3, to = 3, by = 0.1),
            y = input$intercept + input$slope * x
        )
                
        ggplot(data = data) + 
            geom_line(
                mapping = aes(
                    x = x,
                    y = y,
                    colour = I("blue2")),
                size = 2) +
            scale_x_continuous(
                name = "x",
                limits = c(-2,2),
                breaks = c(-2, -1, 0, 1, 2)) +
            scale_y_continuous(
                name = "y",
                limits = c(-2,2),
                breaks = c(-2, -1, 0, 1, 2)) +
            geom_vline(aes(xintercept = 0), show.legend = FALSE) +
            geom_hline(aes(yintercept = 0), show.legend = FALSE) +
            theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
            annotate("text", x = -2, y = 1.8, label = "y= a + b * x", hjust = 0, size = 8, family = "Courier") +
            annotate("text", x = -2, y = 1.4, label = paste("y=", input$intercept, "+", input$slope, "*x", sep = ""), hjust = 0, size = 8, family = "Courier")
            
            }
)
    }, ignoreNULL = FALSE)   
}

# Run the application 
shinyApp(ui = ui, server = server)
