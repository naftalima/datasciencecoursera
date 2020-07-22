## directory::: location of the CSV files
## id :: monitor ID numbers to be used

## Return a data frame of the from:
## id nobs
## 1  117
## 2  1041
## ...

## where 'id' is the monitor ID number and 'nobs' is the
## number of complete cases

complete <- function(directory, id){ 
  
  results <- data.frame(id=numeric(0),nobs=numeric(0))
  
  for (monitor in id){
    file_name <- paste(directory,'/',sprintf('%03d',monitor),'.csv',sep='')
    df <- read.csv(file = file_name)
    
    df_valid <- df[!is.na(df$sulfate),]
    df_valid <- df_valid[!is.na(df_valid$nitrate),]
    
    nobs <- nrow(df_valid)
    results <- rbind(results, data.frame(id=monitor,nbos=nobs))
  }
  results
}
