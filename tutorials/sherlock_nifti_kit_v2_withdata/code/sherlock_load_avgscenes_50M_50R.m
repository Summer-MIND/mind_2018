
function [allsubs_50M_events,allsubs_50FR_events,allsubs_iM_events,allsubs_iFR_events] =...
    sherlock_load_avgscenes_50M_50R(basepath,roiname,names,allsubs_events,condnames)

if ~exist('condnames','var')
    condnames = {'sherlock_movie','sherlock_recall'};
end

for n = 1:length(names)
    ev = allsubs_events.(names{n});
    nEvents = size(ev.SL_event_num,1);
    
    % create iM avg scenes: for each person, store only the data for movie scenes that they later recall
    clear M_events
    if ismember('sherlock_movie',condnames)
        movie_roidata = load(fullfile(basepath,'subjects',names{n},'sherlock_movie',...
            [roiname '_sherlock_movie_' names{n} '.mat']));
        M_data = movie_roidata.rdata;
        % the movie was shown in two scans, then the data were concatenated, so the timestamps need to be adjusted accordingly
        ev.encoding = [ev.events.SL1; ev.events.SL2 + 946]; % length of sherlock1 movie = 946
        
        % average across Encoding events for this subject
        for e = 1:size(ev.encoding,1)
            M_events(:,e) = mean(M_data(:,ev.encoding(e,1):ev.encoding(e,2)),2);
        end
        allsubs_iM_events{n} = M_events;
    else
        allsubs_iM_events = [];
    end
    
    % create iFR avg scenes: for each person, store the data for recalled scenes
    clear FR_events
    if ismember('sherlock_recall',condnames)
        recall_roidata = load(fullfile(basepath,'subjects',names{n},'sherlock_recall',...
            [roiname '_sherlock_recall_' names{n} '.mat']));
        FR_data = recall_roidata.rdata;
        
        % average across Encoding events for this subject
        for e = 1:size(ev.events.freerecall,1)
            FR_events(:,e) = mean(FR_data(:,ev.events.freerecall(e,1):ev.events.freerecall(e,2)),2);
        end
        allsubs_iFR_events{n} = FR_events;
    else
        allsubs_iFR_events = [];
    end
    
    % create 50M avg scenes: store the data for all 50 movie scenes
    clear M_events
    if ismember('sherlock_movie',condnames)
        % the movie was shown in two scans, then the data were concatenated, so the timestamps need to be adjusted accordingly
        ev.encoding = [ev.fullSL1; ev.fullSL2 + 946]; % length of sherlock1 movie = 946
        
        % average across Encoding events for this subject
        for e = 1:size(ev.encoding,1)
            M_events(:,e) = mean(M_data(:,ev.encoding(e,1):ev.encoding(e,2)),2);
        end
        allsubs_50M_events(:,:,n) = M_events;
    else
        allsubs_50M_events = [];
    end
    
    % create 50FR avg scenes: store the data for recalled scenes in the same column number as the corresponding movie scene
    % thus there will be nan columns for scenes that were not recalled
    clear FR_events
    if ismember('sherlock_recall',condnames)
        % average across FRecall events for this subject
        for e = 1:size(ev.events.freerecall,1)
            FR_events(:,e) = mean(FR_data(:,ev.events.freerecall(e,1):ev.events.freerecall(e,2)),2);
        end
        
        frnum = ev.events.freerecallnum;
        % expand to full scene list
        % scenes recalled multiple times will be averaged together
        temp = nan(size(FR_events,1),nEvents); % all 50 possible events
        tempcount = zeros(1,nEvents);
        for i = 1:length(frnum)
            temp(:,frnum(i)) = nansum([temp(:,frnum(i)) FR_events(:,i)],2);
            tempcount(frnum(i)) = tempcount(frnum(i)) + 1;
        end
        allsubs_50FR_events(:,:,n) = temp ./ repmat(tempcount,size(temp,1),1);
    else
        allsubs_50FR_events = [];
    end
end





