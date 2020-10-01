%

% called by CLUSTER_stat_TIMEFREQpseudoNORM.m
% TF parameters according to Staresina Elife 2016
% output: TFR<cond>

for cond = 1:length(conditions)
    
    
    
    %% computation for sessions 1 and 2
    cfg = [];
    cfg.output     = 'pow';
    cfg.method     = 'mtmconvol';
    cfg.keeptrials = 'yes'
    % Staresina ELife 2016 low freq
    cfg.taper      =  'hanning';
    cfg.foi        = 2:29; %logspace(log10(1), log10(70),30);1:1:70 %
    cfg.toi        = -5:0.01:3;
    cfg.t_ftimwin  = 5./cfg.foi;
    cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
    eval(['TFR' num2str(cond) 'l = ft_freqanalysis(cfg, tl_Group' num2str(cond) ');']);
    
    
    % Staresina ELife 2016 gamma
    cfg.taper      = 'dpss';
    cfg.foi        = 30:5:70; %logspace(log10(1), log10(70),30);1:1:70 %
    cfg.toi        = -5:0.01:3;
    cfg.t_ftimwin  = .4*ones(length(cfg.foi),1);
    cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
    eval(['TFR' num2str(cond) 'h = ft_freqanalysis(cfg, tl_Group' num2str(cond) ');']);
    
    % append all together in one TF map
    cfg =[]
    cfg.parameter  = 'powspctrm'
    eval(['TFR' num2str(cond) '= ft_appendfreq(cfg, TFR' num2str(cond) 'l, TFR' num2str(cond) 'h);']);
    
    % normalize to baseline interval at single trial level
    eval([' TFR' num2str(cond) '  = TFR_baseline(TFR' num2str(cond) ', TFR' num2str(cond) ', baseline);']);
    
    if cond>1
        eval([' TFR' num2str(cond) '.freq = TFR1.freq; '])
    end
    
end

clear TFR*h TFR*l