#Codebook.md describes run_analysis.R and its in- and output.

INPUT: Human Activity Recognition Using Smartphones Data Set (UCIHAR)
Original Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

OUTPUT: a dataframe named 'tidyData' with dimensions 180 observations of 68 variables.

In run_analysis.R, code line no. 1's 'yourDirectory' variable must be changed to your directory containing the original data, downloaded and unzipped. library(plyr) must be loaded for use of the 'ddply()' function.

From input to output, the following instructions describe how the data is cleaned:
You should create one R script called run_analysis.R that does the following. 
##1. Merges the training and the test sets to create one data set.

First, the data is read into 'data.frame'-class objects. This is the '_test.txt' and '_train.txt' data, and the 'features.txt' and 'activity_labels.txt' data.

'subject_merge', 'X_merge', and 'Y_merge' (NOTE: the uppercase Y) are created by 'row binding' the respective '_test' and '_train' data.
The column (variable) names are introduced into 'X_merge' by copying them from 'features.txt'. The column names of 'Y_merge' and 'subject_merge' are manually labeled.

Next 'Y_merge' and 'subject_merge' are appended to 'X_merge' by column binding them to the left of the other 'X_merge' data.

Finally the original data is cleared from the memory using the rm() function.
	
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 

'bigData' is created using regular expressions which grab columns from 'X_merge' with "means()" or "std" in them, and append the first two 'ID' columns to the left of that data. This creates a data.frame of 10299 observations of 68 variables.
	
##3. Uses descriptive activity names to name the activities in the data set

Activity id numbers in 'bigData' are replaced by activity names in the 'activity_labels' data.frame using a for loop and the with() function.
	
##4. Appropriately labels the data set with descriptive variable names. 

A series of substitutions are made, one example being 'replace "mean()" by " Mean Value "', in a character vector.
This vector is then copied to the column names of 'bigData'.
	
##5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

using ddply(), we split the dataframe by subject and activity, take the mean of all observations, per column (using 'numcolwise(mean)' as a parameter), and recombine the results into a 'tidyData' dataframe.
	
The result is a 'tidyData' dataframe of 180 observations of 68 variables, each observation a row of 68 variable means of an activity a specific subject is doing.