
info_summary_TomLocal_congr_200701 %% TO BE CHANGED

NUMBEROFCLUSTER = 1 %% TO BE CHANGED
cluster_Enc = load([folder_with_matfile 'clusterEnc.mat']) %% TO BE CHANGED
cluster_Ret = load([folder_with_matfile 'ClusterRet.mat']) %% TO BE CHANGED

baseline = [-1.5 -.5]

mask_ciao_Enc = [6 7 8 9 10 15 16 17 18 21 22 23 24] %% TO BE CHANGED Excluding SA
mask_ciao_Retr= [1 2 3 4 11 12 13 14 15 16 17] %% TO BE CHANGED excluding SA for low performance

%%
conditions = [1 2 3 4 5 6 7 8 9];


for Njobs = 3
    
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
    for session = 3
        
        
        
        %% read out and prepare for stats
        
        for cl = 1:NUMBEROFCLUSTER%:length(cluster)
            
            switch session
                case 1
                    % Encoding
                    folderfiles_save = folderfiles_Enc_save;
                    cluster = cluster_Enc.cluster;
                    cluster{1,cl}(mask_ciao_Enc,:)=[];
                    sessionname = 'ENC'
                    test_latency = [0 2];
                    
                case 2
                    % Retrieval
                    folderfiles_save = folderfiles_Ret_save;
                    cluster = cluster_Ret.cluster;
                    cluster{1,cl}(mask_ciao_Retr,:)=[];
                    sessionname = 'RET'
                    test_latency = [0 2];
                    
                case 3
                    % Retrieval RESP
                    folderfiles_save = folderfiles_Ret_save; % for the baseline!
                    folderfiles_save_RESP = folderfiles_Ret_save_RESP;
                    cluster = cluster_Ret.cluster;
                    cluster{1,cl}(mask_ciao_Retr,:)=[];
                    sessionname = 'RET Resp'
                    test_latency = [-2 0];
                    %
            end
            
            clear tl*
            
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
                build_pseudo_200701
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
            
            
            
            %% merging
            % in each Njob iteration, it is possible to combine conditions
            % together before testing. The conditions to merge are
            % specified in each row cc of the matrix 'combinations':
            % tl_Comb<CC>
            for cc = 1:size(combinations,1)
                combstring = [];
                for cc2 = 1:size(combinations,2)
                    if  combinations(cc,cc2)>0
                        combstring = [combstring 'tl_Group' num2str(combinations(cc,cc2)) ','];
                    end
                end
                cfg = [];
                eval([ 'hit = ft_appenddata(cfg,' combstring(1:end-1) ');'])
                for tr = 1:length(hit.trial)
                    eval(['tl_Comb' num2str(cc) '.trial(tr,1,:) = hit.trial{1,tr}(1,:);'])
                end
                eval(['tl_Comb' num2str(cc) '.label = hit.label;'])
                eval(['tl_Comb' num2str(cc) '.time  = hit.time{1,1};'])
                %            eval(['tl_Comb' num2str(cc) '.fsample  = hit.fsample;'])
            end
            
            % for Retrieval response locked with different names
            if session == 3
                for cc = 1:size(combinations,1)
                    combstring = [];
                    for cc2 = 1:size(combinations,2)
                        if  combinations(cc,cc2)>0
                        combstring = [combstring 'tl_Group' num2str(combinations(cc,cc2)) '_RESP,'];
                        end
                    end
                    cfg = [];
                    eval([ 'hit = ft_appenddata(cfg,' combstring(1:end-1) ');'])
                    for tr = 1:length(hit.trial)
                        eval(['tl_Comb' num2str(cc) '_RESP.trial(tr,1,:) = hit.trial{1,tr}(1,:);'])
                    end
                    eval(['tl_Comb' num2str(cc) '_RESP.label = hit.label;'])
                    eval(['tl_Comb' num2str(cc) '_RESP.time  = hit.time{1,1};'])
                    %            eval(['tl_Comb' num2str(cc) '.fsample  = hit.fsample;'])
                end
            end
            
            %% TF estimation
            % TFR<CC>
            TFnorm_StaresinaELife2016_200701
            
 
            %%  stat for all comparison across selected combinations
           % stat<cc1 cc2>
           comp =nchoosek(1:size(combinations,1),2); % creates all possible combinations among TFR groups
            for cc = 1:size(comp,1)
                
                eval(['stat' num2str(comp(cc,1))  num2str(comp(cc,2)) '  = fun_TF_stat(TFR' num2str(comp(cc,1)) ', TFR' num2str(comp(cc,2)) ',test_latency);'])
                
                figurename = [ char(combinationsnamess(comp(cc,1)))  ' vs ' char(combinationsnamess(comp(cc,2)))];
                eval(['stat = stat' num2str(comp(cc,1))  num2str(comp(cc,2))]);
                TF_stat_plot
                set(gcf, 'position', get(0, 'screensize'))
                if session < 3
                    saveas(gcf, [ folderfiles_save  sessionname '_' figurename '.bmp'])
                    save([ folderfiles_save   sessionname '_' figurename '.mat'],'stat')
                else
                    saveas(gcf, [ folderfiles_save_RESP  sessionname '_' figurename '.bmp'])
                    save([ folderfiles_save_RESP   sessionname '_' figurename '.mat'],'stat')
                end
                close all
            end
            
            
            
        end
        
    end
    
end
