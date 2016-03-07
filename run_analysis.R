# # 0_Load each file to R:

#'features.txt': List of all features.
features <- read.table("features.txt")
names(features) <- c("feature_id", "feature")

#'activity_labels.txt': Links the class labels with their activity name.
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("activity_id", "activity")

#'train/X_train.txt': Training set.
X_train <- read.table("train/X_train.txt")
#set names from features:
names(X_train) <- features$feature

#'train/y_train.txt': Training labels.
y_train <- read.table("train/y_train.txt")
#training label is activity_id from activity_labels.txt
names(y_train) <- c("activity_id")

#'test/X_test.txt': Test set.
X_test <- read.table("test/X_test.txt")
#set names from features:
names(X_test) <- features$feature

#'test/y_test.txt': Test labels.
y_test <- read.table("test/y_test.txt")
#training label is activity_id from activity_labels.txt
names(y_test) <- c("activity_id")


#'train/subject_train.txt' +
#'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

names(subject_train) <- c("subject_id")
names(subject_test) <- c("subject_id")

#'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
#load all inertial signals:
body_acc_x_train <- read.table("train/Inertial Signals/body_acc_x_train.txt")
body_acc_y_train <- read.table("train/Inertial Signals/body_acc_y_train.txt")
body_acc_z_train <- read.table("train/Inertial Signals/body_acc_z_train.txt")

body_gyro_x_train <- read.table("train/Inertial Signals/body_gyro_x_train.txt")
body_gyro_y_train <- read.table("train/Inertial Signals/body_gyro_y_train.txt")
body_gyro_z_train <- read.table("train/Inertial Signals/body_gyro_z_train.txt")

total_acc_x_train <- read.table("train/Inertial Signals/total_acc_x_train.txt")
total_acc_y_train <- read.table("train/Inertial Signals/total_acc_y_train.txt")
total_acc_z_train <- read.table("train/Inertial Signals/total_acc_z_train.txt")

body_acc_x_test <- read.table("test/Inertial Signals/body_acc_x_test.txt")
body_acc_y_test <- read.table("test/Inertial Signals/body_acc_y_test.txt")
body_acc_z_test <- read.table("test/Inertial Signals/body_acc_z_test.txt")

body_gyro_x_test <- read.table("test/Inertial Signals/body_gyro_x_test.txt")
body_gyro_y_test <- read.table("test/Inertial Signals/body_gyro_y_test.txt")
body_gyro_z_test <- read.table("test/Inertial Signals/body_gyro_z_test.txt")

total_acc_x_test <- read.table("test/Inertial Signals/total_acc_x_test.txt")
total_acc_y_test <- read.table("test/Inertial Signals/total_acc_y_test.txt")
total_acc_z_test <- read.table("test/Inertial Signals/total_acc_z_test.txt")


# # 1_Merge the training and the test sets to create one data set.

#Merge x and y with cbind
train <- cbind(X_train, y_train, subject_train)
test <- cbind(X_test, y_test, subject_test)

#Merge train and test with rbind
data <- rbind(train, test)


# # 2_Extracts only the measurements on the mean and standard deviation for each measurement.

# melt data to get the value for each
library(reshape2)
#add id before melting
data2 <- data
data2$id <- 1:10299

data2 <- melt(data2, id=c("id", "activity_id", "subject_id"))
table(data2$variable)

# extract mean() and std() (skip meanFreq())
data2 <- data2[grep("mean\\(|std\\(", data2$variable),]

# unmelt
data2 <- dcast(data2, id + subject_id + activity_id ~ variable)

# # 3_Uses descriptive activity names to name the activities in the data set
data3 <- merge(data2,activity_labels)
# reorder the data and remove activity_id
data3$activity_id <- NULL
data3 <- data3[with(data3, order(id)),]

# # 4_Appropriately labels the data set with descriptive variable names. 

# see step 0
data4 <- data3

# # 5_From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# use melt and unmelt to get the average like in step 2

data5 <- melt(data4, id=c("id", "activity", "subject_id"))

#remove id variable
data5$id <- NULL

# unmelt
data5 <- dcast(data5, subject_id + activity ~ variable, mean)


write.table(data5, "tidy_data.txt", row.name=FALSE)
