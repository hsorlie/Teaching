
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
            hr(),
            sliderInput("outlier", "Strength of outlier:", min = 0, max = 10, value = 0),
            actionButton("update", "Reload")
        ),
        
        mainPanel(
            
            tabsetPanel(
                tabPanel("Plot", plotOutput("plot")), 
                tabPanel("Data", tableOutput("data")))

        )),hr(),includeMarkdown("explanation.md"),hr(),includeMarkdown("footer.md")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$update, {

            r <- matrix(cbind(1,.8,.5,.3,.1,0,  .8,1,.8,.5,.3,.1,  .5,.8,1,.8,.5,.3,  .3,.5,.8,1,.8,.5,  .1,.3,.5,.8,1,.8,  0,.1,.3,.5,.8,1),nrow=6)
            u <- t(chol(r))
            nvars <- dim(u)[1]
            numobs <- 200
            
            
            random.normal <- matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
            x <- u %*% random.normal
            newx <- t(x)
            raw <- as.data.frame(newx)
            names(raw) <- c("original","vstrong","strong", "moderate", "weak", "noncor")
            raw <- mutate(raw,
                   perfect = original)
            
            raw[1,1] <- raw[1,1] + input$outlier*5
            raw[1,c(2,3,4,5,6,7)] <- raw[1,c(2,3,4,5,6,7)] - input$outlier*5
            
            
            output$data <- renderDataTable({
                if(input$strength == "perfect"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$perfect, digits = 3))}
                if(input$strength == "verystrong"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$vstrong, digits = 3))}
                if(input$strength == "strong"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$strong, digits = 3))}
                if(input$strength == "moderate"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$moderate, digits = 3))}
                if(input$strength == "weak"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$weak, digits = 3))}
                if(input$strength == "noncor"){data <- tibble(x = round(raw$original, digits = 3),y = round(raw$noncor, digits = 3))}
            
            data
            })
            

            output$plot <- renderPlot({    
            
            if(input$strength == "perfect"){     
                plot <- ggplot(data = raw) + 
                    geom_point(mapping = aes(
                        x = original,
                        y = perfect)) +
                    geom_smooth(
                        mapping = aes(
                            x = original,
                            y = perfect,
                            colour = I("blue2")),
                        size = 2,
                        method = "lm") +
                    scale_x_continuous(
                        name = "x") +
                    scale_y_continuous(
                        name = "y") +
                    theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                    geom_label(aes(x = -Inf, y = Inf, hjust = -1, vjust = 1), label = paste("r =", round(cor(raw$original,raw$perfect), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
            }   
            if(input$strength == "verystrong"){     
                plot <- ggplot(data = raw) + 
                    geom_point(mapping = aes(
                        x = original,
                        y = vstrong)) +
                    geom_smooth(
                        mapping = aes(
                            x = original,
                            y = vstrong,
                            colour = I("blue2")),
                        size = 2,
                        method = "lm") +
                    scale_x_continuous(
                        name = "x") +
                    scale_y_continuous(
                        name = "y") +
                    theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                    annotate("text", x = -2, y = 1.4, label = paste("r =", round(cor(raw$original,raw$vstrong), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
            }
       if(input$strength == "strong"){     
            plot <- ggplot(data = raw) + 
                geom_point(mapping = aes(
                    x = original,
                    y = strong)) +
                geom_smooth(
                    mapping = aes(
                        x = original,
                        y = strong,
                        colour = I("blue2")),
                    size = 2,
                    method = "lm") +
                scale_x_continuous(
                    name = "x") +
                scale_y_continuous(
                    name = "y") +
                theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                annotate("text", x = -2, y = 1.4, label = paste("r =", round(cor(raw$original,raw$strong), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
       }
            if(input$strength == "moderate"){     
                plot <- ggplot(data = raw) + 
                    geom_point(mapping = aes(
                        x = original,
                        y = moderate)) +
                    geom_smooth(
                        mapping = aes(
                            x = original,
                            y = moderate,
                            colour = I("blue2")),
                        size = 2,
                        method = "lm") +
                    scale_x_continuous(
                        name = "x") +
                    scale_y_continuous(
                        name = "y") +
                    theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                    annotate("text", x = -2, y = 1.4, label = paste("r =", round(cor(raw$original,raw$moderate), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
            }
            if(input$strength == "weak"){     
                plot <- ggplot(data = raw) + 
                    geom_point(mapping = aes(
                        x = original,
                        y = weak)) +
                    geom_smooth(
                        mapping = aes(
                            x = original,
                            y = weak,
                            colour = I("blue2")),
                        size = 2,
                        method = "lm") +
                    scale_x_continuous(
                        name = "x") +
                    scale_y_continuous(
                        name = "y") +
                    theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                    annotate("text", x = -2, y = 1.4, label = paste("r =", round(cor(raw$original,raw$weak), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
            }
            if(input$strength == "noncor"){     
                plot <- ggplot(data = raw) + 
                    geom_point(mapping = aes(
                        x = original,
                        y = noncor)) +
                    geom_smooth(
                        mapping = aes(
                            x = original,
                            y = noncor,
                            colour = I("blue2")),
                        size = 2,
                        method = "lm") +
                    scale_x_continuous(
                        name = "x") +
                    scale_y_continuous(
                        name = "y") +
                    theme(text = element_text(size=40), axis.title.y = element_text(angle = 0, vjust = 0.5)) +
                annotate("text", x = -2, y = 1.4, label = paste("r =", round(cor(raw$original,raw$noncor), digits = 3), sep = " "), hjust = 0, size = 8, family = "Courier")
            }
            print(plot)
        })
        
    }, ignoreNULL = FALSE)  
}

# Run the application 
shinyApp(ui = ui, server = server)
