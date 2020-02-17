# Samarbeid om artikkelskriving i R med papaja

Workshop på HVL Kronstad 26. og 27. februar 2020. [Rom 110 - Finn med MazeMap](http://bit.ly/2vse5Qb)

Hei, alle sammen! Nå gleder vi oss til å se dere på workshop. Her kommer litt informasjon om opplegget. Ikke nøl med å [ta kontakt](mailto:henrik.sorlie@uib.no) dersom det er noe!  

Før dere møter er det viktig at dere har gjort noen forberedelser, så vi kan starte rett på og ikke bruke tid på workshopen til å installere programvare. Alt dere trenger å gjøre er gjengitt under.

Når dette er gjort (og dere har brukernavn på Zotero og GitHub), så svar på mailen du fikk, og bekreft deltakelse, samt oppgi brukernavnene dine på Zotero og GitHub.

## Kjøreplan
| Onsdag 26.2.      | Tid           | Innhold             | Ansvar |
|:------------------|:-------------:|:--------------------|:-------|
| Velkommen / Intro | 10:00-10:20 | Oppstart, velkommen | Alle   |
| Zotero            | 10:20-11:30 | * Hvorfor Zotero?<br>* Flytte EndNote bibliotek til Zotero<br>* Importere/legge til kilder<br>* Organisere biblioteket med tags<br>* Dele bibliotek med grupper     | Astrid |
| Pause             | 11:30-11:45 |                     |        |
| RMarkdown         | 11:45-12:45 | * Hva er Markdown/RMarkdown?<br>* Tekstformattering med Markdown<br>* Kodechunks<br>* Inline kode | Thomas P |
| Lunsj             | 12:45-13:30 |                     |        |
| Better BiBTeX og citr | 13:30-14:00 | * Sette keyboard shortcut for citr i RStudio<br>* Benytte citr til å sitere i RMarkdown<br>* Sitere fra delt bibliotek | Henrik |
| papaja            | 14:00-15:00 | * Oppsett av papaja-mal<br>* YAML front matter<br>* egne papaja-funksjoner: printnum() og apa_table() | Henrik |
| Pause             | 15:00-15:15 |                     |        |
| papaja forts.     | 15:15-16:15 |                     | Henrik |
| Pause             | 16:15-16:30 |                     |        |
| Git og GitHub     | 16:30-18:00 | * Hva er versjonskontroll?<br>* Sette opp lokal Git mot GitHub<br>* RStudio integrasjon mot GitHub<br>* Commit, diff, push, pull, branch, merge<br>* Jobbe med GitHub web-grensesnitt | Henrik |
| Felles middag for de som vil! | 19:00-??:?? |                     |        |
| **Torsdag 27.2.**     | **Tid**           | **Innhold**             | **Ansvar** |
| Samarbeid om artikkel | 09:00-12:30 | * Utgangspunkt i et GitHub repo som inneholder tom mal og data<br>* Alle inviteres, vi fordeler oppgaver og brancher. Noen jobber med analyser, andre begynner å skrive på ulike deler.<br>* Kildehenvisninger fra delt Zotero-bibliotek<br>* Pull request, merge og så setter vi det sammen<br>* Pauser ved behov | Henrik |
| Lunsj             | 12:30-13:15 |                     |        |
| Jobbe med egen artikkel | 13:15-14:45 | * Anledning til å få starthjelp med å flytte et eget pågående prosjekt inn i papaja og GitHub<br>* Pauser ved behov |     |
| Avslutning og evaluering | 14:45-15:00 | Takk til alle som deltok!<br>Hvordan kan neste papaja-workshop bli bedre? | |

## Forberedelser

Her er forberedelsene du trenger å gjøre på forhånd:

### R og RStudio
Regner med alle har dette fra før. Oppdater til siste versjon av begge deler (først R, så RStudio). Etter oppdatering av R og RStudio anbefales det at du kjører en runde i RStudio og oppdaterer alle pakkene du har. Sånn for sikkerhets skyld. Da er du klar for resten av lista:

### Zotero
* Zotero er straightforward å installere herfra: https://www.zotero.org/download/
* Fordi vi skal dele bibliotek med kilder trenger du en (gratis) Zotero-konto. Det får du her: https://www.zotero.org/user/register/
* Sørg for å slå på synking av biblioteket ditt i Zotero-innstillingene.
* For å bruke Zotero med RStudio trenger du Zotero-pluginen Better BibTex: https://retorque.re/zotero-better-bibtex/installation/

### TinyTeX
Du trenger en TeX-pakke for å lage PDFer av papaja-dokumentene dine. For papaja anbefales TinyTex, som du installerer i RStudio med følgende kode ([hentet fra papaja-manualen](https://crsh.github.io/papaja_man/introduction.html#getting-started)):

```r
if(!"tinytex" %in% rownames(installed.packages())) install.packages("tinytex")

tinytex::install_tinytex()
```

### papaja
papaja-pakken finnes ikke på CRAN (ennå), men installeres med følgende kode [hentet fra papaja-manualen](https://crsh.github.io/papaja_man/introduction.html#getting-started)):

```r
# Install devtools package if necessary
if(!"devtools" %in% rownames(installed.packages())) install.packages("devtools")

# Install the stable development verions from GitHub
devtools::install_github("crsh/papaja")
```

### Git og GitHub
Vi bruker Git og GitHub til versjonskontroll og samarbeid.

* Først, lag deg en GitHub-konto, hvis du ikke allerede har en:  https://github.com/join?source=header-home

For installasjon av Git lener jeg meg på [gjennomgangen til Jenny Bryan](https://happygitwithr.com):

* Installere Git: https://happygitwithr.com/install-git.html
* Konfigurer Git med brukernavnet og mailadresse: https://happygitwithr.com/hello-git.html Husk at du må oppgi mailadressen du brukte til å registrere deg på GitHub.

### citr
citr gir deg enkelt tilgang til å sitere fra Zotero-biblioteket ditt, inne i RStudio.
```r
install.packages("citr")`
```
RStudio må startes på nytt etter installasjon, for at citrs addin skal dukke opp på addins-menyen i RStudio.

## Det var det!

Gratulerer! Hvis du kom deg gjennom alle punktene uten feilmeldinger så hadde du flaks! Eller så var du dyktig!

Husk å svare på mail, og bekrefte deltakelse, samt oppgi Zotero- og GitHub-brukernavn. Sees!