
function sherlock_plot_recall_behav(basepath,subject_number)

load(fullfile(basepath,'subjects','sherlock_allsubs_events.mat'),'ev');

names = fieldnames(ev);

subjID = names{subject_number};

movie_length_part1 = ev.(subjID).fullSL1(end);
all_movie_scenetimes = [ev.(subjID).fullSL1; ev.(subjID).fullSL2+movie_length_part1];
full_movie_length = all_movie_scenetimes(end);

recall_scenetimes = ev.(subjID).events.freerecall;
recall_length = recall_scenetimes(end);
subj_movie_scenetimes = [ev.(subjID).events.SL1; ev.(subjID).events.SL2+movie_length_part1];

% initialize the display matrix
display_mat = zeros(full_movie_length,recall_length);

% fill the display matrix wherever movie and recall overlap
for n = 1:size(subj_movie_scenetimes,1)
    movie_scene_start = subj_movie_scenetimes(n,1);
    movie_scene_end = subj_movie_scenetimes(n,2);
    recall_scene_start = recall_scenetimes(n,1);
    recall_scene_end = recall_scenetimes(n,2);
    display_mat(movie_scene_start:movie_scene_end,...
        recall_scene_start:recall_scene_end)...
        = 1;
end

% plot the display matrix
figure(1)
clf
set(gcf,'Color',[1 1 1]);
imagesc(display_mat);
title(['Subject ' num2str(subject_number)]);
colormap parula







