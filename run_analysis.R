##      Getting and Cleaning Data Course Project
##      
##      This script does the following
##              1 - merges the training and the test sets to create one data set
##              2 - extracts only the measurements on the mean and standard 
##                  deviation for each measurement. Assumed MeanFreq is a mean 
##                  measurement
##              3 - Uses descriptive activity names to name the activities in 
##                  the data set
##              4 - Appropriately labels the data set with descriptive variable 
##                  names. This data set is called allData
##              5 - From the data set in step 4, creates a second, independent 
##                  tidy data set with the average of each variable for each 
##                  activity and each subject. This data set is called alltidyData
##
##      Here are the data for the project:
##
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
##      Set up working dir, libs and url to use
                setwd ("/Users/bclayton/Desktop/GCData Class")
                fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                library(downloader)
                library(plyr)
                library(dplyr)
                library(reshape2)
##      download and unzip files
                download(fileUrl, dest="dataset.zip", mode = "wb")
                unzip("dataset.zip", exdir = "./")
##      set wd to where files unzipped and set download data
                projectdir <- "UCI HAR Dataset"
                dateDownloaded <- date()
                dateDownloaded 
                print ("Files from UCI HAR Dataset downloaded on:")
                print (dateDownloaded)
##      read in test data and activity labels
                activity <- read.table("UCI HAR Dataset/activity_labels.txt", row.names = NULL)
                testData <- read.table("UCI HAR Dataset/test/X_test.txt")
                testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
                testActivity <- read.table("UCI HAR Dataset/test/y_test.txt")
                features <- read.table("UCI HAR Dataset/features.txt", row.names = NULL)
##      read in training data 
                trainData <- read.table("UCI HAR Dataset/train/X_train.txt")
                trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
                trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt")
##      Project req#1,2 - merge training and the test sets with only mean and std cols 
##      Need to: 
##      1 - index the files with IDs we can use for merging
##      2 - create index of cols that are only mean and std to extract only those col
##      3 - set readable and valid col names
##      4 - index test and training files after col names assiged
##      5 - merge subject and activities to both test and training files
##      6 - combines test and training files using rbind  
##      Step 1 - add index ID's to activity, subject files. 
                newtestActivity <- mutate(testActivity, ID = seq_along(V1)) 
                newtestSubject <- mutate(testSubject, ID = seq_along(V1))
                newtrainActivity <- mutate(trainActivity, ID = seq_along(V1)) 
                newtrainSubject <- mutate(trainSubject, ID = seq_along(V1))
##      Step 2 - create index of cols for mean, std and use to select right columns
                meanStdColumns <- grep("mean|std", features$V2, value = FALSE)
                newtestData <- select(testData, meanStdColumns)
                newtrainData <- select(trainData, meanStdColumns)
##      Create vector to assign the columns names using grep with value true
                meanStdColumnsNames <- grep("mean|std", features$V2, value = TRUE)
##      Step 3 - set colnames that are readable and valid
##              Test Data
                colnames(newtestActivity) <- c("Activity", "ID")
                colnames(newtestSubject) <- c("Subject", "ID")
                colnames(newtestData) <- meanStdColumnsNames
                valid_column_names <- make.names(names=names(newtestData), unique=TRUE, allow_ = TRUE)
                names(newtestData) <-valid_column_names
##              Training data
                colnames(newtrainActivity) <- c("Activity", "ID")
                colnames(newtrainSubject) <- c("Subject", "ID")
                colnames(newtrainData) <-  meanStdColumnsNames
                valid_column_names <- make.names(names=names(newtrainData), unique=TRUE, allow_ = TRUE)
                names(newtrainData) <-valid_column_names
##      Step 4 - create indexes for test and training data files to allow merge later            
                newtestData <- mutate(newtestData, ID = seq_along(tBodyAcc.mean...X))
                newtrainData <- mutate(newtrainData, ID = seq_along(tBodyAcc.mean...X))
