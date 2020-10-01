% plot conditions separately 
            figure%('visible','off')
            fig_title_cond = []

            cfg              = [];
            cfg.zlim         = [0.5 2]
            cfg.xlim         = [-1 2];
            cfg.ylim         = [4 70];
            
            NPLOTS = size(combinations,1)+3;
            cols = ceil(sqrt(NPLOTS));
            rows = ceil(NPLOTS/cols);
            
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
            
            
            for subpl = 1:NPLOTS-3
                subplot(rows,cols,subpl+3)
                cfg = []; 
                cfg              = [];
                    cfg.zlim         = [0.5 2]
                    cfg.xlim         = [-1 2];
                    cfg.ylim         = [4 70];
                cfg.parameter = 'powspctrm';
                cfg.title = combinationsnamess{subpl};
                fig_title_cond = [ fig_title_cond '+'  combinationsnamess{subpl}];
                eval(['ft_singleplotTFR(cfg,  TFR' num2str(subpl) ');'])
                                eval(['Ntr = size(TFR' num2str(subpl) '.powspctrm,1);'])
                title([char(combinationsnamess(subpl)), ', N = ' num2str(Ntr)])

            end
            set(gcf, 'position', get(0, 'screensize'))
            figurename = ['session' num2str(session) ' cluster' num2str(cl) ' condition ' fig_title_cond];
%             saveas(gcf, [figure_name '.bmp'])   