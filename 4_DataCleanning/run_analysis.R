# getting and cleaning data course project
# preparation
setwd("C:/Users/Nealxun/Desktop/DataScience_JHU/3GetingAndCleaningData/project")
rm(list = ls())
library(tidyr)
library(dplyr)
library(plyr)

## 1. merges the training and the test sets together
# load train and test datasets
# train data set
df_train_X <- read.table(file = "X_train.txt")
df_train_y <- read.table(file = "y_train.txt")
df_train_subject <- read.table("subject_train.txt")
df_train <- cbind(df_train_X, df_train_y, df_train_subject)
# responses
df_test_X <- read.table(file = "X_test.txt")
df_test_y <- read.table(file = "y_test.txt")
df_test_subject <- read.table("subject_test.txt")
df_test <- cbind(df_test_X, df_test_y, df_test_subject)
# merge train and test datasets
df_all <- rbind(df_train, df_test)
# load y lables
y_label <- read.table(file = "activity_labels.txt", 
                      col.names = c("id", "activity_label"))
# load variable names for X
variable_name <- read.table(file = "features.txt", 
                            col.names = c("id", "feature"))
ls_variable <- as.vector(variable_name$feature)

## 2. extracts only the measurements on the mean and standard deviation for 
# each measurement
# add column names for the combined dataset
colnames(df_all) <- c(ls_variable, "activity", "subject")
# identify the mean and std measurements
meanStd <- filter(variable_name, (grepl("mean()", feature)| grepl("std()", feature)) 
                  & !grepl("meanFreq()", feature))
meanStd_id <- as.vector(meanStd$id)
# subset only the mean and standard deviation measurements
df_sub <- df_all[, c(meanStd_id, 562, 563)]

## 3. use descriptive activity names
df_sub <- merge(df_sub, y_label, by.x = "activity", by.y = "id", all.x = TRUE)
# remove the activity id column
df_sub <- df_sub[, -1]

## 4. appropriately labels the data set with descriptive variable names
# see step 2

## 5. based on the dataset obtained above, create another one with the average
# of each variable for each activity and each subject
# # for each activity
# by_activity <- split(df_sub, df_sub$activity_label)
# measure_avg_activity <- sapply(by_activity, function(x) colMeans(x[, -c(67, 68)]))
# df_activity_avg <- as.data.frame(t(measure_avg_activity))
# # for each subject
# by_subject <- split(df_sub, df_sub$subject)
# measure_avg_subject <- sapply(by_subject, function(x) colMeans(x[, -c(67, 68)]))
# df_subject_avg <- as.data.frame(t(measure_avg_subject))
# # combine the above two together
# df_final <- rbind(df_activity_avg, df_subject_avg)
df_final <- ddply(df_sub, .(subject, activity_label), function(x) colMeans(x[, 1:66]))
# write the final dataset to a csv file
write.csv(df_final, file = "subjectActivityAvg.csv")
# write the final dataset to a txt file
write.table(df_final, file = "subjectActivityAvg.txt", row.names = FALSE)

