
%% prepare the data

cfg = [];
cfg.latency = interval_to_Test;
TFR_activation = ft_selectdata(cfg, TFRall);
TFR_activation.time([1 end])

cfg = [];
cfg.latency = -fliplr(interval_to_Test+.5);
TFR_baseline = ft_selectdata(cfg, TFRall);
TFR_baseline.time([1 end])
 
TFR_baseline.time = TFR_activation.time;
 
%% test
cfg = [];
cfg.latency          = interval_to_Test;
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_actvsblT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 0;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 5;
% prepare_neighbours determines what sensors may form clusters
% conditions must
        for chss = 1
            neighbours(chss).label = char(TFR1.label);
            neighbours(chss).neighblabel = {''};
        end
        cfg.neighbours    = neighbours;  % the neighbours specify for each sensor with

ntrials = size(TFR_activation.powspctrm,1);
design  = zeros(2,2*ntrials);
design(1,1:ntrials) = 1;
design(1,ntrials+1:2*ntrials) = 2;
design(2,1:ntrials) = [1:ntrials];
design(2,ntrials+1:2*ntrials) = [1:ntrials];

cfg.design   = design;
cfg.ivar     = 1;
cfg.uvar     = 2;

[stat_within] = ft_freqstatistics(cfg, TFR_activation, TFR_baseline);

% figurename = 'withintrials'
% TF_stat_plot
%%