## #####################################################################################################
## #####################################################################################################
## AUTHOR:      Joshua Poirier
## COURSE:      exdata-006
## PROJECT:     Course Project 2, plot6.r
##
## PURPOSE:     To answer the following question (quoted from the Course Project submission page):
##                  Compare emissions from motor vehicle sources in Baltimore City with emissions from 
##                  motor vehicle sources in Los Angeles County, California (fips == "06037").  Which 
##                  city has seen greater changes over time in motor vehicle emissions?
## MORE:        Find more information on this program in the README.md
## #####################################################################################################
## #####################################################################################################

## main function for reading, processing, and plotting plot 6
plot6 <- function() {
    
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
    BC <- NEI[NEI$fips=="24510",]
    BC <- aggregate(data.frame(BC$Emissions), 
                     by=list(BC$year), 
                     FUN=function(x){sum(as.numeric(x))})
    BC$City <- "Baltimore City"
    names(BC) <- c("Year", "VehicleEmissions", "City")

    ## sum the emissions (sourced from motor vehicles) by year for Los Angeles County (fips = "06037")
    LA <- NEI[NEI$fips=="06037",]
    LA <- aggregate(data.frame(LA$Emissions), 
                    by=list(LA$year), 
                    FUN=function(x){sum(as.numeric(x))})
    LA$City <- "Los Angeles County"
    names(LA) <- c("Year", "VehicleEmissions", "City")

    ## merge the motor vehicle emissions data frames for the two cities together
    NEI <- rbind(BC, LA)
    
    ## Create and save plot as PNG
    PNG_Plot6(NEI)
    
}

## helper function for plotting data to PNG file
PNG_Plot6 <- function(data) {
    
    library(ggplot2)
    
    ## Create graphics device object for PNG file to be output
    png(filename = "./code/plot6.png",
        width = 960,
        height = 480,
        units = "px",
        bg = "white") 
    
    ## Use ggplot2 system to plot the data and linear regression lines
    g <- ggplot(data, aes(x=Year, y=VehicleEmissions), fill=seq(1:2))
    g <- g + geom_point(aes(Year, VehicleEmissions, group=City, color=City)) +
        facet_wrap(~City, scales="free") +
        geom_smooth(aes(group=City, color=City),method="lm", se=FALSE) +
        labs(x="Year") +
        labs(y="Vehicle Emissions") +
        labs(title="Vehicle Emissions for Baltimore City and Los Angeles County") +
        scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
        theme(legend.position="bottom")
    print(g)
    
    dev.off()
    
}