##      Step 5 - merge activity, subject to the train and test data files
                mergetestkey <- merge(newtestActivity, newtestSubject, by = "ID" )
                mergetestData <- merge(mergetestkey, newtestData, by = "ID")
                mergetrainkey <- merge(newtrainActivity, newtrainSubject, by = "ID" )
                mergetrainData <- merge(mergetrainkey, newtrainData, by = "ID")
##      Step 6 - combine training and test datasets with rbind
                allData <- rbind(mergetestData, mergetrainData)
##      Project req#3 - use the activity label to replace the code with label 
##      for each row       
##                
                allData$Activity <- as.character(allData$Activity)
                allData$Activity[allData$Activity == "1"] <- "WALKING"
                allData$Activity[allData$Activity == "2"] <- "WALKING_UPSTAIRS"
                allData$Activity[allData$Activity == "3"] <- "WALKING_DOWNSTAIRS"
                allData$Activity[allData$Activity == "4"] <- "SITTING"
                allData$Activity[allData$Activity == "5"] <- "STANDING"
                allData$Activity[allData$Activity == "6"] <- "LAYING"
                
##      Project req#4 - Appropriately label data set with descriptive variable
##      names.  Use the t and f in colnames to denote time and freq.  
##      Remove extra '.' and addinfo to indicate the mean is for the axis (XYZ) 
##      Use care with 'mean' as it is easy to change col names incorrectly
##      Used MeanFreq to distiguish this from mean. I used a good deal of 
##      formatting for the col names as I would like to split them into 
##      different variable, but not for this assignement as we were told not
##      to do this for the project
                
                names(allData) <- gsub("tBody", "Time.Body.", names(allData) ); 
                names(allData) <- gsub("tGravity", "Time.Gravity.", names(allData) ); 
                names(allData) <- gsub("fBody", "Freq.Body.", names(allData) ); 
                names(allData) <- gsub("fGravity", "Freq.Gravity.", names(allData) ); 
                names(allData) <- gsub(".meanFreq..", ".MeanFreq", names(allData) ); 
                names(allData) <- gsub(".mean...X", ".mean.X", names(allData) );
                names(allData) <- gsub(".mean...Y", ".mean.Y", names(allData) ); 
                names(allData) <- gsub(".mean...Z", ".mean.Z", names(allData) ); 
                names(allData) <- gsub(".std...", ".std.", names(allData) ); 
                names(allData) <- gsub("Mag.std..", "Mag.std", names(allData) ); 
                names(allData) <- gsub("Mag.mean..", "Mag.mean", names(allData) ); 
                names(allData) <- gsub("AccJerk", "Acc.Jerk", names(allData) ); 
                names(allData) <- gsub("GyroJerk", "Gyro.Jerk", names(allData) ); 
                names(allData) <- gsub("AccMag", "Acc.Mag", names(allData) ); 
                names(allData) <- gsub("GyroMag", "Gyro.Mag", names(allData) ); 
##              Project Req#5 From allData ceates a second, independent 
##              tidy data set with the average of each variable for each 
##              of the 6 activities and each subject. The data set has many issues
##              with variables in the columns names such as the domain of the signal
##              and the source, but I did not fix this as was told not to for the 
##              project.  Instead, I took the whole column name and made this a variable 
##              and the value of this variable was used to create the mean value across
##              a subject/activity.
##              First melt the data set to get the column names to be a variable col
##              and the value of each varialbe to be another column. 
##              Next, use ddply to create the mean for each variable for a subject/activity pair
  
                
                allDataMelt <- melt(allData, id=c("ID","Subject", "Activity"), 
                                    measure.vars=grep("mean|std",colnames(allData)))
                tidyallData <- ddply(allDataMelt, .(Subject, Activity,variable), summarize, meanValue = mean(value))
                
                write.table(tidyallData, file = "tidyallData.txt", row.names = FALSE)
                 
                head(tidyallData, n=10 )        