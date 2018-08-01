
function nifti_crop(filename,crop_begin,crop_end)

% j chen 07/01/2013

[fpath filename_noext] = fileparts(filename);
nii = load_nii(filename);
dsize = size(nii.img);
nii.img = crop_img(nii.img,crop_begin,crop_end);
nii.hdr.dime.dim(5) = size(nii.img,4);

new_filename = [filename_noext '_cropped_' num2str(crop_begin+1) '_to_' num2str(dsize(4)-crop_end) '.nii'];
save_nii(nii,fullfile(fpath,new_filename));

function data = crop_img(data,crop_begin,crop_end)
    if crop_begin<0 % adds timepoints to the beginning of series if needed
        for k = 1:crop_begin*-1
            data(:,:,:,2:end+1) = data;
        end
    end
    data(:,:,:,1:crop_begin) = []; % crop TRs from beginning of time series
    if crop_end<0 % adds timepoints to the end of series if needed
        for k = 1:crop_end*-1
            data(:,:,:,end+1) = data(:,:,:,end);
        end
    end
    data(:,:,:,end-crop_end+1:end) = []; % crop TRs from end of time series
end

end
