# project 2 Tesla car delivery number over time

# preparation
rm(list = ls())
setwd("C:/Users/Nealxun/Desktop/DataScience_JHU/9DevelopingDataProducts/Project2")

# load necessary pacakgesmod
library(leaflet)
library(ggplot2)
library(tidyr)
library(plyr)
library(dplyr)
library(RCurl)
library(plotly)
library(openxlsx)
library(lubridate)
library(zoo)

# pre-defined functions
# cum sum reverse while keep the first observation as it is
my_diff <- function(x) {
        if (length(x) <= 1) {
                "please enter a vector with more than 2 elements"
        } else {
                c(x[1], diff(x))  
        }

}

###### Step 1 read raw data ######
# region zone assignment
df_region_zone <- read.xlsx("zone_region_conversion.xlsx")
# model 3, the data souces keep record of cumulative delivery numbers
df_m3 <- read.csv("Delivered_Cars_Over_Time_crosstab_model3.csv", skip = 1, 
                  header = TRUE, sep = "\t", fileEncoding="UTF-16LE", 
                  stringsAsFactors = FALSE)
df_ms <- read.csv("Delivered_Cars_Over_Time_crosstab_modelS.csv", skip = 1, 
                  header = TRUE, sep = "\t", fileEncoding="UTF-16LE", 
                  stringsAsFactors = FALSE)
df_mx <- read.csv("Delivered_Cars_Over_Time_crosstab_modelX.csv", skip = 1, 
                  header = TRUE, sep = "\t", fileEncoding="UTF-16LE", 
                  stringsAsFactors = FALSE)

###### Step 2 data pre-processing ######
## model 3 data
# remove last row
df_m3 <- head(df_m3, -1)
# first row first column fill
df_m3[1, 1] <- "NULL"
# change column names
names(df_m3)[1] <- "region"
# column type change
df_m3[, -1] <- sapply(df_m3[, -1], function (x){as.numeric(gsub(",", "", x))})
# change na value to 0
df_m3[is.na(df_m3)] <- 0

# calculate non cumulative qty for each region
df_m3_nonCum <- df_m3[, -1] %>% 
        apply(1, my_diff) %>%
        t() %>%
        as.data.frame() %>% 
        gather("month", "qty") %>%
        select(qty)

# unpivot table
df_m3_unpivot <- gather(df_m3, key = "month", value = "cumQty", -region)
# convert month to date type
df_m3_unpivot$month <- as.Date(paste0("1.", df_m3_unpivot$month), "%d.%B.%Y")

# combine the cum and noncum together
df_m3_final <- cbind(df_m3_unpivot, df_m3_nonCum)
# assgin zone to each region
df_m3_final <- right_join(df_region_zone, df_m3_final, by = c("region" = "region"))
# add model as the new column
df_m3_final$model <- "Model 3"


## model S data
df_ms <- head(df_ms, -1)
# first row first column fill
df_ms[1, 1] <- "NULL"
# change column names
names(df_ms)[1] <- "region"
# column type change
df_ms[, -1] <- sapply(df_ms[, -1], function (x){as.numeric(gsub(",", "", x))})
# change na value to 0
df_ms[is.na(df_ms)] <- 0

# calculate non cumulative qty for each region
df_ms_nonCum <- df_ms[, -1] %>% 
        apply(1, my_diff) %>%
        t() %>%
        as.data.frame() %>% 
        gather("month", "qty") %>%
        select(qty)

# unpivot table
df_ms_unpivot <- gather(df_ms, key = "month", value = "cumQty", -region)
# convert month to date type
df_ms_unpivot$month <- as.Date(paste0("1.", df_ms_unpivot$month), "%d.%B.%Y")

# combine the cum and noncum together
df_ms_final <- cbind(df_ms_unpivot, df_ms_nonCum)
# assgin zone to each region
df_ms_final <- right_join(df_region_zone, df_ms_final, by = c("region" = "region"))
# add model as the new column
df_ms_final$model <- "Model S"


## model X data
# remove last row
df_mx <- head(df_mx, -1)
# first row first column fill
df_mx[1, 1] <- "NULL"
# change column names
names(df_mx)[1] <- "region"
# column type change
df_mx[, -1] <- sapply(df_mx[, -1], function (x){as.numeric(gsub(",", "", x))})
# change na value to 0
df_mx[is.na(df_mx)] <- 0

# calculate non cumulative qty for each region
df_mx_nonCum <- df_mx[, -1] %>% 
        apply(1, my_diff) %>%
        t() %>%
        as.data.frame() %>% 
        gather("month", "qty") %>%
        select(qty)

# unpivot table
df_mx_unpivot <- gather(df_mx, key = "month", value = "cumQty", -region)
# convert month to date type
df_mx_unpivot$month <- as.Date(paste0("1.", df_mx_unpivot$month), "%d.%B.%Y")

# combine the cum and noncum together
df_mx_final <- cbind(df_mx_unpivot, df_mx_nonCum)
# assgin zone to each region
df_mx_final <- right_join(df_region_zone, df_mx_final, by = c("region" = "region"))
# add model as the new column
df_mx_final$model <- "Model X"


###### Step 3 data consolidation ######
# drop the cumulative qty column, add quarter column
df_final <- df_m3_final %>%
        rbind(df_ms_final, df_mx_final) %>%
        select(-cumQty) %>%
        mutate(quarter = as.yearqtr(month, format="%Y-%m-%d"), 
               model = as.factor(model))
df_final$model <- factor(df_final$model, levels = c("Model S", "Model X", "Model 3"))
write.csv(df_final, "output.csv", row.names = FALSE)

###### Step 3 data visulization ######
# group into quartly data, add cumulative sum value
df_quarter <- df_final %>% 
        ddply(.(model, quarter), summarize, qty = sum(qty)) %>%
        ddply(.(model), transform, csum = cumsum(qty))
# define a displayed text
text <- as.character(df_quarter$quarter)
# non cumulative delivered numbers
g <- ggplot(df_quarter, aes(x = quarter, y = qty))
g + geom_bar(aes(fill = model), stat = "identity")
g + geom_line(aes(color = model))
# line chart
plot_ly(df_quarter, x = ~quarter, y = ~qty, color = ~model, type = "scatter", 
        mode = "lines+markers")
# bar chart
plot_ly(df_quarter, x = ~quarter, y = ~qty, text = text, color = ~model, type = "bar") %>%
        layout(title = "Tesla Delivered Cars",
               xaxis = list(title = "Quarter"),
               yaxis = list(title = "Quantity"))
# stacked bar chart
plot_ly(df_quarter, x = ~quarter, y = ~qty, color = ~model, text = text, type = "bar") %>%
        layout(title = "Tesla Delivered Cars",
               xaxis = list(title = "Quarter"),
               yaxis = list(title = "Quantity"),
               barmode = 'stack')

# cumulative delivered numbers
plot_ly(df_quarter, x = ~quarter, y = ~csum, color = ~model, type = "bar", 
        hoverinfo = "text", text = ~paste0(as.character(quarter), ": ", csum)) %>%
        layout(title = "Tesla Delivered Cars - Cumulative Quantity", 
               xaxis = list(title = "Quarter"),
               yaxis = list(title = "Quantity"),
               barmode = 'stack')

