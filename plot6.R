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

## Q6 - Compare emissions from motor vehicle sources in Baltimore City with
## emissions from motor vehicle sources in Los Angeles County, California
## (fips == "06037"). Which city has seen greater changes over time in
## motor vehicle emissions?

# Subset the NEI dataset to only on-road emissions in Baltimore and LA
subsetNEI <- NEI[(NEI$fips == "24510"|NEI$fips =="06037")
                 & NEI$type == "ON-ROAD",]

# Aggregate the subsetNEI data, splitting it out by year and fips
aggregatesubsetNEI <- aggregate(Emissions ~ year + fips, subsetNEI, sum)

# Create a scatterplot using ggplot2 to show the change in emissions
# group groups the fips into separate buckets, colour colours them
g <- ggplot(aggregatesubsetNEI, aes(factor(year), Emissions,
                                    group = fips, colour = fips))

## g <- g + facet_grid(. ~ fips) - Option to have the separate fips/locations
## on separate graphs; decided against adding it

# geom_line and _point added to display each city, decided against using
# geom_bar(stat = "identity") as I think a line graph displays the trend
# in a better manner
g <- g + geom_line() + geom_point()

# Change axes labels, title and legend box
# Legend box amended using scale attribute (values a required inclusion)
g <- g + xlab("Year") + ylab("Total Vehicle PM2.5 Emissions") +
        ggtitle("Baltimore and L.A. Vehicle PM2.5 Emissions by Year") +
        scale_color_manual("City", labels = c("L.A.", "Baltimore"),
                           values = c("red", "blue"))

# Print g to device
print(g)

# Create a PNG copy of the created line graph
dev.copy(png, file ="plot6.png", height = 480, width = 480)
dev.off()
#################################################################