#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Demo Sentralgrenseteoremet"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
            sliderInput(inputId = "terninger",
                        label = "Antall Terninger:",
                        min = 1,
                        max = 10,
                        value = 1),
            sliderInput(inputId = "repetisjoner",
                        label = "Antall ganger:",
                        min = 1,
                        max = 10000,
                        value = 1)
            ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput(outputId = "plot")
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {
    output$plot <- renderPlot({
        
        resultat <- integer(0)
        tabell <- tibble(
            verdi = input$terninger:(6*input$terninger),
            antall = 0)
            
# Gjenta det følgende så mange ganger som angitt
            for(i in 1:input$repetisjoner){
                # Kast antallet terninger som er angitt
                kast <- sample(1:6, size = input$terninger, replace = TRUE)
                # Legg summen av terningkastet til resultatet
                resultat <- c(resultat, sum(kast))
                tabell$antall[sum(kast)-(input$terninger-1)] <- tabell$antall[sum(kast)-(input$terninger-1)]+1
            }
            
            
            ggplot(data = tabell) + 
            geom_col(
                mapping = aes(
                    x = verdi,
                    y = antall,
                    colour = I("blue2"),
                    fill = I("cornflowerblue"))) +
            scale_x_discrete(
                name = "Verdi pr. terningkast",
                limits = as.character(1:(6*input$terninger)),
                breaks = as.character(input$terninger:(6*input$terninger)),
                labels = as.character(input$terninger:(6*input$terninger))) +
            scale_y_continuous(name = "Antall kast") +
                # Legg til normalfordelingskurve
                if(input$terninger > 1 & input$repetisjoner > 10){
                    stat_function( 
                        fun = function(x, mean, sd){ 
                            dnorm(
                                x = x,
                                mean = mean(tabell$verdi),
                                sd = sd(resultat)) * length(resultat)
                        }, 
                        args = c(mean = mean, sd = sd))
                }
})
}
# Run the application 
shinyApp(ui = ui, server = server)
