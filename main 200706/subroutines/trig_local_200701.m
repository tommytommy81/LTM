% take trigger for the condition in the loop trltyp
%% load trigger

list_of_good_trials = ls([folderin 'data*.mat']);
id_of_good_trials = str2num(list_of_good_trials(:,end-5:end-3));

switch trltyp
    
    case 1%-Correct High
        trig_ind_loc = correct_high(id_of_good_trials);
    case 2%-Correct Low
        trig_ind_loc = correct_low(id_of_good_trials);
    case 3%-Correct Mediumm
        trig_ind_loc = correct_middle(id_of_good_trials);
    case 4%- Incorrect High
        trig_ind_loc = incorrect_high(id_of_good_trials);
    case 5%- Incorrect Low
        trig_ind_loc = incorrect_low(id_of_good_trials);
    case 6%- Incorrect Medium
        trig_ind_loc = incorrect_middle(id_of_good_trials);
    case 7%- Miss High
        trig_ind_loc = miss_high(id_of_good_trials);
    case 8%- Miss Low
        trig_ind_loc = miss_low(id_of_good_trials);
    case 9%- Miss Medium
        trig_ind_loc =  miss_middle(id_of_good_trials);
         
end

 
       