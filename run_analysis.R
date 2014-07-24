setwd(yourDirectory)

library(plyr) #I need this for the ddply function


#read in the various raw data files
  features <- read.table("features.txt", quote="\"")
  activity_labels <- read.table("activity_labels.txt", quote="\"")
#  activity_labels <- activity_labels[,2]

  subject_test <- read.table("test/subject_test.txt", quote="\"")
  X_test <- read.table("test/X_test.txt", quote="\"")
  Y_test <- read.table("test/y_test.txt", quote="\"")  
  
  subject_train <- read.table("train/subject_train.txt", quote="\"")
  X_train <- read.table("train/X_train.txt", quote="\"")
  Y_train <- read.table("train/y_train.txt", quote="\"")


#merge the data
  subject_merge <- rbind(subject_test,subject_train)
  X_merge <- rbind(X_test,X_train)
  Y_merge <- rbind(Y_test,Y_train)


#Appropriately labels the data set with descriptive variable names
  colnames(X_merge) <- features[,2]


#add the colnames of the subject and activity
  colnames(subject_merge) <- "Subject_ID"
  colnames(Y_merge) <- "Activity_ID"


#merging with subject and activity (y) data columns
  X_merge <- cbind(subject_merge,Y_merge,X_merge)


#clean the raw unmerged data out of the memory
  rm(subject_test)
  rm(X_test)
  rm(Y_test)
  
  rm(subject_train)
  rm(X_train)
  rm(Y_train)


#We don't include the meanFreq() data!
  bigData <-cbind(subject_merge,Y_merge,X_merge[,grepl("mean\\(\\)",names(X_merge))],X_merge[,grepl("std",names(X_merge))])


#fix up the Activity ID's. 
  for(i in 1:6){
    index <- which(bigData[,2]==i)
    bigData[index,2] <- as.character(activity_labels[i,2])
  }


#clean up the names of the columns (measured variables)
  n<- c(names(bigData))

  n<- gsub("mean\\(\\)", " Mean Value ", n)
  n<- gsub("std\\(\\)"," Standard deviation ",n)
  n<- gsub("meanFreq\\(\\)", " Mean Frequency ", n)
  n<- gsub("^t", "Time Signal of ", n)
  n<- gsub("^f", "Frequency Signal of ", n)
  n<- gsub("yAcc","y Accelerometer ",n)
  n<- gsub("-X","on X axis ",n)
  n<- gsub("-Y","on Y axis ",n)
  n<- gsub("-Z","on Z axis ",n)
  n<- gsub("Gyro"," Gyroscope ",n)
  n<- gsub(" *Mag"," Magnitude ",n)
  n<- gsub(" *- *"," - ",n)
  n<- gsub("_id", " ID",n)

  names(bigData) <- n



#get colmeans into tidyData: split the dataframe by subject and activity, 
#and take the means of the columns of each list item, then combine it back to a data frame.
tidyData <- ddply(bigData, .(Subject_ID,Activity_ID),numcolwise(mean))

#write the data away into a csv file

write.csv(tidyData,file="tidyData.txt")