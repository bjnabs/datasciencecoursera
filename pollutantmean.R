
# importing file path
source('create_filepath.R')



# A function named 'pollutantmean' that calculates the mean of 
# a pollutant (sulfate or nitrate) across a specified list of monitors.
# takes three arguments: 'directory', 'pollutant', and 'id'.
# Given a vector monitor ID numbers, 'pollutantmean' reads that monitors'
# particulate matter data from the directory specified in the 'directory' argument
# and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA

#pollutantmean <- function (directory, pollutant, id = 1:332) {
        ## a 'directory' is a character vector of length 1 indicating the location of CSV files
        ## 'pollutant' is a character vector of length 1 indicating the name of the pollutant
        ## for which to calculate the mean; either 'sulfate' or 'nitrate'
        ## 'id' is an integer vector indicating the monitor ID numbers to be used
        
       # dt <- combibe(id, directory)
        
       # mean(!is.na(dt[c(pollutant),c(pollutant)]))
         
        
        ## return the mean of the pollutant across monitors list in the id vector (ignoring NA values). 
        ## ## Do not round off values
      #  sapply(dt$pollutant, mean)
#}

pollutantmean <- function(directory, pollutant, id = 1:332){
        
        dt <- combine(directory, id)
        clean_dt <- dt[!is.na(dt[c(pollutant)]),c(pollutant)]
        mean(clean_dt)
}

#Test code
#pollutantmean("specdata", "nitrate", 70:72)
#pollutantmean("specdata", "sulfate", 1:10)
set.seed(10)
x <- rep(0:1, each = 5)
e <- rnorm(10, 0, 20)
y <- 0.5 + 2 * x + e

library(datasets)
Rprof()
