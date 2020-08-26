library(dplyr)

##setwd("workspace/datasciencecoursera/Getting and Cleaning Data Course Project)

#1. get dataset from web
if(!file.exists("./data")){
  dir.create("./data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destfile= "./data/Dataset.zip"
  download.file(url = fileUrl,destfile=destfile,method="curl")
  }

if(!file.exists("./data/UCI HAR Dataset")){
  unzip(zipfile="./data/Dataset.zip",exdir="./data")
  path_rf <- file.path("./data" , "UCI HAR Dataset")
}

features <- read.table("./data/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

## test
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "code")

#train
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Merge

## by row
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
##  by column
Merged_Data <- cbind(Subject, Y, X)

## extract feature cols & names named 'mean, std'
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

TidyData$code <- activities[TidyData$code, 2]
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## independent tidy data 
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

## str(FinalData)
write.table(FinalData, "tidy_dataset.txt", row.name=FALSE)