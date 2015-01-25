# run_analysis.R
#
# Getting and Cleaning Data project, Jan 2015
#
# 1, Merges the training and the test sets to create one data set.
# 2, Extracts only the measurements on the mean and standard deviation for each 
#    measurement. 
# 3, Uses descriptive activity names to name the activities in the data set
# 4, Appropriately labels the data set with descriptive variable names. 
# 5, From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#

## required libraries
library(plyr)
library(dplyr)

## Data directory
dir.name = "./UCI_HAR_Dataset"
output.dir.name  = "./data"
output.file.name = "analysis.txt"

## data file names
file_train_data <- paste(dir.name, "/train/X_train.txt", sep="")
file_train_acti <- paste(dir.name, "/train/y_train.txt", sep="")
file_train_subj <- paste(dir.name, "/train/subject_train.txt", sep="")
file_test_data  <- paste(dir.name, "/test/X_test.txt", sep="")
file_test_acti  <- paste(dir.name, "/test/y_test.txt", sep="")
file_test_subj  <- paste(dir.name, "/test/subject_test.txt", sep="")

## feature names
file_features <- paste(dir.name, "/features.txt", sep="")

## reads train data [7352x561]
df_train_acti <- read.table(file_train_acti, col.names=c("Activity"))
df_train_subj <- read.table(file_train_subj, col.names=c("Subject"))
df_train_data <- read.table(file_train_data)

## reads test data [2947x561]
df_test_acti <- read.table(file_test_acti, col.names=c("Activity"))
df_test_subj <- read.table(file_test_subj, col.names=c("Subject"))
df_test_data <- read.table(file_test_data)

## reads feature names
features <- read.table(file_features)

## function to collect feature ids (associated with mean() and std() variables) and
## descriptive names from feature list
get_mean_std_id_names <- function(features) {
    ids = NULL
    names = NULL
    fun = ""
    feature_ids = as.vector(features$V1)
    feature_names = as.vector(features$V2)
    for (i in 1:nrow(features)) {
        #print(feature_names[i])
        tokens = unlist(strsplit(feature_names[i], "-"))
        len = length(tokens)
        if (len != 3 && len != 2) {
            next 
        }
        if (tokens[2] == "mean()") {
            fun = "mean"
        } else if (tokens[2] == "std()") {
            fun = "std"
        } else {
            next
        }
        ids = c(ids, feature_ids[i])
        name = ifelse(len == 3, paste(c(tokens[1], fun, tokens[3]), sep="", collapse="-"),
                      paste(c(tokens[1], fun), sep="", collapse="-"))
        names = c(names, name)
    }
    data.frame(ids = ids, names = names)
}

# 48x2 data frame, column.names = (ids, names)
mean_std_id_names = get_mean_std_id_names(features)

# Get subset, df_test_data.sub [2947x66] and df_train_data.sub [7352x66]
df_test_data.sub  = select(df_test_data,  mean_std_id_names$ids)
df_train_data.sub = select(df_train_data, mean_std_id_names$ids)

# Name the labels with descriptive variable names
mean_std_names = as.vector(mean_std_id_names$names)
colnames(df_test_data.sub) = mean_std_names
colnames(df_train_data.sub) = mean_std_names

# Append activity column as acti_id (67th column) 
df_test_data.sub$acti_id = unlist(df_test_acti)
df_train_data.sub$acti_id = unlist(df_train_acti)


# Function to name the activity columns with descriptive activity names
activity_name <- function(id) {
    if (id == 1) {
        "WALKING"
    } else if (id == 2) {
        "WALKING_UPSTAIRS"
    } else if (id == 3) {
        "WALKING_DOWNSTAIRS"
    } else if (id == 4) {
        "SITTING"
    } else if (id == 5) {
        "STANDING"
    } else if (id == 6) {
        "LAYING"
    } else {
        NA
    }
}

## Append activity column (68th columns)
df_test_data.sub$activity = sapply(df_test_data.sub$acti_id, activity_name)
df_train_data.sub$activity = sapply(df_train_data.sub$acti_id, activity_name)

## Append subject column (69th columns)
df_test_data.sub$subject  = unlist(df_test_subj)
df_train_data.sub$subject = unlist(df_train_subj)

## Merge test and train together vertically using rbind(), and re-arrange the order
## according to subject
df_all = rbind(df_train_data.sub, df_test_data.sub)
df_all = arrange(df_all, subject)

## Create a new tidy data set with the average of each variable for each activity
## and each subject by melting followed by dcast
df_all$bk_id = factor(df_all$subject * 100 + df_all$acti_id)
df_all.melt  = melt(df_all, id=c("bk_id"), measure = mean_std_names)
df_all.avg   = dcast(df_all.melt, bk_id ~ variable, 
                     function(x) { mean(ave(x)) })

## append group and id to df_all.avg by decoding bk_id tag
df_all.avg$subject  = sapply(as.numeric(as.vector(df_all.avg$bk_id)), 
                             function(x) { floor(x/100)})
df_all.avg$activity = sapply(as.numeric(as.vector(df_all.avg$bk_id)), 
                             function(x) { x - (floor(x/100) * 100)})
df_all.avg$activity = sapply(df_all.avg$activity, activity_name)

## remove bk_id column and get the new independent tidy data for submission
df_all.avg = select(df_all.avg, -bk_id)
 
## Verify the result
# class(df_all.avg)
# dim(df_all.avg)
# names(df_all.avg)
# unique(df_all.avg$activity)
# unique(df_all.avg$subject)
# head(df_all.avg, 3)
# tail(df_all.avg, 3)
# str(df_all.avg)

## write out final data set to data directory in txt format
if (! file.exists(output.dir.name)) { dir.create(output.dir.name) }
file.name = paste(c(output.dir.name, output.file.name), sep="", collapse="/")
write.table(df_all.avg, file.name, row.name=FALSE)

## end of script
