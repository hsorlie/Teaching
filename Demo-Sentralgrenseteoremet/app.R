library(shiny)
library(shinyWidgets)
library(tibble)
library(ggplot2)
library(markdown)

ui <- fluidPage(

    # Application title
    titlePanel("The Central Limit Theorem"),

    sidebarLayout(
        sidebarPanel(
            includeText("top.txt"),hr(),
            sliderInput(inputId = "terninger",
                        label = "Number of dice per throw:",
                        min = 1,
                        max = 10,
                        value = 1),
            sliderTextInput(inputId = "repetisjoner",
                        label = "Number of throws:",
                        choices = c("1", "2", "3", "4", "5", "10", "20", "50", "100", "200", "1000", "10000", "20000"),
                        selected = 1,
                        grid = TRUE),
            actionButton("update", "Roll'em again!", icon = icon("dice"))
        ),

        mainPanel(
           plotOutput(outputId = "plot")
        )),hr(),includeMarkdown("explanation.md"),hr(),includeMarkdown("footer.md")
        )

server <- function(input, output) {
    observeEvent(input$update, {
        

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
                name = "Total value per throw",
                limits = as.character(1:(6*input$terninger)),
                breaks = as.character(input$terninger:(6*input$terninger)),
                labels = as.character(input$terninger:(6*input$terninger))) +
            scale_y_continuous(name = "Number of throws") +
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
    }, ignoreNULL = FALSE)   
    
}

# Run the application 
shinyApp(ui = ui, server = server)
