
% Tutorial for running ROI-level pattern similarity analyses on the Sherlock movie & recall data
% j chen 08/14/17
%
% This tutorial includes fmri data files from Chen et al. (2017) Nature Neuroscience 

% All Nifti files must be unzipped
% You will need to change the paths below to match your machine
% It may be helpful to run this section before running each of the sections below

clear

if ispc,
    basepath = ['Z:\janice\code\sherlock_nifti_kit_v2'];
elseif isunix,
    if ismac
%         basepath = ['/Users/jchen230/Dropbox/Matlab/sherlock_nifti_kit_v2_withdata'];
        basepath = ['/Users/kanile/Dropbox/Matlab/sherlock_nifti_kit_v2_withdata'];
    else
        basepath = ['/mnt/cd/hasson/janice/sherlock_nifti_kit_v2'];
    end
end
addpath(fullfile(basepath,'code'));
addpath(fullfile(basepath,'code','NIFTI_tools'));
cd(basepath)

%% unpacking: the first time you run this cell, 
% the subjects' nifti files will all begin in a folder in the top directory, basepath/sherlock_nifti_data.
% the niftipath variable should contain the full address to this directory:
%    niftipath = fullfile(basepath,'sherlock_nifti_data');
% after running the "ROI timecourses" cell below (which will take a while), 
% .mat file versions of the data will be saved in subjects/<subjectID>/<condname>.
% subsequently, set the niftipath variable to 'none':
%    niftipath = 'none';
% and you can remove the sherlock_nifti_data folder if you want to (it is large).

% niftipath = fullfile(basepath,'sherlock_nifti_data');

%% Calculate ROI Timecourses
% load nifti data, save it as .mat, calculate ROI Timecourses
% input: 4d functional nifti files for s1, s2, s3, s4
% output: a summary file roi_condname_roicorr.mat that contains ISC info for the ROI
% if you want to change the subject names, edit sherlock_get_subj_info.m 

niftipath = fullfile(basepath,'none'); % set the niftipath variable to 'none' if unpacking is complete

% you can add ROIs here. ROI files are in basepath/standard
x = 0;
% x=x+1; rois{x} = 'pmc_nn.nii'; % Posterior Medial Cortex, region used in Chen et al. (2017) Nature Neuroscience
x=x+1; rois{x} = 'aud_early.nii'; % Early Auditory Cortex, roughly defined from auditory ISC in Pieman [see Simony et al. (2016) Nature Communications]
% x=x+1; rois{x} = 'a1_rev.nii'; % Early Auditory Cortex, defined from ISC in the Reverse condition in Pieman [Lerner et al. (2011) J Neurosci]
% x=x+1; rois{x} = 'bilateral_hipp.nii'; % Hippocampus, anatomically defined from Harvard-Oxford atlas
% x=x+1; rois{x} = 'ddmn_mpfc.nii'; % Medial Prefrontal Cortex, from resting-state connectivity atlas (Shirer et al. 2012 Cerebral Cortex)
% x=x+1; rois{x} = 'early_visual.nii'; % Early visual cortex, roughly defined from movie data (Chen et al. 2015 Cerebral Cortex)
% x=x+1; rois{x} = 'post_parahipp.nii'; % Posterior Parahippocampal Cortex, anatomically defined from Harvard-Oxford atlas

conds_to_run = {'sherlock_movie','sherlock_recall'}; 
% ^ you can also extract roi data for just one condition, eg conds_to_run = {'sherlock_movie'}

tic
% these lines need to be run just once for each new ROI
sherlock_roi(basepath,rois,'savedata',conds_to_run,niftipath); % loads whole brain data and saves .mat data file for this ROI for all subjects
sherlock_roi(basepath,rois,'loaddata',conds_to_run,niftipath); % loads .mat data files for this ROI for all subjects; save summary file in intersubj/roicorr
fprintf('Finished.\n'); toc

%% Plot ROI timecourses for the movie data

% choose an ROI
roiname = 'aud_early';
% roiname = 'pmc_nn';

% plot timecourses for all subjects, as well as the mean
condname = 'sherlock_movie';
names = sherlock_get_subj_info('names',condname);
roistr = strrep(roiname,'_','-');
rcolors = get_colorlist; rcolors = repmat(rcolors,10,1);
roicorrpath = fullfile(basepath,'intersubj','roicorr'); 
roicorr_file = [roiname '_sherlock_movie_roicorr.mat'];
r = load(fullfile(roicorrpath,roicorr_file));
figure(9090); clf; set(gcf,'Color',[1 1 1]); 
for n = 1:length(r.roicorr), plot(r.roitc(:,n),'Color',rcolors{n},'LineWidth',1); hold on; end
plot(zscore(r.meantc),'k','LineWidth',2);
set(gca,'FontSize',16); grid on; xlabel('TR'); ylabel('Z')
title(['Indiv subject timecourses for ' roistr]);
legend([names 'mean']);

