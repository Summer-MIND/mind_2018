
Data and analyses accompanying:

Janice Chen, Yuan Chang Leong, Christopher J Honey, Chung H Yong, Kenneth A Norman, Uri Hasson (2017). Shared memories reveal shared structure in neural activity across individuals. Nature Neuroscience. PMID: 27918531

This tutorial ("sherlock_nifti_kit_v1") is packaged separately from the data ("sherlock_nifti_data"). Unzip the sherlock_nifti_data archive and put the resulting folder in the top level of sherlock_nifti_kit.

Your directory structure should look like this when you begin:
sherlock_nifti_kit_v1/code
sherlock_nifti_kit_v1/sherlock_nifti_data
sherlock_nifti_kit_v1/standard

As you run the code, more directories will be created.
Start at the beginning of how_to_use_sherlock_nifti_kit.m to see basic pattern analysis.
Use of stimulus features is described in labels_example_sherlock_segments.m.


Description of the data:

Seventeen subjects watched the first 50 minutes of Episode 1 of BBC's Sherlock.

Movie Scan 1: 946 TRs (after 20 TRs [eyetracking calibration time and HRF] cropped from beginning)
Movie Scan 2: 1030 TRs (after 20 TRs [eyetracking calibration time and HRF] cropped from beginning)
Movie Scan 1 and Movie Scan 2 were cropped and concatenated to create the sherlock_movie_s#.nii files, 1976 TRs total length.

Recall Scan: variable number of TRs depending on the subject's behavior. Data in the files titled sherlock_recall_s#.nii.

The brain data (both movie and recall) have been shifted by 3 TRs (4.5 seconds) relative to the timestamps (Scene Segments and Labels) to account for hemodynamic lag. Eg, the timestamp for the beginning of Scene 2 is TR=27; this brain volume was originally collected at TR=30, but has now been shifted so that the (HRF delayed) brain response aligns with the timestamp. No further shifting should be necessary.

One subject (s5) is missing data from the end of movie scan 2 (the last 50 TRs) due to technical error: they watched that part of the movie, but the brain data were not collected. These missing data are indicated with constant values (TR end-51 repeated for TRs end-50:end).

Labels: The Scene Segments (in sherlock_allsubs_events.mat) and the 1000 segments were coded by different people, so the scene starts and ends can be 0-3 seconds off when comparing the two. Analyses in the paper were all performed using the Scene Segments, except for the encoding model which used the label information accompanying the 1000 segments.

There are slight differences between computed R-values for the paper and this public code (around 0.01), due to differences in the order of averaging steps and z-scoring (e.g., averaging across subjects at the TR-level before within-scene). I made these changes for the tutorial to make the code more efficient and readable.


