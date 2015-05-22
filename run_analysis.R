library(readr)
library(plyr)
library(data.table)
library(stats)
library(utils)

## R script to clean data for the Getting and Cleaning Data Course Project

## Define a string vector to hold activity names
activityLabels <- c("Walking", "Walking Upstairs",
                      "Walking Downstairs", "Sitting",
                      "Standing", "Laying")

## Read files downloaded and unzipped into the R working directory
fTestObv <- read_table("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
fTestAct <- read_table("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
fTestSubj <- read_table("UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)

fTrainObv <- read_table("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
fTrainAct <- read_table("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
fTrainSubj <- read_table("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)

## Combine subjects, actvities and observations for the test and train sets
fTestAll <- cbind(fTestSubj, fTestAct, fTestObv)
fTrainAll <- cbind(fTrainSubj, fTrainAct, fTrainObv)

## Read the features file and record the positions fo mean and standard
## deviation functions
fFeatures <- fread("UCI HAR Dataset/features.txt")
i <- grep("-mean()", fFeatures$V2, fixed = TRUE)
j <- grep("-std()", fFeatures$V2)

## Create a vector to store column names
obvNames <- c("Subject", "Activity", fFeatures$V2[c(i, j)])

## Create a single data frmae with data for both test and train sets
k <- c(1, 2, i, j)
fSet <- rbind(fTestAll[, k], fTrainAll[, k])

## Rename column names
colnames(fSet) <- obvNames

## Calculate arithmetic means for the observations in fSet,
## per subject and per activity
meanDF <- aggregate(x = fSet, by = list(fSet$Subject, fSet$Activity),
                     FUN = "mean")

## Replace activity ids with activity names to improve readability
for(l in 1:6) {
  meanDF$Activity <- sub(l, activityLabels[l], meanDF$Activity, fixed = TRUE)
}

## Aggregate function automatically adds group ids. G?et rid of them.
meanDF <- meanDF[, 3:70]

## Write out the clean file
write.csv(meanDF, file = "meanDF.csv", row.names = FALSE)