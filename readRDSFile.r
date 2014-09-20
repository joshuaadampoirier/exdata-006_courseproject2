## readRDSFile() custom function
## #####################################################################################################
## 1) Checks if the data file of interest is located in the working directory
## 2) If not, the zip file which should contain it is downloaded and unzipped to the working directory
## 3) The data file is read and returned as a data frame
##
## PRE:     fname - the filename of the data file to be read
## POST:    data - a data frame containing the contents of the data file fname
## #####################################################################################################
readRDSFile <- function(fname) {
    
    ## if the file name does not exist, the zip file is downloaded and unzipped
    if (!file.exists(fname)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                      destfile = "NEI.zip")
        unzip("NEI.zip")
    }
    
    ## if the file can still not be found - throw error
    ## otherwise, read and return the data
    if (!file.exists(fname)) stop(paste("File ", fname, " could not be located in the NEI.zip file."))
    data <- readRDS(fname)
    
}