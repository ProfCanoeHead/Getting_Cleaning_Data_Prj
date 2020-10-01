#R libraries used
library(dplyr)
library(data.table)

#check if /data exists, if not create
if (!file.exists("./data")){
  dir.create("./data")
  }
#GETTING DATA
#download data from url, and save to temp.zip
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileDest <- "./data/temp.zip"
download.file(fileUrl,fileDest , method = "curl")

#unzip temp.zip to the /data directory
unzip(fileDest, exdir = "./Data")

#list of unzipped file directories using 2,3,5 indices for each of the components
#to build final data.table - datadf
dirList <- list.dirs("./Data", full.names = TRUE, recursive = TRUE)

#retrieve files in each directory to be used to construct datadf data.table
labelF_list <- list.files(dirList[2], pattern = "s.txt$", full.names = TRUE)
testF_list <- list.files(dirList[3], pattern = "_t[a-z]*.txt$", full.names = TRUE)
trainF_list <- list.files(dirList[5], pattern = "_t[a-z]*.txt$", full.names = TRUE)

#MERGING TEST and TRAIN DATA
#data.table to be used to create factor leveling in datadf
activityCol <- fread(labelF_list[1], header = FALSE,  col.names = c("ID", "Activity"))

#data.table to be used as the column names in test and train data data.tables
dataCol <- fread(labelF_list[2], header = FALSE, col.names = c("ID", "ColumnNames"))

#create data_traindf data.table. Created in one step instead of creating multiple tables
data_traindf <- cbind(fread(trainF_list[1], col.names = c('subject'), header = FALSE), 
                      fread(trainF_list[3], col.names = c("activity"), header = FALSE),
                      fread(trainF_list[2], col.names = unlist(dataCol[,2], use.names = FALSE), header = FALSE)
                      )

#create data_testdf data.table. Created in one step instead of creating multiple tables
data_testdf <- cbind(fread(testF_list[1], col.names = c('subject'), header = FALSE),
                      fread(testF_list[3], col.names = c("activity"), header = FALSE),
                     fread(testF_list[2], col.names = unlist(dataCol[,2], use.names = FALSE), header = FALSE)
                      )

#merge of test and train data to create datadf
datadf <- rbind(data_traindf, data_testdf)

#EXTRACTING MEAN and STD DATA
#keep measurement mean and std columns 
datadf <- datadf %>% select(subject, activity, (matches("mean\\(\\)$") | matches("std\\(\\)$")))

#CREATING DESCRIPTIVE VARIABLE NAMES and FACTORS FOR TIDY DATA SET
#replace activity column with the appropriate text values stored in activityCol data.table
datadf$activity <- activityCol[datadf$activity, 2]

#create factoring levels based on activity
datadf <- datadf[, activity:= as.factor(activity)]

#replace column names with meaningful text
names(datadf)<-gsub("^t", "time", names(datadf))
names(datadf)<-gsub("^f", "frequency", names(datadf))
names(datadf)<-gsub("Acc", "Accelerometer", names(datadf))
names(datadf)<-gsub("Gyro", "Gyroscope", names(datadf))
names(datadf)<-gsub("Mag", "Magnitude", names(datadf))
names(datadf)<-gsub("BodyBody", "Body", names(datadf))

#CREATING TIDY DATA SET
#aggregate data by activity and subject, calculating the mean for each activity/subject intersection
tidydata <- aggregate(. ~activity + subject, datadf, mean)
tidydata <- tidydata[order(tidydata$activity,tidydata$subject),]


write.table(tidydata, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)

