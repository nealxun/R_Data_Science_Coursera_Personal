# preparation
rm(list = ls())
library(dplyr)

# 1. loading the data
df <- read.table("household_power_consumption.txt", header = TRUE, 
                 sep = ";", na.strings = "?")
# subset the dataset
df_sub <- filter(df, Date %in% c("1/2/2007", "2/2/2007"))
# data type conversion
df_sub$Time <- paste(df_sub$Date, df_sub$Time, sep = " ")
df_sub$Time <- strptime(df_sub$Time, format = "%d/%m/%Y %H:%M:%S")
df_sub$Date <- as.Date(df_sub$Date, format = "%d/%m/%Y")

# 2. making plots
# plot1
# open a graphic device
png(file = "plot1.png")
with(df_sub, hist(Global_active_power, col = "red", 
                  xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
                  main = "Global Active Power", breaks = 15,
                  axes = FALSE)
)
# adjust axes
axis(1, at = seq(0, 6, by = 2))
axis(2, at = seq(0, 1200, by = 200))
# close the device
dev.off()