# a list of most frequenty used R packages
# objective, to update R and reinstall all the pakcages

# house keeping procedure
rm(list = ls())
wd <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

# upgrade R
# installing/loading the package:
if(!require(installr)) { install.packages("installr"); require(installr)} #load / install+load installr
updateR(fast = FALSE, browse_news = TRUE, install_R = TRUE, copy_packages = TRUE,
        copy_Rprofile.site = TRUE, keep_old_packages = TRUE, update_packages = TRUE) # install, move, update.package, quit R.

# check version
sessionInfo()
# check r version
R.Version()
# check specific package verison
packageVersion("shiny")

## install packages
# reading data
install.packages("openxlsx")
# data manipulation
install.packages("plyr")
install.packages("tidyverse")
install.packages("reshape")
install.packages("modelr")
install.packages("stringi")
# interactive dashboard
install.packages("shiny")
install.packages("shinythemes")
# machine learning
install.packages("caret")
install.packages("AppliedPredictiveModeling")
install.packages("Hmisc")
install.packages("ElemStatLearn")
install.packages("gbm")
# time series forecasting
install.packages("lubridate")
install.packages("forecast")
install.packages("xts")
install.packages("TTR")
install.packages("fpp2")
install.packages("elasticnet")
install.packages("e1071")
# graphics
install.packages("plotly")
install.packages("leaflet")
install.packages("hexbin")
install.pakcages("swirl")
# system and code speed testing
install.packages("profvis")
# database related package
install.packages("RODBC")
install.packages("sqldf")
install.packages("RODBC")
install.packages("RMySQL")
# open data source
install.packages("nycflights13")
install.packages("gapminder")
install.packages("Lahman")
# other
install.packages("yaml")
