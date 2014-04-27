
run_analysis.R in this repository is a data cleaning project based on the original data: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip . 

it does the following performance.

1. Merges the training and test sets to create one data set

------------------------------------------
c1 <- read.table("train/X_train.txt")
c2 <- read.table("test/X_test.txt")
X <- rbind(c1, c2)
------------------------------------------

Note that the sizes of c1, c2 are with the same colume. it results in a 10299 x 561 data frame by combining them.

In the same way , we can get two 10299 x 1 data frames named S and Y.( S is data frame for subject IDs and Y for activities)

-------------------------------------------
merged <- cbind(S, Y, X)
write.table(merged, "merged_tidy_data.txt")
-------------------------------------------

By merging the data frames, we get one data set that was wanted.


2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Reads file features.txt to features , and then focus on the measurements : features[, 2]

extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
features <- features[, 2]
length(features) # 561
featuresIndex <- grep("-mean\\(\\)|-std\\(\\)", features)
length(featuresIndex) #66

It turns out that 66 out of 561 attributes are measurements on the mean and standard deviation.

--------------------------------------------
X <- X[, featuresIndex]
names(X) <- features[featuresIndex]
names(X) <- gsub("\\(|\\)", "", names(X))

extracted <- cbind(S, Y, X)
write.table(extracted, "extracted_data.txt")
---------------------------------------------

Then extractes the data frame that was got in part 1 by the index of measurements on the mean and standard deviation,

obviously, the length of features equals the columes of merged data.

After extracting, we have a new data frame in the size of 10299 x 68.


3. Reads activity_labels.txt and applies descriptive activity names to name the activities in the data set:

4. Appropriately labels the data set with descriptive activity names.

----------------------------------------
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", as.character(activities[, 2]))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
names(S) <- "subject"
cleaned <- cbind(S, Y, X)
write.table(cleaned, "cleaned_data.txt")
-----------------------------------------


5. Finally, the script creates a 2nd, independent tidy data set with the average of each measurement for each activity
and each subject.

note that

LSub = length(Subjects)=30
LAct = length(activities)=6

The result is saved as 2nd_data_set.txt, a 180x68 data frame, (180 = 30 * 6)

