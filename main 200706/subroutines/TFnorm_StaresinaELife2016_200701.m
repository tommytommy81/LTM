%

% called by CLUSTER_stat_TIMEFREQpseudoNORM_090620.m

for cond = 1:size(combinations,1)
    

    
    %% computation for sessions 1 and 2
cfg = [];
cfg.output     = 'pow';
cfg.method     = 'mtmconvol';
cfg.keeptrials = 'yes'
% Staresina ELife 2016 low freq
cfg.taper      =  'hanning';
cfg.foi        = 2:29; %logspace(log10(1), log10(80),30);1:1:80 %
cfg.toi        = -2:0.01:3;
cfg.t_ftimwin  = 5./cfg.foi;
cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
eval(['TFR' num2str(cond) 'l = ft_freqanalysis(cfg, tl_Comb' num2str(cond) ');']);
 

% Staresina ELife 2016 gamma
cfg.taper      = 'dpss';
cfg.foi        = 30:5:100; %logspace(log10(1), log10(80),30);1:1:80 %
cfg.toi        = -2:0.01:3;
cfg.t_ftimwin  = .4*ones(length(cfg.foi),1);
cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
eval(['TFR' num2str(cond) 'h = ft_freqanalysis(cfg, tl_Comb' num2str(cond) ');']);

% append all together in one TF map
cfg =[]
cfg.parameter  = 'powspctrm'
eval(['TFR' num2str(cond) '= ft_appendfreq(cfg, TFR' num2str(cond) 'l, TFR' num2str(cond) 'h);']);



if session < 3
% normalize to baseline interval at single trial level
eval([' TFR' num2str(cond) '  = TFR_baseline_200701(TFR' num2str(cond) ', TFR' num2str(cond) ', baseline);']);

else
    
    
    % compute for session 3: need to distinguish between baseline (above)
    % and response locked trial (here below)
    
cfg = [];
cfg.output     = 'pow';
cfg.method     = 'mtmconvol';
cfg.keeptrials = 'yes'
% Staresina ELife 2016 low freq
cfg.taper      =  'hanning';
cfg.foi        = 2:29; %logspace(log10(1), log10(80),30);1:1:80 %
cfg.toi        = -2.5:0.01:.5;
cfg.t_ftimwin  = 5./cfg.foi;
cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
eval(['TFR' num2str(cond) 'l_RESP = ft_freqanalysis(cfg, tl_Comb' num2str(cond) '_RESP);']);
 

% Staresina ELife 2016 gamma
cfg.taper      = 'dpss';
cfg.foi        = 30:5:100; %logspace(log10(1), log10(80),30);1:1:80 %
cfg.toi        = -2.5:0.01:.5;
cfg.t_ftimwin  = .4*ones(length(cfg.foi),1);
cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
eval(['TFR' num2str(cond) 'h_RESP = ft_freqanalysis(cfg, tl_Comb' num2str(cond) '_RESP);']);

% append all together in one TF map

cfg =[]
cfg.parameter  = 'powspctrm'
eval(['TFR' num2str(cond) '_RESP= ft_appendfreq(cfg, TFR' num2str(cond) 'l_RESP, TFR' num2str(cond) 'h_RESP);']);

    % normalize
eval(['TFR' num2str(cond) '_RESP  = TFR_baseline_200701(TFR' num2str(cond) '_RESP, TFR' num2str(cond) ', baseline);']);
    
end

end