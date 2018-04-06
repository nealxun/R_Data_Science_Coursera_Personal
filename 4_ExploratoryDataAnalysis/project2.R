# R exploratory data analysis
# project 2, U.S. fine particulate matter pollution analysis over the 10-year period 1999-2008

# preparation
rm(list = ls())
library(plyr)
library(dplyr)
library(ggplot2)

# read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# subset for Baltimore City data
bal <- filter(NEI, fips == "24510")

# Q1. have total emissions from PM2.5 decreased in the U.S. from 1999 to 2008?
# calcuate the total emission for each year
total <- tapply(NEI$Emissions, as.factor(NEI$year), sum)
# draw the plot
png(file = "plot1.png")
barplot(total, ylab = "Total Emission", xlab = "Year", pch = 20, 
     main = "Total U.S. PM2.5 Emissions")
dev.off()
## total emissions from PM2.5 decreased in the U.S. from 1999 to 2008.


# Q2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# calculate the total emission for each year
bal_total <- tapply(bal$Emissions, as.factor(bal$year), sum)
# draw the plot
png(file = "plot2.png")
barplot(bal_total, ylab = "Total Emission", xlab = "Year", pch = 20, 
     main = "Total Baltimore City PM2.5 Emissions")
dev.off()
## decreased from 1999 to 2002 but then increased until 2005, finally decreaed from 2005 to 2008.


# Q3. Of the four types of sources indicated by type, which of these have seen decreases/increases in emissions
# from 1999 - 2008 for Baltimore City?
# change type column from char to factor
bal$type <- as.factor(bal$type)
# calculate total emission based on type and year
bal_typeyear <- ddply(bal, .(type, year), summarize, totalEmission = sum(Emissions))
# draw the plot
png("plot3.png")
g <- ggplot(bal_typeyear, aes(x = year, y = totalEmission, color = type))
g + 
geom_line() + 
geom_point() +
labs(x = "Year", y = "Total Emissions", 
     title = "Total PM2.5 Emissions by Different Sources in Baltimore City")
dev.off()
# Except Point type, all have seen decreases in emissions

# Q4. across the U.S., how have emissions from coal combustion-related sources changed from 1999-2008
# find the SCC name for coal combustion-related sources
SCC_coal <- filter(SCC, grepl("Fuel Comb", EI.Sector) & grepl("Coal", EI.Sector))
SCCname_coal <- SCC_coal$SCC
# filter NEI for coal combustion-related sources only
NEI_coal <- filter(NEI, SCC %in% SCCname_coal)
# calculate the total emission for each year
NEI_coal_total <- ddply(NEI_coal, .(year), summarize, totalEmission = sum(Emissions))
# draw the plot
png("plot4.png")
g <- ggplot(NEI_coal_total, aes(factor(year), totalEmission))
g + 
geom_bar(stat = "identity") +
labs(x = "Year", y = "Total Emissions", 
                   title = "Total U.S. PM2.5 Emissions from Coal Combustion-related sources")
dev.off()
# overall is decreasing, but slightly increased from 2002 to 2005


# Q5. how have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
# find SCC code for motor vehicle sources
SCC_motor <- filter(SCC, grepl("Mobile", EI.Sector))
SCCname_motor <- SCC_motor$SCC
# filter bal for motor vehicle sources
bal_motor <- filter(bal, SCC %in% SCCname_motor)
# calculate the total emission for each year
bal_motor_total <- ddply(bal_motor, .(year), summarize, totalEmission = sum(Emissions))
# draw the plot
png("plot5.png")
g <- ggplot(bal_motor_total, aes(factor(year), totalEmission))
g + 
geom_bar(stat = "identity") + 
labs(x = "Year", y = "Total Emissions", 
     title = "Total Baltimore City PM2.5 Emissions from motor vehicle sources")
dev.off()
# decreased from 1999 to 2003, then keep increasing.


# Q6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater 
# changes over time in motor vehicle emissions?
# find SCC code for motor vehicle sources
SCC_motor <- filter(SCC, grepl("Mobile", EI.Sector))
SCCname_motor <- SCC_motor$SCC
# baltimore city data
# filter for motor vehicle sources
bal_motor <- filter(bal, SCC %in% SCCname_motor)
# calculate the total emission for each year
bal_motor_total <- ddply(bal_motor, .(year), summarize, totalEmission = sum(Emissions))
# Los Angeles County data
los <- filter(NEI, fips == "06037")
# filter for motor vehicle sources
los_motor <- filter(los, SCC %in% SCCname_motor)
# calculate the total emission for each year
los_motor_total <- ddply(los_motor, .(year), summarize, totalEmission = sum(Emissions))
# combine baltimore and los angeles data
both <- merge(bal_motor_total, los_motor_total, by = "year")
# draw the plot
png("plot6.png")
par(mfrow = c(1, 2))
with(both, plot(year, totalEmission.x, type = "l", col = "red", ylab = "Total Emissions", 
     main = "Baltimore City"))
with(both, plot(year, totalEmission.y, type = "l", col = "blue", ylab = "Total Emissions", 
     main = "Los Angeles County"))
dev.off()
# in terms of absolute value, los angeles has seen greater changes. in terms of relative value, both
# have seen greater changes, but toward different directions.


