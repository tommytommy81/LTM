function [TFR1_norm] = TFR_baseline_200701(TFR1, TFR2, baseline)

% figure
% compute TF baseline
t = TFR1.time;

[~,samples_base1] = (min(abs(baseline(1)-TFR1.time)));
[~,samples_base2] = (min(abs(baseline(2)-TFR1.time)));
samples_base      = samples_base1:samples_base2;

% normalization to TFR1 baseline
TFbase1 = (squeeze(nanmean(nanmean(TFR2.powspctrm(:,:,:,samples_base)),4)));
 
TFR1_norm = TFR1;
 
for tr = 1:size(TFR1_norm.powspctrm,1)
    TFR1_norm.powspctrm(tr,1,:,:) = squeeze(TFR1.powspctrm(tr,:,:,:))./repmat(TFbase1,1,length(TFR1.time));
end
 


% TFR_baseline_trials_check