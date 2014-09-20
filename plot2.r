## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot2.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == 
##                  "24510") from 1999 to 2008?  Use the base plotting system to make a plot answering 
##                  this question.
## #####################################################################################################
## #####################################################################################################

## main function for reading, processing, and plotting plot 2
plot2 <- function() {
    
    source("./code/readRDSFile.r")
    
    ## Call readRDSFile() helper function to download, unzip, and read in the data
    NEI <- readRDSFile("summarySCC_PM25.rds")
    
    ## Limit data set to Baltimore City (fips = 24510), and sum emissions by year
    NEI <- NEI[NEI$fips=="24510",]
    NEI <- aggregate(data.frame(NEI$Emissions), 
                     by=list(NEI$year), 
                     FUN=function(x){sum(as.numeric(x))})
    names(NEI) <- c("Year", "TotalEmissions") 
    
    ## Create and save plot as PNG file
    PNG_Plot2(NEI)
}

## helper function for plotting data to PNG file
PNG_Plot2 <- function(data) {

    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot2.png",
        width = 480,
        height = 480,
        units = "px",
        bg = "white") 
    
    ## Use base plotting system to plot the data and a linear regression model
    plot(data$Year, data$TotalEmissions, pch = 20,
         main="Total PM2.5 Emissions in Baltimore City",
         xlab="Year",
         ylab="Total Emissions",
         xaxt='n')
    model <- lm(data$TotalEmissions ~ data$Year, data)
    abline(model, lwd=2)   
    axis(1, c(1999, 2002, 2005, 2008))
    
    dev.off()    
}