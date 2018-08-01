
function v = sherlock_get_subj_info(infostr,cond)
% information about subject IDs and cropping.
% this is where you could store information about how much to temporally crop the data if you wanted to crop on the fly;
% these parameters are used in sherlock_nifti_roi_timecourse.
% for example, if subjects 2 and 4 needed to have 26 TRs cropped from the end, you would set this parameter:
%   crop_special = [2 0 26; 4 0 26];
%   any subjects who are not listed in "crop_special" would have the default croppings applied (crop_beginning and crop_end).
% the sherlock data are already cropped so that all movie-viewing data are aligned across subjects,
% and all recall data are aligned to the scene timestamps,
% thus all the cropping information stored here is zeros.

switch cond
    case 'sherlock_movie'
        names = {'s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13','s14','s15','s16','s17'};
        crop_beginning = 0;
        crop_end = 0;
        crop_special = 0;
    case 'sherlock_recall'
        names = {'s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13','s14','s15','s16','s17'};
        crop_beginning = 0;
        crop_end = 0;
        crop_special = 0;
end

switch infostr
    case 'names', v = names;
    case 'crop_beginning', v = crop_beginning;
    case 'crop_end', v = crop_end;
    case 'crop_special', v = crop_special;

end
