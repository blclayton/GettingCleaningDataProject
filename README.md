 

##Coursera Getting and Cleaning Data Project
###author: bclayton
###date: August 23, 2015

This is an R Markdown document for the R script run_analysis.R used to produce 
the class project tidy file.  The main purpose of the script is to create a 
tidy dataset.  The script combines test and train data from a study with 30 subjects
performing one of six activities.  The study collected several measures over multiple 
points while the subjects were performing activities.  The tidy data set has
the average value of measures pertaining to mean or standard deviation
collected for a subject doing an activity

 

1. set the working environment and calls needed libraries
    + library(downloader)
    + library(plyr)
    + library(dplyr)
    + library(reshape2)

2. downloads from defined url and unzips files: 
    + activity_labels.txt  - ID and labels of activities studied
    + test/X_test.txt  - study data collected from test subject
    + test/subject_test - test subjects identified by integer ID
    + test/y_test.txt - id code of activity which generated test data
    + features.txt - name of data measures collected or derived from study
    + train/X_train.txt - study data collected from train subject
    + train/subject_train.txt - train subjects identified by integer ID
    + train/y_train.txt - id code of activity which generated train dataapples
    + set Download date

3. creates alldata from merging training and the test sets with 
 only mean and std cols
    +  index the subject, activity, data files with IDs we can use for merging them together with the study data.   
    + find the set of columns only pertaining to mean or standard deviation by grepping the featuers file and using the names to select the right columns from the study data files
    + set readable and valid column names for subject, activity and data files
    + merge activity, subject files to the train and test data files
    + combine training and test datasets with rbind
4. Used the activity label data to replace the activity code with label for each row in the data set  
5. Appropriately label the data set with descriptive variable names. 
    + Given the feature names had embedded "()" to make them readable R replaced with '.' characters. Extra '.' characters were removed.  See table with info embedded in feature names
        - Example of feature name after modified to be more readable: "Time.Body.Acc.mean.Y"
    + replaced 'T' with 'Time' and 'F' with 'Freq' 
    + the feature names had info embeded but we were not to split out this info for the project so to make reading more clear the embedded info was delineated with a '.' character. 
6. From the allData data set created a second, independent tidy data set with the average of each variable for each activity and each subject. This data set is called tidyallData.  R commands used are listed.
    + used melt to make the features one column with their values another column
    + used ddply and summarize to get the mean for each variable of a subject/activity

### R commands to melt dataframe to create column of variables and another of values                  
``` 
allDataMelt <- melt(allData, id=c("ID","Subject", "Activity"), measure.vars=grep("mean|std",colnames(allData)))
tidyallData <- ddply(allDataMelt, .(Subject, Activity,variable), summarize, meanValue = mean(value))
```

### Type of info embedded in the feature names that were delinieated with '.':  
                Type of info  | values
                ------------- | -------------
                Domain        | Time or Freq
                Type of acc   | Body or Gravity 
                Source        | Acc, Gyro, BodyAcc, Body Gyro
                Derived info  | Jerk, Mag, JerkMag
                Type of meas  | Mean, Std 
                Axis of meas  | X, Y, Z
            
