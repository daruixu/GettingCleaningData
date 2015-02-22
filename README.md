## GettingCleaningData
The depository contains the script run_analysis.R and a codebook
The script will perform the following task:

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.
 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####Explanations of how to accomplish the above tasks
1. read in the subject id using readLines since only one column in file
2. read in the observations 
3. read in the activity the subject performs
4. repeat for test case
5. Extracts only the measurements on the mean and standard deviation for each measurement.
6. find the features that have mean and std. in the name, using grep function, 79 extracted
7. subset only the observations using the logical expression 
8. read in the activity information
9. match the activity id with activity name. 
10. I used factor levels to do this. Use left-join function in plyr package accomplishes the same 
11. Be careful with other join/merge as unintentional reorder may occur

 
The combined train and test set has 10299 (7352+2947) rows and 81 columns
to get the analysis results in a tidy dataset, we have two choices:
either in a wide-form with 81 columns or in a narrow-form with only four columns.
The narrow form is eariser to read on laptop screen. Using the melt function in reshape package, 
a narrow dataset with with 813621 rows (10299*79) is created.
The average information is calculated using the summerize function in dplyr package and
we have a dataset with a 14220 (30*6*79) rows and 4 columns 

