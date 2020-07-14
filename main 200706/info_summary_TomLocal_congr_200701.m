% info_summary_190520
% % % % % % % % % data_builder_9_cond_200701
% % % % % % % % % CLUSTER_stat_TIMEFREQpseudoNORM_200701

HDD_krasniy         = 'F:\'
mainfolder          = 'C:\Users\Tom\Google Drive\__PC_HSE\code\_GitHub\'
mainfolder_data     = [HDD_krasniy 'Tommaso\_DATA\ZURICH\Memory Task Sep\Files\']
folder_with_matfile = [HDD_krasniy 'Tommaso\_DATA\ZURICH\Memory Task Sep\Files\clusters200526\']
ft_folder           = 'C:\Users\Tom\Google Drive\__PC_HSE\Matlab Toolbox\FIELDTRIP\fieldtrip-20190202\'
folder_triggers     = [mainfolder_data 'Structs\'];
fileEprime          = [mainfolder_data 'ALL info EPRIME.xlsx'];
folder_scritps = [mainfolder 'Sep\main 200706\']
cd(folder_scritps)
addpath(genpath([folder_scritps ]))

add_ft = 1; % to add ft to path

% subject ID for all the folders and excel sheets
subj_ID             = {'WC',    'MA',    'PL',    'SP',    'SA',    'PN',    'NP'     }


% excel file for anatomical info
subj_excel_regions2 = {'B3:D50','B3:D66','B3:D34','B3:D44','B3:D66','B3:D42','B3:D26' } % rec labels, MNI xyz, anatom label
subj_excel_anatomy  = {'G3:G50','G3:G66','G3:G34','G3:G44','G3:G66','G3:G42','E3:E26' } % rec labels, MNI xyz, anatom label

regionsfile         = [mainfolder 'Sep Word and Excel Files\Word and Excel Files\regions2.xlsx']

% excel files for channels selection after preprocessing
good_chans_Enc_file = [mainfolder 'Sep Word and Excel Files\Word and Excel Files\Channels_Enc.xls'] % TRUE FALSE
good_chans_Ret_file = [mainfolder 'Sep Word and Excel Files\Word and Excel Files\Channels_Ret.xls']

%  % folder repository of data extracted by SEP on 20.01.20 WHERE thee DATA
% EXTRACTED manually from BS is stored - single good trials but all channels

datafile_sep_Enc_trials = [mainfolder_data  '\Triggers for cong\ENC\']
datafile_sep_Ret_trials = [mainfolder_data '\Triggers for cong\RET\']

% middle step folder
datafile_sep_Enc  = [mainfolder_data '\Triggers for cong\ENC\Trials attached together\']
datafile_sep_Ret = [mainfolder_data '\Triggers for cong\RET\Trials attached together\']
datafile_sep_Ret_RESP  = [mainfolder_data '\Triggers for cong\RET\Trials attached together RESP\']

% folder repository of data with good channels, and coordinates
folderfiles_Enc_save  = [mainfolder_data '\Triggers for cong\ENC\Trials attached together good channels\']
folderfiles_Ret_save  = [mainfolder_data '\Triggers for cong\RET\Trials attached together good channels\']
folderfiles_Ret_save_RESP  = [mainfolder_data '\Triggers for cong\RET\Trials attached together good channels RESP\']

 
%% filedtrip toolbox
% 
if add_ft
%     ft_folder = '\\172.16.118.134\TFedele\Tommaso\Matlab Toolboxes\fieldtrip-20190203\'
    cd(ft_folder)
    ft_defaults
    cd(folder_scritps)
end
