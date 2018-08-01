
function sherlock_roi(basepath,rois1,save_or_calc,conds_to_run,niftipath)
%% extract ROI data from the movie and recall nifti files
% save the output as mat files for faster loading
% calculate some basic properties of the ROI data (see nifti_roi_timecourse)

if ~exist('niftipath','var'), niftipath = 'none'; end

%%
for rr = 1:length(rois1)
    roi1 = rois1{rr};
    
    % 'savedata': save roi data as .mat for faster reanalysis.
    % or 'loaddata': load pre-saved roi .mat data and calculate isc, saving output in the 'intersubj' folder.
    if strcmp(save_or_calc,'savedata')
        roidataflag = 'savedata';
    else
        roidataflag = 'loaddata';
    end
    
    conds = {'sherlock_movie','sherlock_recall'}; % list of all possible conditions
    for cc = 1:length(conds_to_run)
        funcnames = []; roinames = []; condname = conds_to_run{cc};
        if ~ismember(condname,conds), continue; end
        ci = strmatch(condname,conds);
        outname = condname;
        names = sherlock_get_subj_info('names',condname);
        for n = 1:length(names)
            funcnames{n} = fullfile(basepath,'subjects',names{n},condname,[condname '_' names{n} '.nii']);
            roinames{n} = fullfile(basepath,'standard',roi1);
        end
        fprintf(['cond = ' condname ', output will be saved as ' rois1{rr}(1:end-4) '_' outname '_roicorr.mat\n']);
        
        opts.outputPath = fullfile(basepath,'intersubj','roicorr');
        opts.outputName = outname;
        opts.crop_beginning = 0;
        opts.crop_end = 0;
        opts.crop_special = [];
        opts.roidata = roidataflag;
        if strcmp(condname,'sherlock_recall') && strcmp(roidataflag,'loaddata'), continue; end
        sherlock_nifti_roi_timecourse(funcnames, roinames, opts, niftipath);
        if strcmp(roidataflag,'savedata') % if using savedata flag, auto-run loaddata afterward
            opts.roidata = 'loaddata';
        end
    end
end




