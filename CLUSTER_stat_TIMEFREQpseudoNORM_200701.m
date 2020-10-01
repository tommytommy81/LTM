
% info_summary_TomLocal_congr_200701 %% TO BE CHANGED
% info_summary_AliciaTask_200929


%% Njobs

for Njobs = 1
    
    switch Njobs
        case 1
            combinations = [1 2 3; 4 5 6; 7 8 9]; % associative memory all
            combinationsnamess = {'CA','IA','Miss'}
            
        case 2
            combinations = [1 4 7; 2 5 8; 3 6 9]; % congruency all
            combinationsnamess = {'high','low','Medium'}
            
        case 3
            combinations = [1  ; 4  ; 7  ]; % associative memory all
            combinationsnamess = {'Corr high','Corr low','Corr Medium'}
    end
    
    
    %% READ ME
    
    % set the vriable conditions according to:
    
    % 1-Correct High
    % 2-Correct Low
    % 3-Correct Mediumm
    %
    % 4- Incorrect High
    % 5- Incorrect Low
    % 6- Incorrect Medium
    %
    % 7- Miss High
    % 8- Miss Low
    % 9- Miss Medium
    
    % i.e.
    % conditions = [1 2 3 4 5 6];
    
    %%
    for session = 1:2
        
        
        
        %% session settings
        
        switch session
            case 1
                % Encoding
                folderfiles_save = folderfiles_Enc_save;
                folderfiles_save_PICS = [folderfiles_save 'PICS\'];
                cluster = cluster_Enc.cluster;
                %                     cluster{1,cl}(mask_ciao_Enc,:)=[];
                sessionname = 'ENC'         
                
            case 2
                % Retrieval
                folderfiles_save = folderfiles_Ret_save;
                folderfiles_save_PICS = [folderfiles_save 'PICS\'];
                cluster = cluster_Ret.cluster;
                %                     cluster{1,cl}(mask_ciao_Retr,:)=[];
                sessionname = 'RET'
                
            case 3
                % Retrieval RESP
                folderfiles_save = folderfiles_Ret_save; % for the baseline!
                folderfiles_save_RESP = folderfiles_Ret_save_RESP;
                folderfiles_save_PICS = [folderfiles_save_RESP 'PICS\'];
                cluster = cluster_Ret.cluster;
                %                     cluster{1,cl}(mask_ciao_Retr,:)=[];
                sessionname = 'RET Resp'
                test_latency = [-2 0];
                %
        end
        
        mkdir(folderfiles_save_PICS)
        
        %% read out and prepare for stats
        
        clear tl*
        for cl = 1:length(cluster)
            
            % prepare the structure for time data of all conditions
            for cond = 1:length(conditions)
                cond1 = conditions(cond);
                eval(['tl_Group' num2str(cond1) '.trial = [];']);
                eval(['tr_end' num2str(cond1) ' = 1;']);
            end
            
            % create time struct for all channels in this cluster:
            % tl_Group<COND>
            for elem = 1:size(cluster{1,cl},1)
                id = round(cluster{1,cl}(elem,4)*1000);
                ch = round(cluster{1,cl}(elem,5)*1000);
                build_pseudo
            end
                        
            % if it is about Retr Resp Locked, the names are different
            if session == 3
                for cond = 1:length(conditions)
                    cond1 = conditions(cond);
                    eval(['tl_Group' num2str(cond1) '_RESP.trial = [];']);
                    eval(['tr_end' num2str(cond1) ' = 1;']);
                end
                
                for elem = 1:size(cluster{1,cl},1)
                    id = round(cluster{1,cl}(elem,4)*1000);
                    ch = round(cluster{1,cl}(elem,5)*1000);
                    build_pseudo3cond_RESP
                end
            end
            
            % check if the data is really there
            datacheck = 0;
            for cond = 1:length(conditions)
                cond1 = conditions(cond);
                eval(['datacheck = [datacheck + numel(tl_Group' num2str(cond1) '.trial)];'])
            end
            
            if (datacheck)
                
                WHEAREWE = [Njobs  session  cl]
                
                %% TF estimation
                % TFR<CC> baseline corrected for all conditions
                clear TFR*
                TFnorm
                
                %% merging
                % in each Njob iteration, it is possible to combine conditions
                % together before testing. The conditions to merge are
                % specified in each row cc of the matrix 'combinations':
                % tl_Comb<CC>
                if session < 3                    
                    for cc = 1:size(combinations,1)
                        combstring = [];
                        for cc2 = 1:size(combinations,2)
                            if  combinations(cc,cc2)>0
                                combstring = [combstring 'TFR' num2str(combinations(cc,cc2)) ','];
                            end
                        end
                        cfg = [];
                        cfg.appenddim = 'rpt'
                        eval([ 'hit = ft_appendfreq(cfg,' combstring(1:end-1) ');'])
                        eval(['tl_TFRComb' num2str(cc) ' = hit;'])                        
                    end
                    
                    % rename tl_TFRComb to  TFR
                    for cc = 1:size(combinations,1)
                        eval(['TFR' num2str(cc) ' = tl_TFRComb' num2str(cc) ';'])
                    end
                    clear tl_TFRComb*
                else % for Retrieval response locked with different names
                    for cc = 1:size(combinations,1)
                        combstring = [];
                        for cc2 = 1:size(combinations,2)
                            if  combinations(cc,cc2)>0
                                combstring = [combstring 'TFR' num2str(combinations(cc,cc2)) '_RESP,'];
                            end
                        end
                        cfg = [];
                        cfg.appenddim = 'rpt'
                        eval([ 'hit = ft_appendfreq(cfg,' combstring(1:end-1) ');'])
                        eval(['tl_TFRComb' num2str(cc) ' _RESP = hit;'])
                    end
                    
                    % rename tl_TFRComb to  TFR
                    for cc = 1:size(combinations,1)
                        eval(['TFR' num2str(cc) ' _RESP = tl_TFRComb' num2str(cc) '_RESP;'])
                    end
                    clear tl_TFRComb*
                    
                end
                               
                %% merge all TF together
               cfg = [];
                        cfg.appenddim = 'rpt'
                TFRall = ft_appendfreq(cfg,TFR1,TFR2,TFR3);
                
                %% test within trial
                interval_to_Test = [0 2];
                SINGLECHANNEL_test_within_trials
            
                %% plot conditions separately
                
                plot_conditions_separately % subplot of the induced response
                
                if session < 3
                    saveas(gcf, [ folderfiles_save_PICS  sessionname '_' figurename '.bmp'])
                else % not possible
                    saveas(gcf, [ folderfiles_save_RESP_PICS  sessionname '_' figurename '.bmp'])
                end
                
                close all
                
                
                %%  stat for all comparison across selected combinations
                % stat<cc1 cc2>
                comp =nchoosek(1:size(combinations,1),2); % creates all possible combinations among TFR groups
                for cc = 1:size(comp,1)
                    
                    eval(['stat' num2str(comp(cc,1))  num2str(comp(cc,2)) '  = fun_TF_stat(TFR' num2str(comp(cc,1)) ', TFR' num2str(comp(cc,2)) ',opt_TFstat);'])
                    
                    figurename = [ char(combinationsnamess(comp(cc,1)))  ' vs ' char(combinationsnamess(comp(cc,2)))];
                    eval(['stat = stat' num2str(comp(cc,1))  num2str(comp(cc,2))]);
                    TF_stat_plot
                    set(gcf, 'position', get(0, 'screensize'))
                    if session < 3
                        savingname = [ folderfiles_save_PICS  sessionname '_cl_' num2str(cl) '_' figurename ];
                    else
                        savingname = [ folderfiles_save_PICS_RESP  sessionname '_cl_' num2str(cl) '_' figurename ];
                    end
                    saveas(gcf, [ savingname '.bmp'])
                    save([ savingname '.mat'],'stat')
                    close all
                    
                end % test comparisons
            end % datacheck
        end % cluster
    end % session
end % Njobs
