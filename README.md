# Case_Studies_2024

## Project Description
Case Studies repository for analyzing open source fMRI data.

## Dataset 
For this project, we utilized the Amsterdam Open MRI Collection (AOMIC). Specifically, we focused on fMRI data associated with the gender Stroop task, which is a component of the PIOP1 dataset. For more information on the dataset, visit [AOMIC: the Amsterdam Open MRI Collection](https://nilab-uva.github.io/AOMIC.github.io/).

Link to the dataset: https://openneuro.org/datasets/ds002785/versions/2.0.0

For our analysis, we used preprocessed BOLD files from the PIOP1 dataset. These files have been processed using the fMRIPrep pipeline, which includes several preprocessing steps to prepare the data for analysis. The preprocessing steps typically include motion correction, spatial normalization to a standard brain template (MNI152NLin2009cAsym), and other adjustments to improve data quality and compatibility for further analysis.

## AWSCLI Installation and File Download 
Detailed instructions for downloading the data using AWS CLI are provided:
1. Open Windows PowerShell or Command Prompt.
2. Install AWS CLI using pip: `pip install awscli`
3. You can verify the installation `aws --version`
4. Download the required files from the Amsterdam Open MRI Collection:
     1. `aws s3 sync --no-sign-request s3://openneuro.org/ds002785 /fmridata --exclude "*" --include "derivatives/fmriprep/sub-*/func/*_task-gstroop*space-MNI*desc-preproc_bold.nii.gz"`
     2. `aws s3 sync --no-sign-request s3://openneuro.org/ds002785 /fmridata --exclude "*" --include "sub-*/func/*_task-gstroop_acq-seq_events.tsv"
`
## Python Standard Libraries
To run this project, you will need to install the following dependencies:
- os
- glob

## Python External Libraries
- numpy: `pip install numpy`
- pandas: `pip install pandas`
- nibabel: `pip install nibabel`
- matplotlib: `pip install matplotlib`
- nltools: `pip install nltools` (https://github.com/ljchang/nltools)
- nilearn: `pip install nilearn` (https://github.com/nilearn/nilearn)

