
clear
basepath = '/Users/kanile/Dropbox/Matlab/sherlock_nifti_kit_v2';
% basepath = '/Users/jchen230/Dropbox/Matlab/sherlock_nifti_kit_v2';
cd(basepath);
addpath(basepath);
addpath(fullfile(basepath,'code'));

% Read in the Segments file
[num,txt,raw] = xlsread(fullfile(basepath,'subjects','Sherlock_Segments_1000_NN_2017.xlsx'));
% remove header row from txt to make indexing easier
header_row = txt(1,:); txt = txt(2:end,:); % now the row also corresponds to the segment number
SL_short_segments = [num(:,4) num(:,5)];
SL_short_segments(481:482,:) = []; % no fmri data for these last two segments of part 1

% SL_short_segments has 998 rows
% These are the TRs (brain volumes) corresponding to each segment of the movie
% as labeled in Sherlock_Segments_1000_NN_2017.xlsx
    
%% load one label timecourse and plot it

% labels: indoor, numpersons, music, speaking, writwords, valence, arousal, locations, 
%         Sherlock_onscreen, John_onscreen, Sherlock_speaking, John_speaking
% [content_var,label,scene_title] = get_predictors_1000segs(basepath,label,plotme)
[content_var,label,scene_title] = get_predictors_1000segs(basepath,'Sherlock_onscreen',1);


%% load multiple label timecourses and plot them

% load label timecourses
labelnames = {'speaking','numpersons','locations','arousal','valence','indoor',...
    'music','writwords','Sherlock_onscreen', 'John_onscreen'};
for i = 1:length(labelnames)
    [labeltc(:,i),label,scene_title] = get_predictors_1000segs(basepath,labelnames{i},0);
end
%%
% expand the 998 segments into TRs
% need the rep step because sometimes multiple segments belong to the same TR
% due to timestamping being done in seconds and then resampled to TRs
% in which case we'll average the segments values together
labeltc_TRs_rep = []; rowTR_rep = [];
for k = 1:size(labeltc,1)
    rowvals = labeltc(k,:);
    nTRs_this_seg = length([SL_short_segments(k,1):SL_short_segments(k,2)]);
    segblock = repmat(rowvals,nTRs_this_seg,1);
    rowTR_rep = [rowTR_rep; [SL_short_segments(k,1):SL_short_segments(k,2)]'];
    labeltc_TRs_rep = [labeltc_TRs_rep; segblock];
end
labeltc_TRs = [];
for j = 1:max(rowTR_rep) % should be 1976
    ii = rowTR_rep==j;
    newrow = mean(labeltc_TRs_rep(ii,:),1);
    labeltc_TRs(j,:) = newrow;
end
for n = 1:size(labeltc_TRs,2) % normalize values
    labeltc_TRs(:,n) = (labeltc_TRs(:,n)-min(labeltc_TRs(:,n)))/(max(labeltc_TRs(:,n))-min(labeltc_TRs(:,n)));
end
% labeltc_TRs is 1976 rows (TRs) x 10 labels

namelen = 5;
for n = 1:length(labelnames)
    labelnames_short{n} = strrep(labelnames{n}(1:namelen),'_','');
end
scenetimes = load(fullfile(basepath,'subjects','sherlock_allsubs_events.mat'),'ev');
ev.encoding = [scenetimes.ev.s1.fullSL1; scenetimes.ev.s1.fullSL2 + 946]; % length of sherlock1 movie = 946

figure(69); clf; set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[55 41 1222 936]);
imagesc([labeltc_TRs]); hold on; colormap(hot); xlim([-0.2 25]);
set(gca,'FontSize',12); set(gca,'XTick',[1:10],'XTickLabel',labelnames_short);
left_tx = 0.2; right_tx = 10.8;
scenestart = ev.encoding(:,1);
plot(right_tx*ones(size(scenestart,1),1),scenestart,'b<','LineWidth',3);
plot(left_tx*ones(size(scenestart,1),1),scenestart,'b>','LineWidth',3);
step = size(labeltc_TRs,1)/51; tvec = [step:step:size(labeltc_TRs,1)]; tvec = tvec(1:50);
xval = 12.5;
for t = 1:length(tvec)
    th = text(xval,tvec(t),scene_title{t});
    plot([right_tx xval],[scenestart(t) tvec(t)],'b-');
end





