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
subplot(3,2,3),cfg = []; cfg.parameter = 'mask'; ft_singleplotTFR(cfg,  stat)

subplot(3,2,5), cfg = []; cfg.parameter = 'stat';
cfg.zlim = [-3 3]
ft_singleplotTFR(cfg,  stat)



%% 
 
figure_name = ['session' num2str(session) ' cl' num2str(cl) ' elem' num2str(elem) ' subj' num2str(id) ' ch' num2str(ch) ' ' char(subj_ID(id)) '  ' char(data.label(ch)) '.bmp']
figure('visible','off')

cfg = []

subplot(4,2,1)

cfg.zlim = [-1 1]*5;
cfg.parameter = 'stat';
ft_singleplotTFR(cfg,  stat)
title(['response vs baseline , N = ' num2str(size(TFR.powspctrm,1))])

subplot(4,2,2)
cfg = []
stat.stat_masked = stat.stat.*(stat.mask+.5);
cfg.parameter = 'stat_masked';
ft_singleplotTFR(cfg,  stat)


cfg  = [];
cfg.zlim         = [0.5 1.5]
subplot(4,2,3), ft_singleplotTFR(cfg,  TFR1); title(['CA , N = ' num2str(size(TFR1.powspctrm,1))])
subplot(4,2,5), ft_singleplotTFR(cfg,  TFR2); title(['IA , N = ' num2str(size(TFR2.powspctrm,1))])
subplot(4,2,7), ft_singleplotTFR(cfg,  TFR3); title(['Miss, N = ' num2str(size(TFR3.powspctrm,1))])


cfg = []; cfg.zlim = [-1 1]*3;
stat12.stat_masked = stat12.stat.*(stat12.mask+.5);
stat13.stat_masked = stat13.stat.*(stat13.mask+.5);
stat23.stat_masked = stat23.stat.*(stat23.mask+.5);
cfg.parameter = 'stat_masked';
subplot(4,2,4), ft_singleplotTFR(cfg,  stat12); title('Corr-Incorr')
subplot(4,2,6), ft_singleplotTFR(cfg,  stat13); title('Corr-Miss')
subplot(4,2,8), ft_singleplotTFR(cfg,  stat23); title('Incorr-Miss')

set(gcf, 'position', get(0, 'screensize'))
mkdir([folderfiles_save '\PICS'])
saveas(gcf, [folderfiles_save '\PICS\' figure_name])
