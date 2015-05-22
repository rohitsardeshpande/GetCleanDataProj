---
title: "CodeBook"
author: "Rohit Sardeshpande"
date: "Wednesday, May 13, 2015"
output:
  html_document:
    theme: cosmo
---

# Coursera - Getting and Cleaning Data
## Getting and Cleaning Data Course Project

### Data

Some experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Of the various files inluded in the zip archive, below files will be used for this project. Their names and brief descriptions are listed below.

* X_test and X_train - These contain the observations recorded by the smartphone. The 'test' file contains the observations for 9 individuals, the 'train' file contains observations for the rest.
* y-test and y_train - These contain activity ids corressponding to the observatins in X_test and X_train files.
* subject_test and subject_train - These contain subject ids corressponding to the observatins in X_test and X_train files.
* activity_labels - This conatins the activity ids and their narratives.
* features - This conatins the features for which observations have been recorded in X_test and X_train files. There are 561 features recorded and each is listed in the same order as the observations in X_test and X_train files.
* features_info - This gives some background inforamtion on the features themsleves. Though not used directly in the R script, reading this provides information, based on which  the R script has been developed.

The README file alkso gives some information above this dataset.

### Variables

* activityLabels - A vector holding names of the activities, hard-coded into the script
* fTestObv, fTrainObv - Data frames created by reading content from X_test and X_train files, respectively. Holds observations from the experiment.
* fTestAct, fTrainAct - Data frames created by reading content from y_test and y_train. Hold activity ids corressponding to the observatins in fTestObv, fTrainObv.
* fTestSubj, fTrainSubj - Data frames created by reading content from subject_test and subject_train. Hold subject ids corressponding to the observatins in fTestObv, fTrainObv.
* fTestAll - A data frame created by combining data in fTestSubj, fTestAct and fTestObv. This gives observations per activity per subject in one data frame.
* fTrainAll - A data frame created by combining data in fTrainSubj, fTrainAct and fTrainObv. This gives observations per activity per subject in one data frame.
* fFeatures - A data frame created by reading contents of the featues file. Holds features for which observations have been recorded in fTestObv, fTrainObv.
* i, j - Index vectors, which represent positions in fFeatures, for mean and standard deviation features only
* obvNames - A vector, having column names for the subjects, activities and the observations recorded for mean and standard deviation.
* k - An index vector having positions for subject and activity labels and mean and standard devation. This is just to make code easier to read when used later on :-)
* fSet - A data frame, created by combining fTestAll and fTrainAll.
* meanDF - A data frame, containging the arithmetic mean of the mean and standard devation observations held in fSet, per acitiy and per subject.

### Transformations

The steps to be followed to achieve objectives of this project are as below.

1. Download the .zip file from below link and unzip to the R working directory
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Use the read_table {reader} function to read data from *X_test, X_train, y-test, y_train, subject_test, subject_train* into local variables (as specified under the 'Variables section'). The read_table function works best for the file structure (delimited by space file structure) seen here.
3. Use cbind {base} to combine the subject ids (*fTestSubj*), activity ids (*fTestAct*) and corressponding observations (*fTestObv*) of the 'test' set into *fTestAll*. Do the same for the 'train' set and combine into *fTrainAll*.
4. Use fread {data.table} to read the features file into *fFeatures*
5. Use the grep {base} to extarct postions of mean and standard deviation features from *fFeatures*, into *i, j* respectively.
6. Combine the literals 'Subject' and 'Activity' with the content of *fFeatures* at positions *i, j*, into the vector *obvNames*. This now holds the column names for the data in *fTestAll* and *fTrainAll*
7. Combine 1, 2, *i*, *j* into a vector *k*. This is being done mainly for readability.
8. USe rbind {base} to combine all rows and those columns represented by *k*, to create *fSet*. *fSet* now has 68 observations against the subject and the activity.
9. Use colnames {base} to rename the column names of *fSet* to the content of *obvNames*. This renames the Subject, Activity descriptively and renames 68 mean and standard deviation observations to their corressponding feature names.
10. Use aggregate {stats} to compute the arithmetic mean of the various observations based on pairs of subject and activity. Store it in *meanDF*.
11. use the sub {base} function to replace the activity ids by their descriptive names.
12. The aggregate function automatically adds group ids to the result data frame. Subset *meanDF* to keep all other columns, except the groups added.
13. Write out the clean and tidy text file using write.table {utils} from *meanDF*.