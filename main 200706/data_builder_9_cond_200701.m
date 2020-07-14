%% debugged and approved by T. Fedele on 06.07.2020
% please do not touch anymore!

% the script reads single trials which passed proproc,
% and organize them in a fieldtrip struct per cond per subj

% the guiding info are based on 
% info_summary_TomLocal_congr_200701.m
 info_summary_TomLocal_congr_200701
 
%%

for id = 1:length(subj_ID) 
    
    char(subj_ID(id))
    %%
    for session = 3
        
               
        switch session
            case 1
                % Encoding
                foldertrials      =  [datafile_sep_Enc_trials char(subj_ID(id)) '\'] ;
                  folderfiles       =  datafile_sep_Enc;
                    folderfiles_save  = folderfiles_Enc_save;
                    good_chans_file   = good_chans_Enc_file;
                
            case 2
                % Retrieval
                foldertrials     =  [datafile_sep_Ret_trials char(subj_ID(id)) '\'] ;                
                folderfiles      =  datafile_sep_Ret;
                folderfiles_save = folderfiles_Ret_save;
                good_chans_file  = good_chans_Ret_file;

            case 3
                % Retrieval to RESP TIME
                foldertrials     =  [datafile_sep_Ret_trials char(subj_ID(id)) '\'] ;                
                folderfiles      =  datafile_sep_Ret_RESP;
                folderfiles_save = folderfiles_Ret_save_RESP;
                good_chans_file  = good_chans_Ret_file;                 
                EPRIME_RESP      = xlsread(fileEprime,[char(subj_ID(id)) '_RET'],'BL2:BL301');
                
         end
        
        % if the subject data exist, make a .mat with all trials in each
        % condition (1-9)
        if exist(foldertrials)
            
            list_trial_type   = dir([foldertrials]);
            list_trial_type(1:2,:) = [];
            isdir_flag        = cell2mat(extractfield(list_trial_type,'isdir'));
            list_trial_type   = extractfield(list_trial_type,'name');
            list_trial_type   = char(list_trial_type(isdir_flag==1)');
            if session >= 2
            check_triggers_consistency_200701 %check consistency before adding RESP delay
            end
            for trltyp = 1:size(list_trial_type,1)
                folderin = [foldertrials list_trial_type(trltyp,1) '\']
                
                if session < 3 % Enc and Retr to onset time
                % locked to stim onset                
                trialcollector200701(folderin, folderfiles, char(subj_ID(id)),list_trial_type(trltyp,1));
                
                else % Retr to Resp Time
                % locked to response
                trig_local_200701
                EPRIME_RESP_loc = EPRIME_RESP(trig_ind_loc); % response in s for all trial of this category
                trialcollector_RESP_200701(folderin, folderfiles, char(subj_ID(id)),list_trial_type(trltyp,1),EPRIME_RESP_loc);
                end
            end
        end
        
         
        
        %% merging trial
        
        
        list           = ls([folderfiles '\*' char(subj_ID(id)) '*.mat']); % check the list of trials
        good_chs       = find(xlsread(good_chans_file,char(subj_ID(id)),'A1:A100'));
        [~,good_chs_labels,~]       =  xlsread(good_chans_file,char(subj_ID(id)),'C1:C100');
        
        
        if session >= 2 & id == 4
            good_chs = good_chs-12;
            good_chsciao=good_chs<1;
            good_chs(good_chsciao)=[]
            good_chs_labels(good_chsciao)=[]
            good_chs_labels (1:4)= []
        end
        
        %channel_labels = xlsread(regionsfile,char(subj_ID(id)),'A3:A100');
        
        coord          = xlsread(regionsfile,char(subj_ID(id)),char(subj_excel_regions2(id)));    
        [~,anat_label]= xlsread(regionsfile,char(subj_ID(id)),char(subj_excel_anatomy(id)));
        
        %%
        for ff = 1:size(list,1)    % assemble trials in one file ft format
            
            char(subj_ID(id))
            
            WHEREWEARE = [id session ff]
            
            clear data
            
            load([folderfiles list(ff,:)])
            
            
            %select only good channels
            if  id == 4
                for tr = 1:size(data.trial,2)
                    data.trial{1,tr}(1:12,:) = [];
                end                
                data.label(1:12) = []; 
            end
            
            if  session == 1 & id == 6
                for tr = 1:size(data.trial,2)
                    data.trial{1,tr}([1:20 37:44],:) = [];
                end                
                data.label([1:20 37:44]) = [];             
            end
            
            if  id == 7 & session >= 2  
                for tr = 1:size(data.trial,2)
                data.trial{1,tr}(25:end,:) = [];
                end
                data.label(25:end) = [];
            end               
            
            data = prunedata(data, good_chs, coord, subj_ID, id, ff, anat_label);               
            
            timebase = [-.5 0]; % interval for the baseline in seconds
            data     = baseline_correction(data, timebase)
             
            
%             timebase = [-.5 0]; % interval for the baseline in seconds
%             data = zscore_seeg(data,timebase)
            
            [ data.label good_chs_labels(good_chs)]
            [sum(ismember(data.label, good_chs_labels(good_chs))) length(data.label)]
            data.label = good_chs_labels(good_chs);
            
            
%             data.time{1,3}(1)             
            mkdir(folderfiles_save)
            
            save([folderfiles_save list(ff,:)],'data')
            
        end % condition
        
        data
        
    end % session
    
end % subject
