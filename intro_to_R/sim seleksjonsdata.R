

## Simulere seleksjonsdata

#install.packages("simstudy")
#library(simstudy)
#library(writexl)
#library(haven)

set.seed(47)

# Definere variabler og sammenhenger mellom dem

def <- defData(varname = "nr", dist = "nonrandom", formula = 7, id = "idnum")
def <- defData(def, varname = "ComVar", dist = "normal", formula = 0, variance = 1)
def <- defData(def, varname = "AE", dist = "normal", formula = 5, variance = 1.8)
def <- defData(def, varname = "Skolepoeng", dist = "normal", formula = "43 + 0.2 * ComVar + AE", variance = 4.9)
def <- defData(def, varname = "BS_karakter", dist = "normal", formula = "5.4 + 0.2 * ComVar + 0.3 * AE", variance = 1.2)
def <- defData(def, varname = "Tj_snitt", dist = "normal", formula = "6.4 + 0.2 * ComVar + 0.2 * AE + 0.3 * BS_karakter", variance = 1.3)
def <- defData(def, varname = "MF_SML", dist = "normal", formula = "3.7 + 0.3 * Tj_snitt + 0.3 * BS_karakter", variance = 0.8)
def <- defData(def, varname = "Hovedkarakter", dist = "normal", formula = "3.3 + 0.2 * Skolepoeng + 0.2 * BS_karakter + 0.2 * AE", variance = 0.6)
def <- defData(def, varname = "Gender", dist = "binary", formula = "0.8", link = "identity")
def <- defData(def, varname = "Skole", dist = "categorical", formula = "0.5;0.3;0.2")

# Generere n linjer data

data <- genData(400, def)
rm(def)

# Introdusere gruppeforskjeller

data[which(data$Gender == "0")]$Skolepoeng <- data[which(data$Gender == "0")]$Skolepoeng + 2
data[which(data$Gender == "0")]$AE <- data[which(data$Gender == "0")]$AE + 1
data[which(data$Skole == "1")]$Hovedkarakter <- data[which(data$Skole == "1")]$Hovedkarakter + 1.3
data[which(data$Skole == "3")]$Hovedkarakter <- data[which(data$Skole == "3")]$Hovedkarakter - 0.5
data[which(data$Skole == "1")]$Skolepoeng <- data[which(data$Skole == "1")]$Skolepoeng + 2
data[which(data$Skole == "3")]$Skolepoeng <- data[which(data$Skole == "3")]$Skolepoeng - 1
data[which(data$Skole == "2")]$MF_SML <- data[which(data$Skole == "2")]$MF_SML + 0.9
data[which(data$Skole == "3")]$MF_SML <- data[which(data$Skole == "3")]$MF_SML - 0.3

## Konvertere til tibble, fikse AE og faktorer på skole og gender

data <- tibble(
        ID = as.integer(data$idnum),
        Gender = factor(data$Gender, levels = c("0", "1"), labels = c("Kvinne", "Mann")),
        AE = as.integer(data$AE),
        Skolepoeng = data$Skolepoeng,
        BS_karakter = data$BS_karakter,
        Tj_snitt = data$Tj_snitt,
        MF_SML = as.integer(data$MF_SML),
        Hovedkarakter = data$Hovedkarakter,
        Skole = factor(data$Skole, levels = c("1", "2", "3"), labels = c("Krigsskolen", "Sjokrigsskolen", "Luftkrigsskolen"))
)

summary(data)

## Splitte opp i to datasett

seleksjonsdata <- data[,c("ID", "Gender", "AE", "Skolepoeng", "BS_karakter", "Tj_snitt")]
prestasjonsdata <- data[,c("ID", "Skole", "Hovedkarakter", "MF_SML")]
prestasjonsdata <- arrange(prestasjonsdata, desc(Hovedkarakter))
rm(data)

## Splitte prestasjonsdata opp i skoler

prestasjonsdataKS <- filter(prestasjonsdata, Skole == "Krigsskolen")
prestasjonsdataLKS <- filter(prestasjonsdata, Skole == "Luftkrigsskolen")
prestasjonsdataSKSK <- filter(prestasjonsdata, Skole == "Sjokrigsskolen")
rm(prestasjonsdata)

## Eksport

# library(haven)
# library(readxl)
# library(writexl)

write_sav(seleksjonsdata, "data/seleksjonsdata.sav")
write_xlsx(prestasjonsdataKS, "data/Prestasjonsdata Krigsskolen.xlsx", col_names = TRUE)
write_csv2(prestasjonsdataLKS, "data/LuftKS karakterer.csv")
write_xlsx(prestasjonsdataSKSK, "data/Karakterer og SML SKSK.xlsx", col_names = TRUE)


