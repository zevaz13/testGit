function [nEEG] = icaeeg(EEG, reref)

% icaeeg removes marked trials, performs ICA decomposition labels bad
% components for rejection
% input EEG (struct) 
% saves a file with components that ends in _ICA. same start 

% get marked trials for rejection

markedTrials = find(EEG.reject.rejmanual);

% remove the marked trials
EEG = pop_rejepoch( EEG, markedTrials ,0);

% 10) adjust Rank for ICA, check this and be really careful!!!! this really
% changes the results

switch reref
    case 'AVG'
        icaChann = [2:32 35:38]; 
    case 'NOEOGAVG'
        icaChann =  2:32;       
end
% channels to use for ICA, IF reref = NOEOGAVG
%icaChann = [2:32]; % changes depending on the referecence of the set

% this information stays in the data structure under icachansind
% 11) Run ICA!!!!, remember to use pca (numchans - interpolated channels)
EEG = pop_runica(EEG,'icatype','runica', 'extended',1, 'interrupt', 'on', 'chanind', icaChann,'pca',length(icaChann)-length(EEG.eegremoved));

% save ICA dataset
fileName = sprintf('%s_ICA.set',EEG.setname);
EEG = pop_editset(EEG,'setname', fileName);
EEG = pop_saveset( EEG, 'filename',fileName,'filepath',EEG.filepath);


EEG = pop_iclabel(EEG, 'default');
EEG = pop_icflag(EEG, [NaN NaN;0.6 1;0.6 1;0.6 1;0.6 1;0.4 1;0.4 1]);
find(EEG.reject.gcompreject)
% next steps to take when starting decomposition of the signal are 
% 12) reject bad ICA components
% 13) Estimate single equivalent dipoles
% 14) Search symmetrically contstrained dipoles (PLUGIN NEEDED)
% 15) use STUDY for signal decomposition
nEEG = EEG;
end

