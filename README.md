# GettingAndCleaningData

============================================================================================
= Getting and Cleaning Data, project README.md
=
= Version 1.0 
============================================================================================

This project was to prepare tidy data that can be used for later analysis. The original data
set can be downloaded from 

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

After the data is expanded, you need to modify the the dir.name parameter in run_analysis.R 
to point to the data directory.

Source the run_analysis.R script and a new tidy data set willl be written to "analysis.txt"
under directory "data" in the working dir. You can modify the variable "output.dir.name" and
"output.file.name" to point to a different output directory and file name.

=== how this sript works ===

1, Reads in the data sets from test and train data files, and stores in df_train_* and
   df_test_* data frame where the '*' can be 'data' (for measurements), 'subj' for subject
   or 'acti' for activity.

2, Reads in feature list for 'id' to 'descriptive name' mapping. A function
   get_mean_std_id_names() is used to collect mean and std measurements if and only if a 
   'mean()' or 'std()' token appears in their labels. The round brackets '()' in the original 
   label name is removed.

3, Subsetting the test and train data sets according to the ids collected from step 2. And
   labels the new data sets with descriptive variable names collected from step 2.

4, A function activity_name() is used to translate activity id (1 to 6) to descriptive names
   defined in activity_labels.txt. (this portion can be automated by reading and processing
   the activity_labels.txt file) The activity names (labels) are applied to test and train
   data sets.
 
5, Append the subject to both data sets as a new column, then merge both data sets vertically
   into a new data set 'df_all'. Re-arrange the order according to subject column.

6, From here, we can derive the new tidy data set by first creating a usique factor with
   encoding of subject and activity id. A simple formula '(subject * 100 + acti_id)' is used
   to generate the encoding keys 'bk_id'.

7, Melt the data set 'df_all' according to 'bk_id', and set the measurement.var to all measurement
   variables so we can calculate the average of each variable for each activity and each subject
   and store the new result to df_all.avg, which is the new tidy data.

8, Decode the activity id and subject from 'bk_id', and translate the activity id to descriptive
   activity names. Remove the 'bk_id' column using select() function and examine the result.

9, Write the new tidy data to file in text format, with the row names removed.
