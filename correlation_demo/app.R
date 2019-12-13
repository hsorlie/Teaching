
library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Correlation demo"),
    
    sidebarLayout(
        sidebarPanel(
            includeMarkdown("top.md"),hr(),
            selectInput("strength", "Correlation strength:", list(
                "Perfect" = "perfect",
                "Very Strong" = "verystrong",
                "Strong" = "strong",
                "Moderate" = "moderate",
                "Weak" = "weak",
                "Uncorrelated" = "noncor"
            )),
            actionButton("update", "Reload")
        ),
        
        mainPanel(
            dataTableOutput("data"),
            plotOutput(outputId = "plot")
        )),hr(),includeMarkdown("explanation.md"),hr(),includeMarkdown("footer.md")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$update, {

        output$plot <- renderPlot({
    
#        output$data <- renderDataTable({
            
            r <- matrix(cbind(1,.8,.5,.3,.1,0,  .8,1,.8,.5,.3,.1,  .5,.8,1,.8,.5,.3,  .3,.5,.8,1,.8,.5,  .1,.3,.5,.8,1,.8,  0,.1,.3,.5,.8,1),nrow=6)
            u <- t(chol(r))
            nvars <- dim(u)[1]
            numobs <- 200
            
            
            random.normal <- matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
            x <- u %*% random.normal
            newx <- t(x)
            raw <- as.data.frame(newx)

            names(raw) <- c("original","vstrong","strong", "moderate", "weak", "noncor")
            #cor(raw)
            #plot(head(raw, 1000))
            

            
#        })
            
            
            ggplot(data = raw) + 
                geom_point(mapping = aes(
                    x = original,
                    y = strong)) +
                geom_smooth(
                    mapping = aes(
                        x = original,
                        y = ifelse(input$strength == "perfect", original, ifelse(input$strength == "verystrong", vstrong)),
                        colour = I("blue2")),
                    size = 2,
                    method = "lm") +
                scale_x_continuous(
                    name = "x") +
                scale_y_continuous(
                    name = "y") +
                theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) #+
                #annotate("text", x = -2, y = 1.4, label = paste("r =", cor(x,y), sep = " "), hjust = 0, size = 8, family = "Courier")
            
        })
        
    }, ignoreNULL = FALSE)  
}

# Run the application 
shinyApp(ui = ui, server = server)
