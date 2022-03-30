## P.Pas 20220217
## Read "UpdateExperimenten" file and generates input file for graphs on YOUth website

library(digest)
df <- read.table('UpdateExperimenten.csv', sep=";", header=FALSE, comment.char="#",
                 na.strings=".", stringsAsFactors=FALSE,
                 quote="", fill=FALSE)

# return number of inclusions
YOUth_write_counts <- function(wave,cohort,subject,expType) {
  csvSize = dim(df)
  vars = array();
  n = 2:csvSize[1]
  iRow = 0
  for (i in n) { 
    if (df[i,2] == cohort & df[i,3] == wave & df[i,4] == subject & df[i,7] == expType) { 
      return(paste0(df[i,10],"\t"))
    }
  }
}

# selected experiment types with the most inclusions per category (MRI, EEG, etc.)
outputFile = 'stats.txt'
sink(outputFile)
wave = '9y'; cohort = 'K&T'; subject = 'Kinderen';
cat(YOUth_write_counts(wave,cohort,subject,'MRI scan: anatomie'))
cat(YOUth_write_counts(wave,cohort,subject,'Child social gaze'))
cat(YOUth_write_counts(wave,cohort,subject,'Trustgame'))
cat(YOUth_write_counts(wave,cohort,subject,'Parent child interaction: vakantie'))       
cat(YOUth_write_counts(wave,cohort,subject,'Games en sociale media'))
cat(YOUth_write_counts(wave,cohort,subject,'Speeksel'))
wave = '12y';
cat(YOUth_write_counts(wave,cohort,subject,'MRI scan: anatomie'))
cat(YOUth_write_counts(wave,cohort,subject,'Child social gaze'))
cat(YOUth_write_counts(wave,cohort,subject,'Trustgame'))
cat(YOUth_write_counts(wave,cohort,subject,'Parent child interaction: vakantie'))       
cat(YOUth_write_counts(wave,cohort,subject,'Games en sociale media'))
cat(YOUth_write_counts(wave,cohort,subject,'Speeksel'))

wave = '9y'; cohort = 'K&T'; subject = 'Ouders';
cat(YOUth_write_counts(wave,cohort,subject,'Uw gezondheid'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))
wave = '12y'; 
cat(YOUth_write_counts(wave,cohort,subject,'Uw gezondheid'))
cat(paste0("\t"))

wave = '5m'; cohort = 'B&K'; subject = 'Kinderen';
cat(YOUth_write_counts(wave,cohort,subject,'Facehouse'))
cat(YOUth_write_counts(wave,cohort,subject,'Infant social gaze'))
cat(YOUth_write_counts(wave,cohort,subject,'Parent child interaction'))
cat(YOUth_write_counts(wave,cohort,subject,'De gezondheid van mijn kind'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))
wave = '10m';
cat(YOUth_write_counts(wave,cohort,subject,'Facehouse'))
cat(YOUth_write_counts(wave,cohort,subject,'Infant social gaze'))
cat(YOUth_write_counts(wave,cohort,subject,'Parent child interaction'))
cat(YOUth_write_counts(wave,cohort,subject,'De gezondheid van mijn kind'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))
wave = '3y'; 
cat(YOUth_write_counts(wave,cohort,subject,'Facehouse'))
cat(YOUth_write_counts(wave,cohort,subject,'Infant social gaze'))
cat(YOUth_write_counts(wave,cohort,subject,'Parent child interaction'))
cat(YOUth_write_counts(wave,cohort,subject,'De gezondheid van mijn kind'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))

wave = '20w'; cohort = 'B&K'; subject = 'Moeders';
cat(YOUth_write_counts(wave,cohort,subject,'Echo'))
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))
wave = '30w';
cat(YOUth_write_counts(wave,cohort,subject,'Echo'))
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '5m'; 
cat(paste0("\t"))
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '10m';
cat(paste0("\t"))
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '3y'; 
cat(paste0("\t"))
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))

wave = '20w'; cohort = 'B&K'; subject = 'Partners';
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(YOUth_write_counts(wave,cohort,subject,'Wangslijmvlies'))
wave = '30w'; 
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '5m'; 
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '10m'; 
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
wave = '3y'; 
cat(YOUth_write_counts(wave,cohort,subject,'Grote gebeurtenissen in uw leven'))
cat(paste0("\t"))
closeAllConnections() 
