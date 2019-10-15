
library(tibble)
library(ggplot2)
library(sjPlot)

## Demo sentralgrenseteoremet

# Tiltenkt brukt til å forklare/demonstrere sentralgrenseteoremet i undervisning.
# For å bruke: Bytt ut tallene som angir "terninger" og "repetisjoner", og kjør all koden.
# Fornuftige verdier for antall terninger: 1-20 (1-4/5 holder i massevis for å forklare poenget).
# Fornuftige verdier for antall repetisjoner: 1-20000.

# Antall terninger pr. kast
terninger <- 3

# Antall ganger terningene kastes
repetisjoner <- 2000

# Lag en tom resultattabell
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

# Plott antall ganger vi fikk hvert resultat
plot <- ggplot(data = tabell) + 
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
        scale_y_continuous(name = "Antall kast") +
# Legg til normalfordelingskurve
        if(terninger > 1 & repetisjoner > 10){
        stat_function( 
                fun = function(x, mean, sd){ 
                        dnorm(
                                x = x,
                                mean = mean(tabell$verdi),
                                sd = sd(resultat)) * length(resultat)
                }, 
                args = c(mean = mean, sd = sd))
        }
print(plot)