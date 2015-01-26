============================================================================================
= Getting and Cleaning Data, project CookBook.md
=
= Version 1.0 
============================================================================================

This project was to prepare tidy data that can be used for later analysis. The original data
set can be downloaded from 

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The tidy data we generated is named "analysis.txt", with the column labels listed in 'Labels'
section. The subject column (column 67) is the subject id (volunteers who did the testing and 
training), and the activity column (column 68) is the activity description. 

The rest of columns (from column 1 to column 66) are the average of mean() or std() values in 
the measurements. The rest of measurements are removed to form the base of this new tidy data.

Note, the angle() measurements are not included.

The values in data set are grouped for each activity and each subject, and are calculated
by taking the average of in the individual sub set. The sub set was derived using a factor
'bk_id' generated with encording formula '(subject * 100 + acti_id)' where the acti_id is the
activity id.

There are 68 columns (including the activity and subject columns) and 180 observations.
The X/Y/Z in the value labels indicated the measurement is from X, Y or Z dimension. The
'mean' and 'std' labels indicated this (average) values are coming from the origianl mean() 
or std() measurements. The Acc/Gyro names indicated whether the data comes from an accelerometer
or a gyroscope sensor on Samsung Galaxy S smartphones.

The unit for all body and Gravity measurements has unit in standard gravity units 'g'.
The angular velocity vectors have units in 'radians/second' but the angular data is not
included in this new data set since the std() values are missing, and whether the mean
values is derived from mean() function is not clear. Although it's easy to add the angular
data in this data set by using a select() function to select all value labels with either
a 'mean' or a 'std' string in it.

Note, features from the original data sets are normalized and bounded within [-1, 1].

=== Labels ===

 [1] "tBodyAcc-mean-X"           "tBodyAcc-mean-Y"           "tBodyAcc-mean-Z"          
 [4] "tBodyAcc-std-X"            "tBodyAcc-std-Y"            "tBodyAcc-std-Z"           
 [7] "tGravityAcc-mean-X"        "tGravityAcc-mean-Y"        "tGravityAcc-mean-Z"       
[10] "tGravityAcc-std-X"         "tGravityAcc-std-Y"         "tGravityAcc-std-Z"        
[13] "tBodyAccJerk-mean-X"       "tBodyAccJerk-mean-Y"       "tBodyAccJerk-mean-Z"      
[16] "tBodyAccJerk-std-X"        "tBodyAccJerk-std-Y"        "tBodyAccJerk-std-Z"       
[19] "tBodyGyro-mean-X"          "tBodyGyro-mean-Y"          "tBodyGyro-mean-Z"         
[22] "tBodyGyro-std-X"           "tBodyGyro-std-Y"           "tBodyGyro-std-Z"          
[25] "tBodyGyroJerk-mean-X"      "tBodyGyroJerk-mean-Y"      "tBodyGyroJerk-mean-Z"     
[28] "tBodyGyroJerk-std-X"       "tBodyGyroJerk-std-Y"       "tBodyGyroJerk-std-Z"      
[31] "tBodyAccMag-mean"          "tBodyAccMag-std"           "tGravityAccMag-mean"      
[34] "tGravityAccMag-std"        "tBodyAccJerkMag-mean"      "tBodyAccJerkMag-std"      
[37] "tBodyGyroMag-mean"         "tBodyGyroMag-std"          "tBodyGyroJerkMag-mean"    
[40] "tBodyGyroJerkMag-std"      "fBodyAcc-mean-X"           "fBodyAcc-mean-Y"          
[43] "fBodyAcc-mean-Z"           "fBodyAcc-std-X"            "fBodyAcc-std-Y"           
[46] "fBodyAcc-std-Z"            "fBodyAccJerk-mean-X"       "fBodyAccJerk-mean-Y"      
[49] "fBodyAccJerk-mean-Z"       "fBodyAccJerk-std-X"        "fBodyAccJerk-std-Y"       
[52] "fBodyAccJerk-std-Z"        "fBodyGyro-mean-X"          "fBodyGyro-mean-Y"         
[55] "fBodyGyro-mean-Z"          "fBodyGyro-std-X"           "fBodyGyro-std-Y"          
[58] "fBodyGyro-std-Z"           "fBodyAccMag-mean"          "fBodyAccMag-std"          
[61] "fBodyBodyAccJerkMag-mean"  "fBodyBodyAccJerkMag-std"   "fBodyBodyGyroMag-mean"    
[64] "fBodyBodyGyroMag-std"      "fBodyBodyGyroJerkMag-mean" "fBodyBodyGyroJerkMag-std" 
[67] "subject"                   "activity"

