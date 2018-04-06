# optional quiz
# Is there an association between college major category and income?
rm(list = ls())
install.packages("devtools")
devtools::install_github("jhudsl/collegeIncome")
library(collegeIncome)
data(college)

devtools::install_github("jhudsl/matahari")
library(matahari)

# begin the documentation of the analysis
dance_start(value = FALSE, contents = FALSE)
library(plyr)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(broom)

# quick review of the data
head(college)
tail(college)
summary(college)
table(college$major_category)
# filter out interdisciplinary major
college <- college %>%
        filter(major_category != "Interdisciplinary")
table(college$major_category)
# how three different income measures vary across categories
par(mar = c(13,4.5,2,0.5))
boxplot(p25th ~ major_category, data = college, main = "25th percentile", 
        las = 2, cex.axis = 0.75) # las = 2 makes the x axis label printed vertically
boxplot(median ~ major_category, data = college, main = "50th percentile", 
        las = 2, cex.axis = 0.75)
boxplot(p75th ~ major_category, data = college, main = "75th percentile", 
        las = 2, cex.axis = 0.75)

# simple summary stats
df_summary <- ddply(college, .(major_category), summarize, 
                    median = mean(median), sample_size = mean(sample_size))
ggboxplot(college, "major_category", "median", color = "major_category", 
          add = "jitter", repel = TRUE) +
        theme(axis.text.x=element_text(angle=90, hjust=1))

# regression model initial
fit <- lm(median ~ factor(major_category), data = college)
summary(fit)

# regression model solution, take consideration of gender effect and skill effect
lmfit <- lm(median ~ major_category+perc_women+perc_college_jobs+perc_low_wage_jobs, 
            data = college)
summary(lmfit)

# residual analysis
resid <- residuals(lmfit)
fitted <- fitted.values(lmfit)
plot(density(resid), xlab = "Residuals", ylab = "Density", 
     main = "Residual distribution")
plot(fitted, resid, xlab = "Predicted values", ylab = "Residuals")
abline(h = 0, col = "red", lty = "dashed")
# neater display
tidy(lmfit)


# record the analysis
dance_save("college_major_analysis.rds")