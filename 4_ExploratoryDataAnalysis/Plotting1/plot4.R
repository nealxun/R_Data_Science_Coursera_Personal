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
# plot 4
png(file = "plot4.png")
# specify number of plots within one screen and adjust plot margin
par(mfrow = c(2, 2), mar = c(4,4,2,4))
# subplot1
with(df_sub, plot(Time, Global_active_power, type = "l",
                  xlab = "", ylab = "Global Active Power"))
# subplot2
with(df_sub, plot(Time, Voltage, type = "l",
                  xlab = "datetime", ylab = "Voltage"))
# subplot3
with(df_sub, plot(Time, Sub_metering_1, type = "l", 
                  xlab = "", ylab = "Energy sub metering"))
points(df_sub$Time, df_sub$Sub_metering_2, type = "l", col = "red")
points(df_sub$Time, df_sub$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering1", "Sub_metering2", "Sub_metering3"),
       lty = c(1,1), col = c("black", "red", "blue"), bty = "n")
# subplot 4
with(df_sub, plot(Time, Global_reactive_power, type = "l",
                  xlab = "datetime"))
dev.off()