%%
% This created one plot for each channel with the average TF for each condition
% Quality check on channels

clear all

info_summary_AliciaTask_200929 %% TO BE CHANGED

session = 1
folderfiles_save_PICS = folderfiles_Enc_save_PICS;
cluster = cluster_Enc.cluster;


%%

for cl = 1:length(cluster)
    
    
    folderfiles_save = folderfiles_Enc_save;
    combinations = [1 2 3; 4 5 6; 7 8 9]; % associative memory all
    combinationsnamess = {'CA','IA','Miss'}
    
    clear tl*
    
    for elem = 1:size(cluster{1,cl},1)
        
        id = round(cluster{1,cl}(elem,4)*1000);
        ch = round(cluster{1,cl}(elem,5)*1000);
        
        clear tl*
        for cond = 1:length(conditions)
            cond1 = conditions(cond);
            eval(['tl_Group' num2str(cond1) '.trial = [];']);
            eval(['tr_end' num2str(cond1) ' = 1;']);
        end
        
        build_pseudo
        
        datacheck = 0;
        for cond = 1:length(conditions)
            cond1 = conditions(cond);
            eval(['datacheck = [datacheck + numel(tl_Group' num2str(cond1) '.trial)];'])
        end
        
        if datacheck % to skip missing data
            
            
            
            %% single channel TF for all selected conditions
            clear TFR*
            TFnorm
            
            %% merge TF in combinations
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
            %% merge all TF together
            
            TFRall = ft_appendfreq(cfg,TFR1,TFR2,TFR3);
            
            %% test within trial
            interval_to_Test = [0 2];
            SINGLECHANNEL_test_within_trials
            
            %%
            
            cfg              = [];
            cfg.zlim         = [0.5 2]
            cfg.xlim         = [-1 2];
            cfg.ylim         = [4 70];
            
            NPLOTS = size(combinations,1)+3;
            cols = ceil(sqrt(NPLOTS));
            rows = ceil(NPLOTS/cols);
            
            figure('visible','off')
            
            subplot(rows,cols,1),            
            ft_singleplotTFR(cfg,  TFRall);
            Ntr = size(TFRall.powspctrm,1);    
            title(['ALL', ', N = ' num2str(Ntr)])
            
            subplot(rows,cols,2),  
            cfg              = [];
            cfg.zlim         = [0.5 2]
            cfg.ylim         = [4 70];   
            cfg.parameter = 'stat';
            cfg.zlim = [-3 3];
            ft_singleplotTFR(cfg,  stat_within);
            title(['STAT ALL'])
            
            subplot(rows,cols,3),  
            cfg              = [];
            cfg.xlim         = [-1 2];
            cfg.ylim         = [4 70];
            cfg.parameter = 'mask';
            ft_singleplotTFR(cfg,  stat_within);
            title(['MASK ALL'])
            
            for sp = 1:NPLOTS-3
                subplot(rows,cols,sp+3),
                cfg              = [];
                    cfg.zlim         = [0.5 2]
                    cfg.xlim         = [-1 2];
                    cfg.ylim         = [4 70];
                eval(['ft_singleplotTFR(cfg,  TFR' num2str(sp) ')']);
                eval(['Ntr = size(TFR' num2str(sp) '.powspctrm,1);'])
                title([char(combinationsnamess(sp)), ', N = ' num2str(Ntr)])
            end
            set(gcf, 'position', get(0, 'screensize'))
            figure_name = ['elem  cluster' num2str(cl) ' subj' num2str(id) ' ch' num2str(ch)  ' session' num2str(session)   ];
            saveas(gcf, [ folderfiles_save_PICS  '\' figure_name '.pnggit'])
            close all
            
            
            %% stat
            
            
        end
        
    end
    
end







