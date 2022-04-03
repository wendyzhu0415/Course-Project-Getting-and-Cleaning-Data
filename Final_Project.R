library(dplyr)
filename <- "Final.zip"
if (!file.exists(filename)){
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl, filename, method="curl")
}
if (!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
Tidy_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
Tidy_Data$code <- activities[Tidy_Data$code, 2]
names(Tidy_Data)[2] = "activity"
Final_Data <- Tidy_Data %>% group_by(subject, activities) %>% summarise_all(funs(mean))
variable.names(Tidy_Data)
write.table(Final_Data, "Final_Data.txt", row.name=FALSE)