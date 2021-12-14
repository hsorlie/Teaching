library(shiny)
library(shinyWidgets)
library(tibble)
library(ggplot2)
library(markdown)
library(scales)

ui <- fluidPage(

    # Application title
    titlePanel("The Central Limit Theorem"),

    sidebarLayout(
        sidebarPanel(
            includeText("top.txt"),hr(),
            sliderInput(inputId = "terninger",
                        label = "Number of dice per throw:",
                        min = 1,
                        max = 100,
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

# Fjerne dette senere
tabell$verdi <- rescale(tabell$verdi, to = c(1, 5), from = range(tabell$verdi, na.rm = TRUE, finite = TRUE))

tabell$topp <- ifelse(cumsum(tabell$antall)<=input$repetisjoner*0.95, 0, 1)
            
            ggplot(data = tabell, aes(x = verdi, y = antall)) + 
            geom_col(data = subset(tabell, topp == 0),
                mapping = aes(
                    colour = I("blue2"),
                    fill = I("cornflowerblue"))) +
                geom_col(data = subset(tabell, topp == 1),
                         mapping = aes(
                             colour = I("red"),
                             fill = I("pink"))) +
            scale_x_discrete(
                name = "Total value per throw",
                limits = as.character(1:5),
                breaks = as.character(1:5),
                labels = as.character(1:5)) +
                #limits = as.character(1:(6*input$terninger)),
                #breaks = as.character(input$terninger:(6*input$terninger)),
                #labels = as.character(input$terninger:(6*input$terninger))) +
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
