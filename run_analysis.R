#run_analysis.R
#Getting and Cleaning Data Course Project

library(dplyr)

# Step 1: Merge the training and the test sets to create one dataset.

# Load the data from the UCI HAR Dataset
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Merging the training and test sets 
x.set <- rbind(x_test, x_train)
y.set <- rbind(y_test, y_train)
subjects.set <- rbind(subject_test, subject_train)

# Setting column names
data_labels <- features$V2
colnames(x.set) <- data_labels
names(subjects.set) <- "subjectID"
names(y.set) <- "activity"

# combine files into one dataset
combined <- cbind(subjects.set,y.set,x.set)


#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
# determine which columns contain "mean" or "std"
mean_and_std_features <- grep("mean\\(\\)|std\\(\\)", names(combined)) 

# Adding subjectID and activity columns
mean_and_std_features <- append(1:2, mean_and_std_features)

# remove unnecessary columns
combined <- combined[, mean_and_std_features]


# Step3: Uses descriptive activity names to name the activities in the data set
# convert the activity column from integer to factor
for (i in 1:6) {
  combined$activity[y.set$activity == i] <- as.character(activity_labels[i,2])  
}


# Step4: Appropriately labels the data set with descriptive variable names.
names(combined)<-gsub("Acc", "Accelerometer", names(combined))
names(combined)<-gsub("Gyro", "Gyroscope", names(combined))
names(combined)<-gsub("BodyBody", "Body", names(combined))
names(combined)<-gsub("Mag", "Magnitude", names(combined))
names(combined)<-gsub("^t", "Time", names(combined))
names(combined)<-gsub("^f", "Frequency", names(combined))
names(combined)<-gsub("tBody", "TimeBody", names(combined))


# Step5: Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
tidy <- aggregate(. ~ subjectID+activity, data=testCombined, FUN=mean)

# Export the dataset as a txt file
write.table(tidy, "tidy.txt", sep="\t", row.names=FALSE)
