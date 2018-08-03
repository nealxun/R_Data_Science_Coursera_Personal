# a list of most frequenty used R packages
# test environment
rm(list = ls())
wd <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

# update R
install.packages("installr")
library(installr)
updateR()
# check version
sessionInfo()
# check r version
R.Version()
# check specific package verison
packageVersion("shiny")

# package list
install.packages("plyr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("caret")
install.packages("AppliedPredictiveModeling")
install.packages("Hmisc")
install.packages("ElemStatLearn")
install.packages("gbm")
install.packages("forecast")
install.packages("elasticnet")
install.packages("lubridate")
install.packages("e1071")
install.packages("shiny")
install.packages("plotly")
install.packages("leaflet")
install.pakcages("reshape")
install.pakcages("swirl")
install.packages("stringr")
install.packages("profvis")
install.pakcages("tidyverse")
install.packages("taskscheduleR", repos = "http://www.datatailor.be/rcube", type = "source")

