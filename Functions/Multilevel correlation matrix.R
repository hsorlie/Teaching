# This function is intended for reporting descriptive statistics for multilevel data.
# It is an adapted version of a function proposed by github.com/lgluca
# It creates a common table with Means and Standard Deviations in the two first columns, and a correlation matrix in the preceding columns.
# However, it uses psych::statsBy to obtain between-level and within-level correlations, and report them above/below the diagonal respectively. 

glrstab<- function(x, group, export=FALSE) { # input is a dataset (x) that includes a grouping variable (group)
        
        rwg <-statsBy(x, group)$rwg	#within-level correlations
        pwg <-statsBy(x, group)$pwg	#within-level probabilities
        rbg <-statsBy(x, group)$rbg	#between-level correlations
        pbg <-statsBy(x, group)$pbg	#between-level probabilities
        
        # variable names are variable names from dataset excluding grouping variable
        varnames <- colnames(x)
        a <- which(varnames == group) 
        varnames <- varnames[-a]
        
        #define notions for within-level significance levels
        mystarswg <- ifelse(pwg < .001, "***"
                            , ifelse(pwg < .01, "**"
                                     , ifelse(pwg < .05, "*"
                                              , ifelse(pwg < .10, "", ""))))
        
        #define notions for between-level significance levels
        mystarsbg <- ifelse(pbg < .001, "***"
                            , ifelse(pbg < .01, "**"
                                     , ifelse(pbg < .05, "*"
                                              , ifelse(pbg < .10, "", ""))))
        
        #round r, define new matrix Rnewwg with the within-level correlations from rnd and paste mystars
        rndwg  <- papaja::printnum(rwg, gt1 = FALSE, digits = 2)  #round, drop leading 0 - Thanks CRSH!								                     
        Rnewwg <- matrix(paste(rndwg, mystarswg, sep=""), ncol=ncol(rndwg)) 
        
        #round r, define new matrix Rnewbg with the between-level correlations from rnd and paste mystars
        rndbg  <- papaja::printnum(rbg, gt1 = FALSE, digits = 2)  #round, drop leading 0 - Thanks CRSH!								                     
        Rnewbg <- matrix(paste(rndbg, mystarsbg, sep=""), ncol=ncol(rndbg)) 
        
        Rnew <- matrix(nrow = nrow(Rnewbg), ncol = ncol(Rnewbg))
        
        #remove 1.0 correlations from diagonal  and set the strings
        diag(Rnew) <- ""
        Rnew[upper.tri(Rnew)] <- Rnewbg[upper.tri(Rnewbg)] #between-level correlations above diagonal
        Rnew[lower.tri(Rnew)] <- Rnewwg[lower.tri(Rnewwg)] #within-level correlations below diagonal
        
        rownames(Rnew) <- paste(1:ncol(rndbg), varnames, sep=" ") #Row names are numbers and variable names
        colnames(Rnew) <- paste(1:ncol(rndbg), "", sep="") #Column names are just
        
        x <- psych::describe(x[-a]) #new 
        class(x) <- "data.frame" #new
        
        Rnew <- cbind(round(x[,c("mean", "sd")],2), Rnew) #describe x, M sD - put them in the matrix
        colnames(Rnew)[1:2] <- c("M","SD") #New column headers
        
        Rnew[Rnew == "NANA" | is.na(Rnew)] <- ""
        
        
        #export to clipboard
        
        if (export==TRUE){
                result<-write.table(Rnew
                                    , "clipboard"
                                    , sep=";"
                                    , row.names=FALSE)
        }
        else result <- Rnew
        return(result)
        
}


