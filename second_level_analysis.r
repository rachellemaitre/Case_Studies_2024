# Load necessary library
library(dplyr)

#BEGIN PREPROCESSING
## Load amygdala activation values
# Initialize an empty data frame to store the results
regression_df <- data.frame(participant = character(), average_activation = numeric(), stringsAsFactors = FALSE)

#create a list containing all filenames in the directory to loop over
all_files <- dir("C:/Users/Asus/Desktop/fmri/contrasts/") #put own file path
print(all_files)

# Loop over each file
for (file in all_files) {
  # Read the data
  file_path <- file.path("C:/Users/Asus/Desktop/fmri/contrasts/", file) #put own path
  data <- read.csv(file_path)
  
  # Calculate the average of all cells
  avg_value <- mean(data$Contrast_Values)
  
  # Extract the participant number from the file name
  participant_number <- gsub(".*sub-(\\d+)_amygdala_contrast_values.csv", "\\1", basename(file))
  
  
  # Add the result to the results_df
  regression_df <- rbind(regression_df, data.frame(participant = participant_number, average_activation = avg_value, stringsAsFactors = FALSE))
}

# Print the results
print(regression_df)

## Read in RT file
RT_df <- read.csv("C:/Users/Asus/Desktop/fmri/rt_df.csv") #put own filename

## make a df containing gender
#read in the participant info
participant_info <- read.delim("C:/Users/Asus/Desktop/fmri/participants_info.tsv") #put own file name

#extract the gender information from all subjects contained in subs in a separate df

# Create an empty df to store gender information
gender_df <- data.frame()

#extract all unique subject Ids
subs <- unique(regression_df$participant)

# Loop over participant numbers
for (i in 1:length(subs)) {
  # Extract gender corresponding to each participant number
  gender <- participant_info$sex[which(participant_info$participant_id == paste0("sub-", subs[i]))]
  
  # Append gender to the df
  gender_df <- rbind(gender_df, data.frame(participant = subs[i], gender = gender, stringsAsFactors = FALSE))
}

# Print the gender df
print(gender_df)

##now all three of these df should be perfectly aligned by subjectnumber, so we can just append the columns

regression_df$RT <- RT_df$contrast
regression_df$gender <- gender_df$gender

# Replace "n/a" with NA in the entire dataframe so that R can recognize it and throw out those participants
regression_df[regression_df == "n/a"] <- NA
regression_df <- na.omit(regression_df)

##save this summarized df of all necessary data going into the regression
write.csv(regression_df, "C:/Users/Asus/Desktop/fmri/df_regression_lara.csv", row.names = TRUE) #put own directory and name
#when we saved all of them we can share them and can stick them all together for the final analysis

## Attach the three separate dfs to each other
# due to technical issues each group member took care of the first level analysis for a 
# part of the fMRI data, now we put them all together

full_df <- data.frame()

#create a list containing all filenames in the directory to loop over
separate_files <- dir("C:/Users/Asus/Desktop/fmri/summary_data/") #put own file path
print(separate_files)

# Loop over each file
for (file in separate_files) {
  # Read the data
  file_path <- file.path("C:/Users/Asus/Desktop/fmri/summary_data/", file) #put own path
  separate_data <- read.csv(file_path)
  
  # Add the result to one complete df
  full_df <- rbind(full_df, separate_data)
}

#save the full data frame
write.csv(full_df, "C:/Users/Asus/Desktop/fmri/full_data_case_studies.csv", row.names = TRUE) #put own directory and name

## Attach the three separate dfs to each other
# due to technical issues each group member took care of the first level analysis for a 
# part of the fMRI data, now we put them all together

all_rt_df <- data.frame()

#create a list containing all filenames in the directory to loop over
rt_files <- dir("C:/Users/Asus/Desktop/fmri/stroop_task/") #put own file path
print(rt_files)

# Loop over each file
for (rt_file in rt_files) {
  # Read the data
  rt_file_path <- file.path("C:/Users/Asus/Desktop/fmri/stroop_task/", rt_file) #put own path
  rt_data <- read.csv(rt_file_path)
  
  # Add the result to one complete df
  all_rt_df <- rbind(all_rt_df, rt_data)
}

print(length(all_rt_df))

# exclude data that does not match with the fmri data since some participants that did not indicate
# their gender and those were exclude
common_participants <- intersect(all_rt_df$subject, full_df$participant)

# Step 2: Filter each data frame to keep only common participants
all_rt_df_filtered <- all_rt_df[all_rt_df$subject %in% common_participants, ]

#save the full data frame
write.csv(all_rt_df_filtered, "C:/Users/Asus/Desktop/fmri/stroop_task/full_df_rt.csv", row.names = TRUE) #put own directory and name

#END PREPROCESSING

#BEGIN ANALYSES

##Actual analysis on the merged files from all group members

## T-test to test if there is a stroop effect in the RTs

#read in behavioral data
full_df_beh <- read.csv("C:/Users/Asus/Desktop/fmri/stroop_task/full_df_rt.csv")

print(t.test(full_df_beh$mean_incongruent, full_df_beh$mean_congruent, paired = TRUE))

## Regression model

#by default R uses dummy coding
#reference is M

#read in full data frame with the fmri data
full_df_fmri <- read.csv("C:/Users/Asus/Desktop/fmri/full_data_case_studies.csv")

second_level_model_interaction <- lm(average_activation ~ RT + gender + gender:RT, data = full_df_fmri)
summary(second_level_model_interaction)

