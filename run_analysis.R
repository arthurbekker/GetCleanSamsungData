# get library(s) needed
library(dplyr)
library(plyr)

# ------------ step 1 - Merges training and test sets
# get zip file and extract it
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/SamsungActivityData.zip") #,method="curl")
unzip("./data/SamsungActivityData.zip", overwrite = TRUE, exdir = "./data")

# get files
x_test <- read.table("./data/UCI HAR Dataset/test/x_test.txt", header=FALSE)
sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)
# merge test data columns into a single table
test <- cbind(x_test, sub_test, y_test)

x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt", header=FALSE)
sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)

# merge train data columns into a single table
train <- cbind(x_train, sub_train, y_train)

# Merge datasets together
all <- rbind(test, train)

# --------------PROVIDE COLUMN NAMES - Multi-step process
# get column names for x_ files from features.txt
features <- read.table("./data/UCI HAR Dataset/features.txt", header=FALSE)
# create an additional names for subject and activity
sub_actv <- matrix(c(1000, 1001, "SubjectID", "ActivityID"),ncol=2)
# merge 2 together for a full list of col names
var_names <- rbind(features, sub_actv)
# provide column names
names(all) <- var_names$V2

#------------- step 2 - extracts only measuments that are mean or std
# remove column names that are duplicated
all <- all[, !duplicated(names(all))]

# extract variables/columns that contain mean or stg only
all_tidy <- select(all, contains("mean()"), contains("std()"), contains("Subject"), contains("Activity"))

#-------------- step 3 - Activity Labels
activity_lbls <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header=FALSE)
names(activity_lbls)<-c('ActivityID','Activity')
all_tidy <- merge(all_tidy, activity_lbls)


#------------- step 4 - Descriptive Variable Names
names(all_tidy) <- gsub("^t", "Time", names(all_tidy))
names(all_tidy) <- gsub("Acc", "Acceleration", names(all_tidy))
names(all_tidy) <- gsub("Gyro", "Gyroscope", names(all_tidy))
names(all_tidy) <- gsub("Mag", "Magnitude", names(all_tidy))
names(all_tidy) <- gsub("mean\\(\\)", "Mean", names(all_tidy))
names(all_tidy) <- gsub("std\\(\\)", "StandardDeviation", names(all_tidy))
names(all_tidy) <- gsub("^f", "Frequency", names(all_tidy))

#----------- step 5 - creates an independent tidy data set with average of each variable for each activity and subject
tidy_summary <- aggregate(. ~SubjectID + Activity, all_tidy, mean)

#----------- write it out
write.table(tidy_summary, file="./data/tidy_data_summary.txt", row.names=FALSE)
