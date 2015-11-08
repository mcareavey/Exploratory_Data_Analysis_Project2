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

## Q5 - How have emissions from motor vehicle sources changed from 1999-2008
## in Baltimore City?

# Merge datasets NEI and SCC into one
NEISCC <- merge(NEI, SCC, by = "SCC")

# Subset the data so that it references Baltimore only
Baltimore <- NEI[NEI$fips=="24510",]

# Create a vector to reflect all "Vehicles" entry as TRUE.  Ignore case.
Vehicles <- grepl("Vehicles", Baltimore$EI.Sector, ignore.case = TRUE)

# Use vector to subset the Baltimore dataset
VehicleSubset <- Baltimore[Vehicles,]

# Use aggregate to give the sum of Emissions from Vehicles by year 
VehiclesTotal <- aggregate(Emissions ~ year, VehicleSubset, sum)

# Using ggplot create a new bar chart that shows Emissions by year
# for Vehicles
g <- ggplot(VehiclesTotal, aes(factor(year), Emissions))

# When creating the bar chart layer you need to include stat = "identity"
# in the brackets so that the layer will complete.  Otherwise it won't
# print g correctly (bars won't be there)
g <- g + geom_bar(stat ="identity") +
  xlab("Year") +
  ylab("Total Emissions of PM2.5 (in tons)") +
  ggtitle("Total Emissions by Vehicles in Baltimore from 1999 to 2008")

# Create a png file of the completed bar chart
dev.copy(png, "plot5.png", height = 480, width = 480)
dev.off()
#######################################################################