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
        sidebarPanel(
            sliderInput("terninger",
                        "Antall Terninger:",
                        min = 1,
                        max = 20,
                        value = 1)
        ),
        sidebarPanel(
            sliderInput("repetisjoner",
                        "Antall ganger:",
                        min = 1,
                        max = 100,
                        value = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    resultat <- integer(0)
    tabell <- tibble(
        verdi = terninger:(6*terninger),
        antall = 0)
    
    # Gjenta det følgende så mange ganger som angitt
    for(i in 1:repetisjoner){
        # Kast antallet terninger som er angitt
        kast <- sample(1:6, size = terninger, replace = TRUE)
        # Legg summen av terningkastet til resultatet
        resultat <- c(resultat, sum(kast))
        tabell$antall[sum(kast)-(terninger-1)] <- tabell$antall[sum(kast)-(terninger-1)]+1
    }
    
        output$plot <- ggplot(data = tabell) + 
            geom_col(
                mapping = aes(
                    x = verdi,
                    y = antall,
                    colour = I("blue2"),
                    fill = I("cornflowerblue"))) +
            scale_x_discrete(
                name = "Verdi pr. terningkast",
                limits = as.character(1:(6*terninger)),
                breaks = as.character(terninger:(6*terninger)),
                labels = as.character(terninger:(6*terninger))) +
            scale_y_continuous(name = "Antall kast")

}

# Run the application 
shinyApp(ui = ui, server = server)
