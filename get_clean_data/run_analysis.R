
library(dplyr)
library(rmarkdown)
#
# Step 1: Get the dataset

if (!file.exists('smartphonedata')){
        dir.create('smartphonedata')
} else {
        # Download the zipped file

        temp_file <- tempfile()
        
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,temp_file)
        
        unzip(zipfile =  temp_file, exdir = './smartphonedata')
        rm(temp_file)
        
}

#check for directories and files
list.dirs("./smartphonedata")
list.files("./smartphonedata")


# Step 2: Merge the training and the test sets to create one data set.
features <- read.table("./smartphonedata/UCI HAR Dataset/features.txt", sep = "", col.names = c("col", "function_type"))
activity_labels <- read.table("./smartphonedata/UCI HAR Dataset/activity_labels.txt", sep = "", col.names = c("Activity_Code", "Description"))

##2.1 train files
X_train <- read.table("./smartphonedata/UCI HAR Dataset/train/X_train.txt", sep = "", col.names = features$function_type)
y_train <- read.table("./smartphonedata/UCI HAR Dataset/train/y_train.txt", sep = "", col.names = "Activity")
subject_train <- read.table("./smartphonedata/UCI HAR Dataset/train/subject_train.txt", sep = "", col.names = "SubjectID")

##2.2 test files
X_test <- read.table("./smartphonedata/UCI HAR Dataset/test/X_test.txt", sep = "", col.names = features$function_type)
y_test <- read.table("./smartphonedata/UCI HAR Dataset/test/y_test.txt", sep = "", col.names = "Activity")
subject_test <- read.table("./smartphonedata/UCI HAR Dataset/test/subject_test.txt", sep = "", col.names = "SubjectID")

##2.3 merge the data according to train and test respectively using rbind()

X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

##2.4 merge all the data subject data, y_data, by X_data using cbind() 
all_data <- cbind(subject_data, y_data, X_data)

# Step 3: Extract only the measurements on the mean and standard deviation for each measurement.
## using the select() and contains() function

clean_data <- all_data %>%
        select(SubjectID, Activity, contains("mean"), contains("std"))

# Step 4: Use descriptive activity names to name the activities in the data set
## using data in the activities_labels to replace codes in activity column 

clean_data$Activity <- activity_labels[clean_data$Activity, 2]


# Step 5: Appropriately label the data set with descriptive variable names
## using the gsub()

names(clean_data) <- gsub("Acc", "Accelerometer", names(clean_data))
names(clean_data) <- gsub("Gyro", "Gyroscope", names(clean_data))
names(clean_data) <- gsub("BodyBody", "Body", names(clean_data))
names(clean_data) <- gsub("Mag", "Magnitude", names(clean_data))
names(clean_data) <- gsub("^t", "Time", names(clean_data))
names(clean_data) <- gsub("^f", "Frequency", names(clean_data))
names(clean_data) <- gsub("tBody", "TimeBody", names(clean_data))
names(clean_data) <- gsub("-mean()", "Mean", names(clean_data), ignore.case = TRUE)
names(clean_data) <- gsub("-std()", "STD", names(clean_data), ignore.case = TRUE)
names(clean_data) <- gsub("-freq()", "Frequency", names(clean_data), ignore.case = TRUE)
names(clean_data) <- gsub("angle", "Angle", names(clean_data))
names(clean_data) <- gsub("gravity", "Gravity", names(clean_data))

# Step 6: From the data set in step 5, create a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data <- clean_data %>%
        group_by(SubjectID, Activity) %>%
        summarise_all(mean)
write.table(final_data, file = "final_data.txt", row.names = FALSE)

View(final_data)


