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

## Q4 - Across the United States, how have emissions from coal
## combustion-related sources changed from 1999–2008?

# Merge the two datasets (NEI and SCC) by the common variable "SCC"
NEISCC <- merge(NEI, SCC, by = "SCC")

# Write SCC file to an excel format so we can identify the variable column
# we need to pick out for grepl use
if(!file.exists("NEISCC.xlsx")){
        write.xlsx(NEISCC, "NEISCC.xlsx")
}
# Use grepl to create a variable that will identify all coal combustion
# related sources
coalVar <- grepl("coal", NEISCC$SCC.Level.Three, ignore.case = TRUE)

# Subset NEISCC using the grepl variable "coalVar"
coalSub <- NEISCC[coalVar,]

# Aggregate the coalSub data to be able to find out the total Emissions by
# year
coalAggregate <- aggregate(Emissions ~ year, coalSub, sum)

barplot(height = coalAggregate$Emissions,
        names.arg = coalAggregate$year,
        xlab = "Years", ylab = "PM2.5 Emissions (in tons)",
        main = "Total U.S. Coal-Combustion PM2.5 Emissions from 1999 to 2008")


# Create a PNG copy of the created bar chart
dev.copy(png, file ="plot4.png", height = 480, width = 480)
dev.off()
#################################################################