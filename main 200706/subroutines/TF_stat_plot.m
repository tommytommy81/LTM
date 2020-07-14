% plot TF stat for three conditions
% called by CLUSTER_stat_TIMEFREQpseudoNORM_090620.m

%     close all


figure('Name',figurename)
subplot(3,2,1),
cfg = []; cfg.parameter = 'prob';
ft_singleplotTFR(cfg,  stat)

signif = find (stat.mask  >0);
if length(signif)
    hold on
    subplot(3,2,2),
    cfg = []; cfg.parameter = 'posclusterslabelmat';
    ft_singleplotTFR(cfg,  stat)
    subplot(3,2,4),
    cfg = []; cfg.parameter = 'negclusterslabelmat';
    ft_singleplotTFR(cfg,  stat)
    
end
subplot(3,2,3),cfg = []; cfg.parameter = 'mask';             ft_singleplotTFR(cfg,  stat)

subplot(3,2,5), cfg = []; cfg.parameter = 'stat';
ft_singleplotTFR(cfg,  stat)