% plot lagged corrs for every subject for this ROI (each subject vs avg others)
% a sharp peak at center-x-axis for each subj indicates good temporal alignment
roicorr_file = [roiname '_sherlock_movie_roicorr.mat'];
r = load(fullfile(roicorrpath,roicorr_file));
for n = 1:length(r.roicorr), r.otherstc(:,n) = nanmean(r.roitc(:,setdiff([1:size(r.roitc,2)],n)),2); end
figure(9091); clf; set(gcf,'Color',[1 1 1]); w = 50;
for n = 1:length(r.roicorr)
    i1 = n*w-w; i2 = n*w+w;
    lagcc1 = lagcorr(r.roitc(:,n),r.otherstc(:,n),[-1*w:w]);
    plot([i1:i2],lagcc1,'Color',rcolors{n},'LineWidth',2); hold on
    m1 = plot(n*w,lagcc1(w+1),'ok','LineWidth',2);
end
set(gca,'FontSize',16,'XTick',[w:w:w*n],'XTickLabel',[1:n]); grid on
xlim([0 n*w+w]); xlabel('Subject #'); ylabel('Lagged Correlation');
title(['ISC: Each Subj x Mean-of-Others ' roistr]);
yr = ylim(gca); yd = (yr(2)-yr(1))/10;
plot([0 w],[-1*yd -1*yd],'k-','LineWidth',4); text(1,-2*yd,[num2str(w) ' TRs']);

%% Plot timepoint-by-timepoint cross-subject pattern correlation matrices for movie-movie

% choose an ROI
% roiname = 'aud_early';
roiname = 'pmc_nn';

condname = 'sherlock_movie';
names = sherlock_get_subj_info('names','sherlock_movie');
[mcorrmat mdiag allsubs_corrmat allsubs_mdiag] = sherlock_nifti_patternsim(basepath,names,roiname,condname,0);

figure(497); clf; set(gcf,'Color',[1 1 1]); % set(gcf,'Position',[827 565 560 420]);
imagesc(mcorrmat,[-0.3 0.3]); colorbar; colormap hot
xlabel('Time (TR)'); ylabel('Time (TR)');
title('TR-level cross-subject pattern correlation for Movie-vs-Movie (1-vs-avg-others)');

%% Plot recall behavior (for one subject at a time)

% choose a subject
subjnum = 13;
sherlock_plot_recall_behav(basepath,subjnum)
colormap hot

%% Calculate scene averages: a voxel pattern for each scene
% for movie-movie, movie-recall, and recall-recall

% choose an ROI
% roiname = 'aud_early';
roiname = 'pmc_nn';

% this file contains movie and recall scene timestamps for each subject
load(fullfile(basepath,'subjects','sherlock_allsubs_events.mat'),'ev');
names = sherlock_get_subj_info('names','sherlock_movie');

condnames = {'sherlock_movie','sherlock_recall'};
[allsubs_50M_events,allsubs_50FR_events,allsubs_iM_events,allsubs_iFR_events] =...
    sherlock_load_avgscenes_50M_50R(basepath,roiname,names,ev,condnames);

nsubs = length(names);
nEvents = size(allsubs_50M_events,2);
% calculate scene-level pattern correlations for movie-movie, movie-recall, and recall-recall
for n = 1:nsubs
    % movie-recall within subject: multiply-recalled events are counted individually
    sdiag_movrec_withinsubj{n} = diag(corr(allsubs_iM_events{n},allsubs_iFR_events{n}));
    mdiag_movrec_withinsubj(n) = nanmean(sdiag_movrec_withinsubj{n});

    % movie-recall within subject: multiply-recalled events are averaged, allowing corrmat to be averaged
    movrec_withinsubj_corrmat(:,:,n) = corr(allsubs_50FR_events(:,:,n),(allsubs_50M_events(:,:,n)));
    
    % movie-movie between subjects:
    others = setdiff([1:nsubs],n);
    movmov_btwnsubj_corrmat(:,:,n) = corr(allsubs_50M_events(:,:,n),nanmean(allsubs_50M_events(:,:,others),3));
    sdiag_movmov_btwnsubj{n} = diag(corr(allsubs_50M_events(:,:,n),nanmean(allsubs_50M_events(:,:,others),3)));
    mdiag_movmov_btwnsubj(n) = nanmean(sdiag_movmov_btwnsubj{n});
    
    % recall-recall between subjects:
    others = setdiff([1:nsubs],n);
    recrec_btwnsubj_corrmat(:,:,n) = corr(allsubs_50FR_events(:,:,n),nanmean(allsubs_50FR_events(:,:,others),3));
    sdiag_recrec_btwnsubj{n} = diag(corr(allsubs_50FR_events(:,:,n),nanmean(allsubs_50FR_events(:,:,others),3)));
    mdiag_recrec_btwnsubj(n) = nanmean(sdiag_recrec_btwnsubj{n});
