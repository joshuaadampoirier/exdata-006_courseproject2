exdata-006_courseproject2
=========================

Code and resulting plots related to Course Project 2 for Coursera course Exploratory Data Analysis

### Overview of Course Project 2
The goal of Course Project 2 is to explore the National Emissions Inventory database, examining fine particulate matter pollution in the United States over the 10-year period from 1999 through 2008.  The following questions have been posed (which have been quoted directly from the Course Project 2 submission page):

1.  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the **base** plotting system, make a plot showing the *total* PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
2.  Have total emissions from PM2.5 decreased in the **Baltimore City**, Maryland (fips == "24510") from 1999 to 2008?  Use the **base** plotting system to make a plot answering this question.
3.  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for **Baltimore City**?  Which have seen increases in emissions from 1999-2008?  Use the **ggplot2** plotting system to make a plot answer this question.
4.  Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
5.  How have emissions from motor vehicle sources changed from 1999-2008 in **Baltimore City**?
6.  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in **Los Angeles County**, California (fips == "06037").  Which city has seen greater changes over time in motor vehicle emissions?

### Overview of files included
- README.md
    - This file
- plot1.png
    - The plot resulting created by executing the **plot1()** function in *plot1.r*
    - This plot is saved to be 480 x 480 px
- plot1.r
    - This file contains the main function **plot1()** for question 1 of Course Project 2
- readRDSFile.r
    - This file contains the helper function **readRDSFile()** which is used to download and unzip (if necessary), and read the data file of interest
    
### Overview of Part One
Plot 1 can be seen below.  
![alt text](plot1.png)  
This plot was created using the *plot1.r* file found in this repository.  The fundamental flow of the program follows this basic algorithm:

1. Call the *readRDSFile()* function from the **readRDSFile.r** file found in this repository.
    - This file will check to see if the file to be read (*summarySCC_PM25.rds*) exists.  If it does not exist it is downloaded and unzipped.  Then the file is read into memory.
2. The emissions are summed for each year using the *aggregate()* function.
3. The results are plotted using the *PNG_Plot1()* function found in the **plot1.r** file
    - This function saves the plot as a PNG file in the *./code* subfolder (relative to the working directory).

