## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot5.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore
##                  City?
## #####################################################################################################
## #####################################################################################################

## main function for reading, processing, and plotting plot 5
plot5 <- function() {

    library(dplyr)
    source("./code/readRDSFile.r")
    
    ## Call readRDSFile() helper function to download, unzip, and read in the data
    NEI <- readRDSFile("summarySCC_PM25.rds")
    SCC <- readRDSFile("Source_Classification_Code.rds")
    
    ## Subset SCC to only coal combustion-related sources, ie contain the word "Coal"
    y <- unlist(lapply(SCC$EI.Sector, function(x){grepl("Vehicles",x)}))
    SCC <- SCC[y,]
    
    ## applying inner_join to NEI and SCC subsets NEI to only rows which match (ie coal sources)
    NEI <- inner_join(SCC, NEI, by="SCC")
    rm(SCC)     # memory cleanup
    
    ## sum the emissions (sourced from motor vehicles) by year for Baltimore City (fips = "24510")
    NEI <- NEI[NEI$fips=="24510",]
    NEI <- aggregate(data.frame(NEI$Emissions), 
                     by=list(NEI$year), 
                     FUN=function(x){sum(as.numeric(x))})
    names(NEI) <- c("Year", "VehicleEmissions")
    
    ## Create and save plot as PNG
    PNG_Plot5(NEI)
    
}

## helper function for plotting data to PNG file
PNG_Plot5 <- function(data) {
    
    library(ggplot2)
    
    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot5.png",
        width = 480,
        height = 480,
        units = "px",
        bg = "white") 
    
    ## Use ggplot2 system to plot the data and linear regression lines
    g <- ggplot(data, aes(x=Year, y=VehicleEmissions))
    g <- g + geom_point(aes(Year, VehicleEmissions)) + 
        geom_smooth(method="lm", se=FALSE) + 
        labs(x="Year") + 
        labs(y="Vehicle Emissions") + 
        labs(title="Vehicle PM2.5 Emissions in Baltimore City") + 
        scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
        theme(legend.position="bottom") 
    print(g)
    
    dev.off()
    
}