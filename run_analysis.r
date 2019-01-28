
install.packages('dplyr')
install.packages('tidyr')
install.packages('stringr')
install.packages('tidyverse')

library('stringr')
library('tidyverse')

library('dplyr')
library('tidyr')

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','./dataset.zip')

unzip('./dataset.zip')

x_test <- read.table('./UCI HAR Dataset/test/X_test.txt', header = FALSE)

y_test <- read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE)

subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE)

x_train <- read.table('./UCI HAR Dataset/train/X_train.txt', header = FALSE)

y_train <- read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE)

subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE)

x_full <- rbind(x_test, x_train)
y_full <- rbind(y_test, y_train)
subject_full <- rbind(subject_test, subject_train)

colnames(y_full) <- 'activityID'
colnames(subject_full) <- 'subjectID'

act_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)

colnames(act_labels) <- c('activityID', 'activity')

features_file <- read.table('./UCI HAR Dataset/features.txt', header = FALSE) 

feature_names <- features_file[,2]

colnames(x_full) <- feature_names

xySubject <- cbind(subject_full, y_full, x_full)

xySubject

mean_or_std <- str_subset(feature_names,'mean\\(\\)|std\\(\\)')

only_meanstd_df <- subset(xySubject, select=c('activityID','subjectID',mean_or_std))

only_meanstd_df

sap <- sapply(only_meanstd_df, as.numeric)

colnames(sap)<- make.names(colnames(sap))

labels_meanstd_df <- merge(sap, act_labels, by.x = 'activityID', by.y = 'activityID')

labels_meanstd_df <- labels_meanstd_df %>% select(subjectID, activityID, activity, everything())

labels_meanstd_df

part_4 <- labels_meanstd_df %>% setNames(gsub('^t','time',names(.))) %>% setNames(gsub('^f','frequency',names(.))) %>% setNames(gsub('Acc','Acceleration',names(.))) %>% setNames(gsub('Mag','Magnitude',names(.))) %>% setNames(gsub('std','standardDeviation',names(.)))

part_4

s <- group_by(part_4, subjectID, activityID, activity)

averages <- summarize_all(s,mean)

write.table(averages, file = './tidy_dataset_part5.csv', row.names = FALSE, sep = ',')
