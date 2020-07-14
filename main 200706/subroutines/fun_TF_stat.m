function stat12 = fun_TF_stat(TFR1, TFR2, test_latency)
% compute TF stat for three conditions
% called by CLUSTER_stat_TIMEFREQpseudoNORM_090620.m 



cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
        cfg.statistic = 'ft_statfun_indepsamplesT'; % use the independent samples T-statistic as a measure to
        % evaluate the effect at the sample level
        cfg.correctm = 'cluster';
        cfg.clusteralpha = 0.05;         % alpha level of the sample-specific test statistic that
        % will be used for thresholding
        cfg.clusterstatistic = 'maxsum'; % test statistic that will be evaluated under the
        % permutation distribution.
        cfg.minnbchan = 0;               % minimum number of neighborhood channels that is
        % required for a selected sample to be included
        % in the clustering algorithm (default=0).
        % cfg.neighbours = neighbours;   % see below
        cfg.tail = 0;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
        cfg.clustertail = 0;
        cfg.alpha = 0.05;               % alpha level of the permutation test
        cfg.numrandomization = 500  ;      % number of draws from the permutation distribution
        cfg.ivar  = 1;                   % number or list with indices indicating the independent variable(s)
        
        cfg.channel       = TFR1.label;     % cell-array with selected channel labels
        cfg.latency       = test_latency;       % time interval over which the experimental
        % conditions must
        for ch = 1
            neighbours(ch).label = char(TFR1.label);
            neighbours(ch).neighblabel = {''};
        end
        cfg.neighbours    = neighbours;  % the neighbours specify for each sensor with
        
        % 1 vs 2
        design = zeros(1,size(TFR1.powspctrm,1) + size(TFR2.powspctrm,1)  );
        design(1,1:size(TFR1.powspctrm,1)) = 1;
        design(1,(size(TFR1.powspctrm,1)+1):(size(TFR1.powspctrm,1) + size(TFR2.powspctrm,1)))= 2;
        cfg.design = design;             % design matrix
        [stat12] = ft_freqstatistics(cfg, TFR1, TFR2);
        
         