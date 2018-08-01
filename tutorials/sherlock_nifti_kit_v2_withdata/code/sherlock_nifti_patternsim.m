
function [mcorrmat mdiag allsubs_corrmat allsubs_mdiag] = ...
    sherlock_nifti_patternsim(basepath,names,roiname,condname,savefiles)
% Calculate 1-vs-avg-others correlation matrices

if ~exist('savefiles','var')
    savefiles = 0;
end

% load ROI data
for n = 1:length(names)
    opts.crop_beginning = sherlock_get_subj_info('crop_beginning',condname); 
    opts.crop_end = sherlock_get_subj_info('crop_end',condname); 
    opts.crop_special = sherlock_get_subj_info('crop_special',condname);
    rname = fullfile(basepath,'subjects',names{n},condname,[roiname '_' condname '_' names{n} '.mat']);
    if ~exist(rname)
        fprintf(['ROI data not found for ' names{n} ' -- aborting\n']);
        keyboard
        return
    else
        r = load(rname);
        subj_roitc = crop_roitc(n,r.rdata,opts);
        roidata(n).(condname) = zscore(subj_roitc')'; % zscore across time
        roikeptvox(n).(condname) = r.keptvox;
    end
end

clear corrmat mdiag
for n = 1:length(names)
    
    % get data for this subject
    subj_data = roidata(n).(condname);
    
    % calculate average of all other subjects
    others = setdiff([1:length(names)],n);
    others_alldata = [];
    for k = 1:length(others)
        osubj = others(k);
        others_alldata(:,:,k) = roidata(osubj).(condname);
    end
    others_data = nanmean(others_alldata,3);
    
    corrmat = corr(subj_data,others_data);
    allsubs_corrmat(:,:,n) = corrmat;
    allsubs_mdiag(:,n) = diag(corrmat);
    
    fprintf(['subj ' num2str(n) ' ' num2str(mean(diag(corrmat))) '\n']);
end

mcorrmat = mean(allsubs_corrmat,3);
mdiag = mean(allsubs_mdiag,2);

if savefiles
    if ~exist(fullfile(basepath,'intersubj','patternsim'))
        mkdir(fullfile(basepath,'intersubj'),'patternsim');
    end
    savename = fullfile(basepath,'intersubj','patternsim',[roiname '_' condname '_patternsim.mat']);
    save(savename,'mcorrmat','mdiag','allsubs_corrmat','allsubs_mdiag');
end

function subj_roitc = crop_roitc(sid,subj_roitc,opts)
if ~ismember(sid,opts.crop_special(:,1))
    subj_roitc(:,1:opts.crop_beginning) = []; % crop TRs from beginning of time series
    subj_roitc(:,end-opts.crop_end+1:end) = []; % crop TRs from end of time series
elseif ismember(sid,opts.crop_special(:,1)) % crop different begin/end TRs for specified subjects
    cid = find(sid==opts.crop_special(:,1));
    crop_begin = opts.crop_special(cid,2);
    crop_end = opts.crop_special(cid,3);
    if crop_begin<0 % adds timepoints to the beginning of series if needed
        for k = 1:crop_begin*-1
            subj_roitc(:,2:end+1) = subj_roitc;
        end
    end
    subj_roitc(:,1:crop_begin) = []; % crop TRs from beginning of time series
    if crop_end<0
        for k = 1:crop_end*-1
            subj_roitc(:,end+1) = subj_roitc(:,end);
        end
    end
    subj_roitc(:,end-crop_end+1:end) = []; % crop TRs from end of time series
end
















