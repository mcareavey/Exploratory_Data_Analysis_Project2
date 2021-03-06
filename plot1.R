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

## Q1 - Have total emissions from PM2.5 decreased in the United States from
## 1999 to 2008? Using the base plotting system, make a plot showing the
## total PM2.5 emission from all sources for each of the years 1999, 2002,
## 2005, and 2008.

# Create variable to sum all PM2.5 Emissions by Year
sumEmissionsYear <- aggregate(Emissions ~ year, NEI, sum)

# From this variable plot a bar chart showing Emissions by Year
barplot(height = sumEmissionsYear$Emissions,
        names.arg = sumEmissionsYear$year,
        xlab = "Years", ylab = "PM2.5 Emissions (in tons)",
        main = "Total US PM2.5 Emissions from 1999 to 2008")

# Create a PNG copy of the created bar chart
dev.copy(png, file ="plot1.png", height = 480, width = 480)
dev.off()
#################################################################