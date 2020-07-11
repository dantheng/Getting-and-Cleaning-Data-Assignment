#Getting and Cleaning Data Assignment
    #Load necessary packages 
library(dplyr)
    #Download the Data
        # Checking if archieve already exists.
if (!file.exists("Coursera_DS3_Final.zip")){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, 
                  destfile = "/Users/danieltheng/Documents/Daniel Theng/R-Coursera/Getting and Cleaning Data/Coursera_DS3_Final.zip", 
                  method="curl")
}  
        #Unzip the zipped folder 
if (!file.exists("UCI HAR Dataset")) { 
    unzip("/Users/danieltheng/Documents/Daniel Theng/R-Coursera/Getting and Cleaning Data/Coursera_DS3_Final.zip") 
}
        #Reading Dataframes 
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

        #Merging the Data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(X, Y, subject)

        #Selecting mean measurements and their st.devs
View(merged_data)
tidy_data <- merged_data %>% select(subject, code, contains("mean"), contains("std"))

        #Make the activity names more descriptive
View(tidy_data)
colnames(tidy_data)
tidy_data$code <- activities[tidy_data$code, 2]
        #Making the Variables names more descriptive
names(tidy_data)[2] <- "activity"
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("-mean", "Mean", names(tidy_data))
names(tidy_data) <- gsub("-std", "STD", names(tidy_data))
names(tidy_data) <- gsub("-freq", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))
        #Making the final tidy dataset 
Final_Dataset <- tidy_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Final_Dataset, file = "Final_Dataset.txt", row.names = FALSE)
