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

# read raw data
df_quarter <- read.csv("input_for_project.csv", stringsAsFactors = FALSE)
# change model to factor
df_quarter$model <- factor(df_quarter$model, levels = c("Model S", "Model X", "Model 3"))
# non cumulative delivered numbers
# stacked bar chart
plot_ly(df_quarter, x = ~quarter, y = ~qty, color = ~model, type = "bar") %>%
        layout(title = "Tesla Delivered Cars",
               xaxis = list(title = ""),
               yaxis = list(title = "Quantity"),
               margin = list(b = 120), xaxis = list(tickangle = 45))
# cumulative delivered numbers
plot_ly(df_quarter, x = ~quarter, y = ~csum, color = ~model, type = "bar", 
        hoverinfo = "text", text = ~paste0(as.character(quarter), ": ", csum)) %>%
        layout(title = "Tesla Delivered Cars - Cumulative Quantity", 
               xaxis = list(title = ""),
               yaxis = list(title = "Quantity"),
               barmode = 'stack')

