#load the libraries needed
#dplyr contains the summarize function
#reshape2 has the melt function to make the data in the narrow form
library(dplyr)
library(reshape2)

#read in the labels for activity and feature
activity_info<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("id", "name"), colClasses="character")
feature_info<-read.table("UCI HAR Dataset/features.txt", colClasses="character")$V2
#find the indices for features with mean and std only.
#note that this regex will pick up the mean_frequency column also
#total of 79 features selected. Otherwise, use mean() in the regex
wanted<-grep( "mean|std", feature_info)

subject_train<-readLines("UCI HAR Dataset/train/subject_train.txt")
activity_train<-readLines("UCI HAR Dataset/train/y_train.txt")
#match the activity id with activity name 
#use left-join function in plyr package accomplishes the same 
#be careful with other join/merge as unintentional reorder may occur
activity_train<-as.factor(activity_train)
levels(activity_train)<-activity_info$name
#read in the observations of train set
obs_train<-read.table("UCI HAR Dataset/train/X_train.txt")
#column combine only the desired features and observations
train<-cbind(subject_train, activity_train, obs_train[,wanted])
names(train)<-c("subject_id", "activity", feature_info[wanted])

#create the test dataset using the same algorithm as the train
subject_test<-readLines("UCI HAR Dataset/test/subject_test.txt")
activity_test<-readLines("UCI HAR Dataset/test/y_test.txt")
activity_test<-as.factor(activity_test)
levels(activity_test)<-activity_info$name
obs_test<-read.table("UCI HAR Dataset/test/X_test.txt")
test<-cbind(subject_test, activity_test, obs_test[,wanted])
names(test)<-c("subject_id", "activity", feature_info[wanted])

#the combined train and test set
#the resulting data frame has 10299 (7352+2947) rows and 81 columns
combined_df<-rbind(train,test)
#to get the analysis results in a tidy dataset, we have two choices:
#either in a wide-form with 81 columns or in a narrow-form with only
#four columns.
#the following command produces the wide form, straight-forward
#but the narrow form is eariser to read on laptop screen 
#results<-combined_df %>% group_by(subject_id, activity) %>% summarise_each(funs(mean))
#to produce the narrow form, reshape first
#this proudces a df with 813621 rows (10299*79)
melted <- melt(combined_df, id.vars = c("subject_id", "activity"), variable.name = "feature")
#this produces the mean of each feature for each subject and activity
#in totall 14220 (30*6*79) rows and 4 columns 
result<-summarise(group_by(melted, subject_id, activity, feature), mean(value))
result<-format(result, digits=2, scientific=F, justify='right')
write.table(result, "analysis_result.txt", quote=F, row.name=FALSE)
