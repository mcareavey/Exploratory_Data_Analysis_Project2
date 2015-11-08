### Course Project 2 - Exploratory Data Analysis
### Using data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

## Assign data to a variable to manipulate
# Set url and file names to variables
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
folderName <- "Quiz_2.zip"
fileName <- "SummarySCC_PM25.rds"
fileName2 <- "Source_Classification_Code.rds"

# Download PM2.5 Emissions file and assign filename
if(!file.exists(folderName)){
        download.file(url = fileURL,
                      destfile = folderName,
                      method = "curl")
}

# Unzip the file that's been downloaded
unzip(zipfile = folderName)

# Read both files into separate variables using the readRDS() function
NEI <- readRDS("SummarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#################################################################

## Q3 - Of the four types of sources indicated by the type (point, nonpoint,
## onroad, nonroad) variable, which of these four sources have seen
## decreases in emissions from 1999–2008 for Baltimore City? Which have seen
## increases in emissions from 1999–2008? Use the ggplot2 plotting system
## to make a plot answer this question.

# Use table to validate that there are four unique values in NEI$type
table(NEI$type)

# Create a variable subsetting out the Baltimore data from the overal dataset
Baltimore <- NEI[NEI$fips == "24510",]

# Create variable to sum all PM2.5 Emissions by Year & Type for Baltimore
sumEmissionsYearType <- aggregate(Emissions ~ year + type, Baltimore, sum)

# Create a scatter plot graph using ggplot2.  Colour by type
library(ggplot2)
scatterplot <- ggplot(sumEmissionsYearType,
                      aes(year, Emissions, color = type))

# Add layer with geom_line, improve labels & legend title and add overall
# title
scatterplot <- scatterplot + geom_line() +
        scale_colour_discrete(name = "Emission Type") +
        xlab("Year") + ylab("PM2.5 Emissions (in tons)") +
        ggtitle("Baltimore PM2.5 Emissions (by Type) from 1999 to 2008")

# Create a PNG copy of the created bar chart
dev.copy(png, file ="plot3.png", height = 480, width = 480)
dev.off()
#################################################################