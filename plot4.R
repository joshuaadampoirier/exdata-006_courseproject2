## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot4.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  Across the United States, how have emissions from coal combustion-related sources 
##                  changed from 1999-2008?
## MORE:        Find more information on this program in the README.md
## #####################################################################################################
## #####################################################################################################

## main function for reading, processing, and plotting plot 4
plot4 <- function() {

    library(dplyr)
    source("./code/readRDSFile.r")
    
    ## Call readRDSFile() helper function to download, unzip, and read in the data
    NEI <- readRDSFile("summarySCC_PM25.rds")
    SCC <- readRDSFile("Source_Classification_Code.rds")
    
    ## Subset SCC to only coal combustion-related sources, ie contain the word "Coal"
    y <- unlist(lapply(SCC$EI.Sector, function(x){grepl("Coal",x)}))
    SCC <- SCC[y,]
    
    ## applying inner_join to NEI and SCC subsets NEI to only rows which match (ie coal sources)
    NEI <- inner_join(SCC, NEI, by="SCC")
    rm(SCC)     # memory cleanup
    
    ## sum the emissions (sourced from coal) by year
    NEI <- aggregate(data.frame(NEI$Emissions), 
                     by=list(NEI$year), 
                     FUN=function(x){sum(as.numeric(x))})
    names(NEI) <- c("Year", "CoalEmissions")
    
    ## Create and save plot as PNG
    PNG_Plot4(NEI)
    
}

## helper function for plotting data to PNG file
PNG_Plot4 <- function(data) {
    
    library(ggplot2)
    
    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot4.png",
        width = 480,
        height = 480,
        units = "px",
        bg = "white") 
    
    ## Use ggplot2 system to plot the data and linear regression lines
    g <- ggplot(data, aes(x=Year, y=CoalEmissions))
    g <- g + geom_point(aes(Year, CoalEmissions)) + 
        geom_smooth(method="lm", se=FALSE) + 
        labs(x="Year") + 
        labs(y="Coal Emissions") + 
        labs(title="Coal PM2.5 Emissions in the United States") + 
        scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
        theme(legend.position="bottom") 
    print(g)
    
    dev.off()
    
}