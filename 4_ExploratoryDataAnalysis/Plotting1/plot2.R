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
# plot2
png(file = "plot2.png")
with(df_sub, plot(Time, Global_active_power, type = "l",
                  ylab = "Global Active Power (kilowatts)", xlab = "",
                  yaxt = "n")
)
axis(2, at = seq(0, 6, by = 2))
dev.off()