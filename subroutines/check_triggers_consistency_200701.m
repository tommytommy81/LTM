% check_triggers_consistency
%% load trigger
load([folder_triggers char(subj_ID(id)) '_RET.mat'])

% EPRIME_RESP = xlsread(fileEprime,[char(subj_ID(id)) '_RET'],'BL2:BL301')
Ntrials_aftercheck = []

for trltyp = 1:size(list_trial_type,1)
    
folderin = [foldertrials list_trial_type(trltyp,1) '\']

list_of_good_trials = ls([folderin 'data*.mat']);
Ntrials = size(list_of_good_trials,1);

id_of_good_trials = str2num(list_of_good_trials(:,end-5:end-3));

switch trltyp
    
    case 1%-Correct High
        checklen(trltyp) = (Ntrials == length(correct_high(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(correct_high(id_of_good_trials))];
    case 2%-Correct Low
        checklen(trltyp) = (Ntrials == length(correct_low(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(correct_low(id_of_good_trials))];
    case 3%-Correct Mediumm
        checklen(trltyp) = (Ntrials == length(correct_middle(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(correct_middle(id_of_good_trials))];
    case 4%- Incorrect High
        checklen(trltyp) = (Ntrials == length(incorrect_high(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(incorrect_high(id_of_good_trials))];
    case 5%- Incorrect Low
        checklen(trltyp) = (Ntrials == length(incorrect_low(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(incorrect_low(id_of_good_trials))];
    case 6%- Incorrect Medium
        checklen(trltyp) = (Ntrials == length(incorrect_middle(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(incorrect_middle(id_of_good_trials))];
    case 7%- Miss High
        checklen(trltyp) = (Ntrials == length(miss_high(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(miss_high(id_of_good_trials))];
    case 8%- Miss Low
        checklen(trltyp) = (Ntrials == length(miss_low(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(miss_low(id_of_good_trials))];
    case 9%- Miss Medium
        checklen(trltyp) = (Ntrials == length( miss_middle(id_of_good_trials)));
        Ntrials_aftercheck = [Ntrials_aftercheck; Ntrials   length(miss_middle(id_of_good_trials))];
         
end

end

Ntrials_aftercheck

% check that for each condition the number of triggers matches the number of trials extracted
if sum(checklen) == 9
    disp([char(subj_ID(id)) '_RET: number of trials and triggers consistent! Bravo Sep!'])
else
    error([char(subj_ID(id)) '_RET: something is wrong with triggers'])
end
       