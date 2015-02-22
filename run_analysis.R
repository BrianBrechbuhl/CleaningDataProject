library(dplyr)
library(plyr)

#Load Data
##You should create one R script called run_analysis.R that does the following. 
##	1.	Merges the training and the test sets to create one data set.
##	2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
##	3.	Uses descriptive activity names to name the activities in the data set
##	4.	Appropriately labels the data set with descriptive variable names. 
##	5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each
## activity and each subject. 
#0 Loading Zip Data
url <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
temp <- tempfile()
download.file(url, temp)
unzip(temp, exdir = getwd())

#1. Merge training and test sets
test_X <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
train_X <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X.list <- list(test_X, train_X)
y.list <- list(test_y, train_y)
subject.list <- list(subject_test, subject_train)

X <- ldply(X.list, rbind)
y <- ldply(y.list, rbind)
subject <- ldply(subject.list, rbind)

col.names <- read.table("UCI HAR Dataset/features.txt")
colnames(X) <- make.names(col.names[,2], unique=TRUE)

colnames(subject) <- c("subjectID")
colnames(y) <- c("activityID")
data <- bind_cols(X, subject)
data <- bind_cols(data, y)

#2. Extracts only the measurements on the mean and std_dev for each measurement
#set column names of data set
data.mean.std <- select(data,subjectID, activityID, matches(".mean"), matches(".std"))

#	3.	Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("activityID", "activity")

#Join on ActivityID
data.mean.std <- inner_join(data.mean.std, activity_labels)


#4.	Appropriately labels the data set with descriptive variable names. 
## This was done above when reading in the features.txt file and applying to the column names
## Also done by labeling Activity, ActivityID, and SubjectID

#5.  From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

#remove activityID, this was replaced by the more descriptive Activity column
tidy <- select(data.mean.std, -(activityID))

#Group by SubjectID then Activity and summarise each column with mean and sd
tidy_result  <- tidy %>%
	group_by(subjectID, activity) %>%
	summarise_each(funs(mean,sd))

write.table(tidy_result, "tidy_wide_activity_data.tsv", sep = "\t")

