# Source of data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# This R script does the following:

## Part 1. Merges the training and the test sets to create one data set.

c1 <- read.table("train/X_train.txt")
c2 <- read.table("test/X_test.txt")
names(c1)
names(c2)
length(names(c1))==length(names(c2)) # It is true.
X <- rbind(c1, c2)

c3 <- read.table("train/subject_train.txt")
c4 <- read.table("test/subject_test.txt")
length(names(c3))==length(names(c4))
S <- rbind(c3, c4)

c5 <- read.table("train/y_train.txt")
c6 <- read.table("test/y_test.txt")
Y <- rbind(c5, c6)

merged <- cbind(S, Y, X)
write.table(merged, "merged_tidy_data.txt")

## Part 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
features <- features[, 2]
#length(features)
featuresIndex <- grep("-mean\\(\\)|-std\\(\\)", features)
#length(featuresIndex)
X <- X[, featuresIndex]
names(X) <- features[featuresIndex]
names(X) <- gsub("\\(|\\)", "", names(X))

extracted <- cbind(S, Y, X)
write.table(extracted, "extracted_data.txt")


## Part 3. Uses descriptive activity names to name the activities in ##
##         the data set               
## Part 4. Appropriately labels the data set with descriptive activity names.

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", as.character(activities[, 2]))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
names(S) <- "subject"
cleaned <- cbind(S, Y, X)
write.table(cleaned, "cleaned_data.txt")

## Part 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

Subjects = unique(S)[,1]
activities = activities[, 2]
LSub = length(Subjects)
LAct = length(activities)
m = LSub * LAct
n = dim(cleaned)[2]
Average = cleaned[1:m, ]

row = 1
for (i in 1:LSub) {
  for (j in 1:LAct) {
    Average[row, 1] = Subjects[i]
    Average[row, 2] = activities[j]
    tmp <- cleaned[cleaned$subject==i & cleaned$activity==activities[j], ]
    Average[row, 3:n] <- colMeans(tmp[, 3:n])
    row = row + 1
  }
}
write.table(Average, "2nd_data_set.txt")
