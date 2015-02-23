# Cleaning Data Project
Course Project for Coursera Data Science Track by John's Hopkins

This script pulls data from the Samsung Data set of activity tracking here 
  http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The file is downloaded and unzipped. The training, test (X, Y, subject) files are loaded into separate 
variables then merged together using ldply and bind_cols functions.

Column names are loaded from the features.txt file and set to the data.frame for more descriptive variable names.

Dplyr select function is used to select columns named with mean() and std(). 

The data is tidied by joining the labels for the different activityIDs with the merged data.  The activity factor
is more descriptive than the integer values of ActivityID.

Lastly the tidy data is grouped by subjectID and activityID then the mean and sd of every variable is output. 
This is a wide format where every observation of subject and activity has a row and every column is a different feature of this observation. 

