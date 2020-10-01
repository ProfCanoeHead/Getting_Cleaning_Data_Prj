This is the course project for the Getting and Cleaning Data Coursera course.

The included R script, run_analysis.R, conducts the following:

•	Download the dataset from web: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

•	Reads both the train and test from their respective directories. and merges them into datadf

•	Subsets the mean and std columns, Note: the subset of columns is only the aggregate means and std for each of the x, y, z measuremnts for Body Acceleration, Gravity Accelerometer Magnitude,Body Accelerometer Jerk Magnitude, Body Gyroscope Magnitude, Body Gyroscope Jerk Magnitude for both time and frequency mearsurments.

•	Generate 'Tidy Dataset' that consists of the average (mean) of each variable for each activity and each subject. The result is shown in the file tidy.txt.

Notes: The data dictionary is in the directory codebook. The codebook.html file was generated with the codebook package. There are some errors in the file regarding missing value analysis at the end (still learning the pacakage :))