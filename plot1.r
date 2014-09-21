## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot1.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  Have total emissions from PM2.5 decreased in the Unite4d States from 1999 to 2008?  
##                  Using the base plotting system, make a plot showing the total PM2.5 emission from 
##                  all sources for each of the years 1999, 2002, 2005, and 2008.
## #####################################################################################################
## #####################################################################################################

## main function for reading, processing, and plotting plot1
plot1 <- function() {

    source("./code/readRDSFile.r")
    
    ## Call readRDSFile() helper function to download, unzip, and read in the data
    NEI <- readRDSFile("summarySCC_PM25.rds")
    
    ## Sum the emissions by year
    NEI <- aggregate(data.frame(NEI$Emissions), 
                     by=list(NEI$year), 
                     FUN=function(x){sum(as.numeric(x))})
    names(NEI) <- c("Year", "TotalEmissions")

    ## Create and save plot as a PNG file
    PNG_Plot1(NEI)
}

## helper function for plotting data to PNG file
PNG_Plot1 <- function(data) {
    
    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot1.png",
        width = 480,
        height = 480,
        units = "px",
        bg = "white") 
    
    ## Use base plotting system to plot the data and a linear regression model
    plot(data$Year, data$TotalEmissions, pch = 20,
         main="Total PM2.5 Emissions in the United States",
         xlab="Year",
         ylab="Total Emissions",
         xaxt='n')
    model <- lm(data$TotalEmissions ~ data$Year, data)
    abline(model, lwd=2)   
    axis(1, c(1999, 2002, 2005, 2008))
    
    dev.off()
}

