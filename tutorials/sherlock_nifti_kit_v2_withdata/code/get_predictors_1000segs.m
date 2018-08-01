
function [content_var,content_label,scene_title] = get_predictors_1000segs(basepath,content_label,plotme)
% [content_var,content_label,scene_title] = get_predictors_1000segs(basepath,content_label,plotme)

%% load content labels

[num,txt,raw] = xlsread(fullfile(basepath,'subjects','Sherlock_Segments_1000_NN_2017.xlsx'));
% remove header row from txt to make indexing easier
header_row = txt(1,:); 
txt = txt(2:end,:); % now the row also corresponds to the segment number
txt(481:482,:) = []; % no fmri data for these last two segments of part 1
num(481:482,:) = [];

%% Read scene titles from column 6
count = 1;
for row = 1:size(txt,1)
    x = txt{row,6};
    if ~isempty(deblank(x))
        scene_title{count} = deblank(txt{row,6});
        scene_start_seg(count) = row;
        count = count+1;
    end
end

%% calculate stimulus metrics 

fprintf(['\n' content_label '\n']);
vec = []; vec_str = [];
switch content_label
    case {'indoor','outdoor'} % indoor/outdoor, column 8
        vec = txt(:,8);
        indoor_segs = strcmp(vec,'Indoor');
        outdoor_segs = strcmp(vec,'Outdoor');
        
        if strcmp(content_label,'indoor')
            content_var = indoor_segs;
        elseif strcmp(content_label,'outdoor')
            content_var = outdoor_segs;
        end
        
    case 'numpersons' % total number of characters in the segment, column 9
        clear charlist num_persons scon remain token
        vec = txt(:,9);
        for n = 1:size(vec,1)
            charlist = []; count = 1;
            remain = vec{n,:};
            while 1
                [token, remain] = strtok(remain,',');
                token = strtrim(token);
                charlist{count} = token; count = count + 1;
                if isempty(remain)
                    break
                end
            end
            if sum(strmatch('Nobody',charlist))>0
                num_persons(n) = length(unique(charlist)) - 1;
            else
                num_persons(n) = length(unique(charlist));
            end
        end
        num_persons = num_persons';
        content_var = num_persons;
        
    case {'music'} % music present: col 14
        vec_str = txt(:,14);
        for n = 1:size(vec_str,1)
            if strcmp(vec_str(n),'Yes')
                vec(n) = 1;
            elseif strcmp(vec_str(n),'No')
                vec(n) = 0;
            end
        end
        content_var = vec';
        
    case {'speaking'} % speaking present: col 11
        vec_str = txt(:,11);
        for n = 1:size(vec_str,1)
            if ~isempty(vec_str{n})
                vec(n) = 1;
            else
                vec(n) = 0;
            end
        end
        content_var = vec';
        
    case {'writwords'} % written words present: col 15
        vec_str = txt(:,15);
        for n = 1:size(vec_str,1)
            if ~isempty(vec_str{n})
                vec(n) = 1;
            else
                vec(n) = 0;
            end
        end
        content_var = vec';
               
    case {'Sherlock_onscreen','John_onscreen','Lestrade_onscreen','Mrs. Hudson_onscreen','The Man_onscreen',...
            'Donovan_onscreen','Molly_onscreen'}
        % identify when a character is on the screen
        vec_str = txt(:,9);
        charname = content_label(1:find(content_label=='_')-1);
        for n = 1:size(vec_str,1)
            if strfind(vec_str{n},charname)
                vec(n) = 1;
            else
                vec(n) = 0;
            end
        end
        content_var = vec';
        
    case {'Sherlock_speaking','John_speaking','Lestrade_speaking','Mrs. Hudson_speaking','The Man_speaking',...
            'Donovan_speaking','Molly_speaking'}
        % identify when a character is speaking
        vec_str = txt(:,11);
        charname = content_label(1:find(content_label=='_')-1);
        for n = 1:size(vec_str,1)
            if strfind(vec_str{n},charname)
                vec(n) = 1;
            else
                vec(n) = 0;
            end
        end
        content_var = vec';  
        
    case {'locations'} % location: col 12 (location unique ID, not the number of locations!)
        vec = txt(:,12);
        loclist = unique(vec);
        for n = 1:size(loclist,1)
            ii = strmatch(loclist{n},vec);
            locations(ii) = n;
        end
        locations = locations';
        content_var = locations;
        
    case{'arousal'}
        arousal(:,1) = num(:,16);
        arousal(:,2) = num(:,18);
        arousal(:,3) = num(:,20);
        arousal(:,4) = num(:,22);
        arousal_cronbach = cronbach(arousal);
        arousal_mean = mean(arousal,2);
        content_var = arousal_mean;
        
    case{'valence'}
        valence(strcmp(txt(:,17),'-'),1) = -1; valence(strcmp(txt(:,17),'+'),1) = 1;
        valence(strcmp(txt(:,19),'-'),2) = -1; valence(strcmp(txt(:,19),'+'),2) = 1;
        valence(strcmp(txt(:,21),'-'),3) = -1; valence(strcmp(txt(:,21),'+'),3) = 1;
        valence(strcmp(txt(:,23),'-'),4) = -1; valence(strcmp(txt(:,23),'+'),4) = 1;
        valence_cronbach = cronbach(valence);
        valence_mean = mean(valence,2);
        content_var = valence_mean;

end
content_var = double(content_var);

%%
if plotme
    figure(89); clf; set(gcf,'Color',[1 1 1]);
    plot(content_var,'Color','r'); hold on
    set(gca,'FontSize',18);
    maxm = max(content_var); minm = min(content_var);
    ylim([minm-1.5 maxm+0.5]); title(strrep(content_label,'_','-'));
    set(gcf,'Position',[12 243 1633 742]);
    for ss = 1:length(scene_start_seg)
        plot([scene_start_seg(ss) scene_start_seg(ss)],[minm-2 maxm+0.5],'Color',[0.7 0.7 0.7],'LineStyle','--');
    end
    for ss = 1:length(scene_start_seg)
        th=text(scene_start_seg(ss),(mod(ss,10)*-0.1)-0.2+minm,scene_title{ss});
        set(th,'FontSize',10);
    end
    plot(content_var,'Color','r');
    set(gca,'YTick',[0:1:max(content_var)]);
    xlabel('Time')
end














