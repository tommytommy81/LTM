% this runs under for = elem
% called by CLUSTER_stat_TIMEFREQpseudoNORM_090620.m

for cond = 1:length(conditions)
    
    cond1 = conditions(cond);
    
    if exist([folderfiles_save_RESP,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond1) '.mat'])
        
        load([folderfiles_save_RESP,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond1) '.mat'],'data')
        fs = 1/(data.time{1,1}(2)-data.time{1,1}(1));
        for tr = 1:length(data.trial)
            eval(['tl_Group' num2str(cond1) '_RESP.trial(tr_end' num2str(cond1) ',1,:) = data.trial{1,tr}(ch,:)']);
            eval(['tr_end' num2str(cond1) ' = 1 + tr_end' num2str(cond1) ]);
        end
        eval(['tl_Group' num2str(cond1) '_RESP.time                        = data.time{1,1}(1,:);']);
        eval(['tl_Group' num2str(cond1) '_RESP.history.label{elem,1}       = [char(subj_ID(id)) '  ' char(data.label(ch))];']);
        eval(['tl_Group' num2str(cond1) '_RESP.history.trials( elem,1)     = tr']);
        eval(['tl_Group' num2str(cond1) '_RESP.history.anatomy{elem,1}     = data.anatomy{ch,:}']);
        eval(['tl_Group' num2str(cond1) '_RESP.label{1} = [''cluster'' num2str(cl)];']);
        eval(['tl_Group' num2str(cond1) '_RESP.fsample   = fs;']);
        eval(['tl_Group' num2str(cond1) '_RESP.dimord    = ''rpt_chan_time'';']);        
     
    end
    
end