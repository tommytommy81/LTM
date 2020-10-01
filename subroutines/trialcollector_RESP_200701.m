% regionsfileTAB = 'SP'
% condition = '3'
% folderfiles = 'C:\Users\Sep\Desktop\Graphs\exported epochs\SP\Enc\3\'
% regionsfile = 'C:\Users\Sep\Desktop\Graphs\regions2.xlsx'
% 
% % foldersave = 'C:\Users\Tom\Google Drive\__PC_HSE\Results\iEEG Sep\code\'
% foldersave= 'C:\Users\Sep\Desktop\Graphs\exported epochs\WC\Enc\Results'

%%
function trialcollector_RESP_200701(folderin, folderout, pat_id, condition,EPRIME_RESP_loc)

clear data

list  = ls([folderin '\data*.mat']); % check the list of trials

%%
for ff = 1:size(list,1)    % assemble trials in one file ft format
    load([folderin list(ff,:)])
%     if ff == 1
%      data.trial{1,ff} = avg;
%     data.time{1,ff} = time;
%     else
    Fs = round(1/diff(Time(1:2)));
    [~,saample_RT]   = min(abs(Time-EPRIME_RESP_loc(ff)/1000));
    interval         = (saample_RT-2.5*Fs):(saample_RT+.5*Fs );
    Nch              = size(F,1);
    
    if interval(1)>0 & interval(end)<size(F,2)
    data.trial{1,ff} = F(:,interval);
    data.time{1,ff}  = Time(interval)-Time(saample_RT);
    data.RT(ff)      = EPRIME_RESP_loc(ff); % to be used later for outliers
    else
        
        
    data.trial{1,ff} = NaN*ones(Nch,length(interval));
    data.time{1,ff}  = NaN*ones(1,length(interval));
    data.RT(ff)      = EPRIME_RESP_loc(ff)/1000; % to be used later for outliers
    
    interval_pre  = length(find(interval<=0));
    interval_post = length(interval)-length(interval>size(F,2));
    
%     early response, put NaN at the end
    if interval_pre
        if interval_pre < 601
        data.trial{1,ff}(:,interval_pre+1:end) = F(:,interval_pre+1:length(interval));
        data.time{1,ff}(:,interval_pre+1:end)  = Time(interval_pre+1:length(interval))-Time(saample_RT);
        end
    else
        if interval_post > 0
        data.trial{1,ff}(:,1:interval_post) = F(:,interval(1):interval_post);
        data.time{1,ff}  = NaN*ones(1,length(interval));
        end
    end   
        end
end

%%

load([folderin 'channel.mat'])
data.label = extractfield(Channel,'Name')';
mkdir(folderout)
save([folderout '\alltrials_' pat_id '_cond' condition],'data')


