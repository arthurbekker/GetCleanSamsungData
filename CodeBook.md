#Code Book for Extraction and Transformation of data gathered from Samsung Galaxy S users' activities.

The transformation does through 5 main steps.  Some of the steps have substeps to complete the task at hand.

Prior to doing any steps dplyr and plyr libraries are loaded to be used below.

##Step 1
* A zip file is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped.
* Each set, test and train, have 3 sets of data, contained in txt files that are space delimited, that need to be combined.  They are x_, representing the content of the metrics, subject_, contains the identifier of the individual, and activity, depicting what action was being done at the time of the metric.  Both test and train data have their own directories where the files exist, respectively. Test data is loaded into 3 data tables and then combined into a single data frame by combining them on column level (rbind).   The same steps are done for the train data.
* Both resulting data tables are put together, one on top of the other, to get the master set of data called "all".
* The next step involves placing meaningful column (variable) names extracted from the features.txt file.  As the columns now have subject and activity, those are added to the features that were extracted.  As there will be a need to join the type of activity, represented by an id, with the activity description, a meaningful name is given to the id, ActivityID.  The names are then bound to the variables.

##Step 2
In this step, only the means and standard deviations are extracted from all of the columns (variables) in the data table.
* There is an issue with the current table, it has duplicate columns.  To get tidy data, the columns need to be deduped.
* The data is extracted using the select method.  As there are multiple columns that have the word mean and std in them, paranthesis are placed after to ensure only the columns wanted are extracted.  Since subject and activity have been loaded into the data table already, those are included in the select.  All data is placed into "all_tidy" data table.

##Step 3
It is time to place activity descriptions into the data table.
* Activity descriptions are extracted from activity_labels.txt and placed into a data table.
* Meaningful names are provided to the columns, ActivityID and Activity.  Note that ActivityID from this data table is purposely named so that it can be easily merged with "all_tidy" data table.
* The 2 data tables are merged together.  As the only matching column (variable) name is ActivityID, there is no need to provide the "by" parameters to merge.

##Step 4
In this step meaningful names are provided for the columns (variables).
* Anything that begins with a "t", has the t changed to time.
* All "Acc" are changed to acceleration.
* All "Gyro" are changed to gyroscope.
* All "Mag" are changed to magnitude.
* All "mean()" are changed to mean.
* All "std()" are changed to standarddeviation.
* Anything beginning with "f", is changed to "frequency", same as t in the first transformation.
* Finally, make all column names (variables) lower case.

##Step 5
It is requested that the data be grouped by activity and subject, and mean provided.  This is done via dcast() method.

The data is then written out into a text file called tidy_data_summary.txt.