end

%% Plot cross-subject pattern similarity
% for movie-movie and recall-recall
% requires the above cell to be run first

roistr = strrep(roiname,'_','-');

% Plot correlation matrices
figure(495); clf; set(gcf,'Color',[1 1 1]); set(gcf,'Position',[533 205 293 780]);
colormap hot

subplot(3,1,1) % movie-recall within subject:
imagesc(nanmean(movrec_withinsubj_corrmat,3),[-0.5 0.5]); colorbar
title('Movie-Recall Within-Subject');

subplot(3,1,2) % movie-movie btwn subjects:
imagesc(nanmean(movmov_btwnsubj_corrmat,3),[-0.5 0.5]); colorbar
title('Movie-Movie Between-Subjects');

subplot(3,1,3) % recall-recall btwn subjects:
imagesc(nanmean(recrec_btwnsubj_corrmat,3),[-0.5 0.5]); colorbar
title('Recall-Recall Between-Subjects');

% Plot matrix diagonals (matching scenes) as barcharts
figure(496); clf; set(gcf,'Color',[1 1 1]); set(gcf,'Position',[51 205 479 780]);

subplot(3,1,1) % movie-recall within subject:
plot([0 18],[0 0],'k-','LineWidth',2); hold on
bar(mdiag_movrec_withinsubj); hold on
grid on
xlim([0 n+1]); ylim([-0.05 0.3]);
set(gca,'FontSize',16);
xlabel('Subject'); ylabel('R');
title(['Spatial Corr Within-Subject Movie vs Recall: ' roistr])

subplot(3,1,2) % movie-movie within subject:
plot([0 18],[0 0],'k-','LineWidth',2); hold on
bar(mdiag_movmov_btwnsubj); hold on
grid on
xlim([0 n+1]); ylim([-0.05 0.5]);
set(gca,'FontSize',16);
xlabel('Subject'); ylabel('R');
title(['Spatial Corr Btwn-Subjects Movie vs Movie: ' roistr])

subplot(3,1,3) % movie-movie within subject:
plot([0 18],[0 0],'k-','LineWidth',2); hold on
bar(mdiag_recrec_btwnsubj); hold on
grid on
xlim([0 n+1]); ylim([-0.05 0.3]);
set(gca,'FontSize',16);
xlabel('Subject'); ylabel('R');
title(['Spatial Corr Btwn-Subjects Recall vs Recall: ' roistr])

%% Read and plot movie feature labels
labels_example_sherlock_segments


%% Regress a timecourse onto 2d functional brain data, then
% put resulting brain map back into 3d nifti format for viewing

% for our seed timecourse, we'll use the mean hippocampus timecourse across subjects
hipp_summary_file = load(fullfile(basepath,'intersubj','roicorr','bilateral_hipp_sherlock_movie_roicorr.mat'));
hipptc = hipp_summary_file.meantc;

% load one subject's functional data
s1 = load(fullfile(basepath,'subjects','s1','sherlock_movie','sherlock_movie_s1.mat'));
% s1.data, the functional data, is a 271633x1976 matrix.
% s1.datasize shows the original 4 dimensions of these data: [61 73 61 1976], ie [x y z time]

% regress the seed timecourse onto the functional brain data
rmap = corr(s1.data',hipptc); % rmap is 271633x1

% reshape the map into the original 3 dimensions of the MNI brain
rmap_3d = reshape(rmap,s1.datasize(1:3)); % rmap_3d is 61x73x61

% load the MNI brain in order to steal the header information
mni_brain = load_nii(fullfile(basepath,'standard','MNI152_T1_3mm_brain.nii'));
output_nii = mni_brain;
output_nii.img = rmap_3d; % replace the .img field with your map
output_nii.hdr.dime.cal_min = 0.1; % these are settings that some viewers use for initial display range
output_nii.hdr.dime.cal_max = 0.4;

% save the nifti file: save_nii(output_nii,output_filename)
save_nii(output_nii,fullfile(basepath,'intersubj','corrmap','hipptc_regressed_on_s1_map.nii'));

% in a viewer (eg mricron) open 'MNI152_T1_3mm_brain.nii'
% add your newly created map as an overlay.









