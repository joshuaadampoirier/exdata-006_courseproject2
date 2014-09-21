## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot3.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  Of the four types of sources indicated by the type (point, nonpoint, onroad, 
##                  nonroad) variable, which of these four sources have seen decreases in emissions 
##                  from 1999-2008 for Baltimore City?  Which have seen increases in emissions from 
##                  1999-2008?  Use the ggplot2 plotting system to make a plot answer this question.
## #####################################################################################################
## #####################################################################################################

plot3 <- function() {
    
    source("./code/readRDSFile.r")
    
    ## Call readRDSFile() helper function to download, unzip, and read in the data
    NEI <- readRDSFile("summarySCC_PM25.rds")
    
    ## Limit data set to Baltimore City (fips = 24510), and sum emissions by year
    NEI <- NEI[NEI$fips=="24510",]
    NEI <- aggregate(data.frame(NEI$Emissions), 
                     by=list(NEI$type, NEI$year), 
                     FUN=function(x){sum(as.numeric(x))})
    names(NEI) <- c("Type", "Year", "TotalEmissions")     
    
    ## Create and save plot as PNG file
    PNG_Plot3(NEI)
}

PNG_Plot3 <- function(data) {

    library(ggplot2)
    
    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot3.png",
                width = 480,
                height = 480,
                units = "px",
                bg = "white") 
    
    ## Use ggplot2 system to plot the data and linear regression lines
    g <- ggplot(data, aes(x=Year, y=TotalEmissions), fill=seq(1:4))
    g <- g + geom_point(aes(group=Type, color=Type, size=2)) + 
        geom_smooth(aes(group=Type, color=Type), method="lm", se=FALSE, size=1.5) + 
        labs(x="Year") + 
        labs(y="Total Emissions") + 
        labs(title="PM2.5 Emissions by Type for Baltimore City") + 
        theme(legend.position="bottom") + 
        scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
    print(g)
    
    dev.off()
    
}