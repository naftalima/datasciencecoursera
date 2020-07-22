## directory::: location of the CSV files
## pollutant::: "sulfate" or "nitrate"
## id :: monitor ID numbers to be used
## * ignoring  NA  values) 

pollutantmean <- function(directory, pollutant,id = 1:332){ 
  means <- c()
  for (monitor in id){
    file_name <- paste(directory,'/',sprintf('%03d',monitor),'.csv',sep='')
    df <- read.csv(file = file_name)
    df_pol <- df[,pollutant]
    means <- c(means, df_pol[!is.na(df_pol)])
  }
  mean(means)
}
