
#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
#The submitted data set is tidy. 
#The Github repo contains the required scripts.
#GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and #summaries calculated, along with units, and any other relevant information.
#The README that explains the analysis files is clear and understandable.
#The work submitted for this project is my work.

#The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

##
# Step 0: Get the dataset

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
>list.dirs("./smartphonedata")
[1] "./smartphonedata"                                        "./smartphonedata/UCI HAR Dataset"                       
[3] "./smartphonedata/UCI HAR Dataset/test"                   "./smartphonedata/UCI HAR Dataset/test/Inertial Signals" 
[5] "./smartphonedata/UCI HAR Dataset/train"                  "./smartphonedata/UCI HAR Dataset/train/Inertial Signals"

>list.files("./smartphonedata")
[1] "UCI HAR Dataset"


# Step 2: Merge the training and the test sets to create one data set.
features <- read.table("./smartphonedata/UCI HAR Dataset/features.txt", sep = "", col.names = c("col", "function_type"))
#features is a 'data.frame':	561 obs. of  2 variables 

activity_labels <- read.table("./smartphonedata/UCI HAR Dataset/activity_labels.txt", sep = "", col.names = c("Activity_Code", "Description"))
#'activity_label is data.frame':	6 obs. of  2 variables

##1.1 train files
X_train <- read.table("./smartphonedata/UCI HAR Dataset/train/X_train.txt", sep = "", col.names = features$function_type)
#'data.frame':	7352 obs. of  561 variables'

y_train <- read.table("./smartphonedata/UCI HAR Dataset/train/y_train.txt", sep = "", col.names = "Activity")
#'data.frame':	7352 obs. of  1 variable

subject_train <- read.table("./smartphonedata/UCI HAR Dataset/train/subject_train.txt", sep = "", col.names = "SubjectID")
#'data.frame':	7352 obs. of  1 variable


##1.2 test files
X_test <- read.table("./smartphonedata/UCI HAR Dataset/test/X_test.txt", sep = "", col.names = features$function_type)
#'data.frame':	2947 obs. of  561 variables

y_test <- read.table("./smartphonedata/UCI HAR Dataset/test/y_test.txt", sep = "", col.names = "Activity")
>'data.frame':	2947 obs. of  1 variable'

subject_test <- read.table("./smartphonedata/UCI HAR Dataset/test/subject_test.txt", sep = "", col.names = "SubjectID")
#'data.frame':	2947 obs. of  1 variable


##1.3 merge the data according to train and test respectively using rbind()

X_data <- rbind(X_train, X_test)
#'data.frame':	10299 obs. of  561 variables

y_data <- rbind(y_train, y_test)
#'data.frame':	10299 obs. of  1 variable

subject_data <- rbind(subject_train, subject_test)
#'data.frame':	10299 obs. of  1 variable

##1.4 merge all the data subject data, y_data, by X_data using cbind() 
all_data <- cbind(subject_data, y_data, X_data)
#'data.frame':	10299 obs. of  563 variables

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
## using the select() and contains() function

clean_data <- all_data %>%
        select(SubjectID, Activity, contains("mean"), contains("std"))

# Step 3: Use descriptive activity names to name the activities in the data set
## using data in the activities_labels to replace codes in activity column 

clean_data$Activity <- activity_labels[clean_data$Activity, 2]


# Step 4: Appropriately label the data set with descriptive variable names
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

# Step 5: From the data set in step 5, create a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data <- clean_data %>%
        group_by(SubjectID, Activity) %>%
        summarise_all(mean)
write.table(final_data, file = "final_data.txt", row.names = FALSE)

View(final_data)
