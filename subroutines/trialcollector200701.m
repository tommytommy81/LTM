% regionsfileTAB = 'SP'
% condition = '3'
% folderfiles = 'C:\Users\Sep\Desktop\Graphs\exported epochs\SP\Enc\3\'
% regionsfile = 'C:\Users\Sep\Desktop\Graphs\regions2.xlsx'
% 
% % foldersave = 'C:\Users\Tom\Google Drive\__PC_HSE\Results\iEEG Sep\code\'
% foldersave= 'C:\Users\Sep\Desktop\Graphs\exported epochs\WC\Enc\Results'

%%
function trialcollector200701(folderin, folderout, pat_id, condition)

clear data

list  = ls([folderin '\data*.mat']); % check the list of trials

for ff = 1:size(list,1)    % assemble trials in one file ft format
    load([folderin list(ff,:)])
%     if ff == 1
%      data.trial{1,ff} = avg;
%     data.time{1,ff} = time;
%     else
    data.trial{1,ff} = F; % assuming data starting from -2
    data.time{1,ff} = Time;
%     end
end

% data.elec = elec; % positions
% % Nch = length(data.label)
% data.elec.elecpos = xlsread(regionsfile, regionsfileTAB, ['B3:D' num2str(3+48-1)]) % check excel file
% data.elec.chanpos =data.elec.elecpos;
load([folderin 'channel.mat'])
data.label = extractfield(Channel,'Name')';
mkdir(folderout)
save([folderout '\alltrials_' pat_id '_cond' condition],'data')


