function gatherAlldata(subj,cond_name)

% function gatherAlldata(subj,cond_name)
%
% gather & trim all ObliqueSlant_QUEST behavioral data
% into one *.mat file for futher analyses
%
% [input]
% subj       : subject's name, e.g. 'HB'
% cond_name  : condition name, 'main' or 'XY'
%
% [output]
% no output variable
%
% [example]
% >> gatherAlldata('HB');
%
%
% Created    : "2011-06-14 09:21:37 banh"
% Last Update: "2011-06-14 09:57:56 banh"

% check input variales
fprintf('checking input variables...');
if nargin<1, help gatherAlldata; return; end
if ~exist(fullfile(pwd,'..','Presentation','subjects',subj,'results'),'dir')
  error('directory: %s does not exist.',fulfile(pwd,'..','Presentation','subjects',subj,'results'));
end
disp('done.');

% get file names
fprintf('searching result files in the target directory...');
if strcmp(cond_name,'main'), cond_name='main*'; end
if strcmp(cond_name,'XY'), cond_name='XY*'; end
resultfiles=wildcardsearch(fullfile(pwd,'..','Presentation','subjects',subj,'results'),...
                           [subj,'_QUEST_',cond_name,'_results_run_*.mat']);
disp('done.')

% average over repeated runs
fprintf('gathering all the data over repeated runs...');
designs=[];
dparams_gathered=cell(length(resultfiles),1);
sparams_gathered=cell(length(resultfiles),1);
for ff=1:1:length(resultfiles)
  load(resultfiles{ff});
  designs=[designs;[design,angle_thresholds',angle_SDs']]; %#ok;
  dparams_gathered{ff}=dparam;
  sparams_gathered{ff}=sparam;
end
disp('done.');

% sorting the results
[dummy,idx]=sort(designs,1,'ascend');
designs=designs(idx(:,1),:); %#ok

% save the results
fprintf('saving the results...');
if strcmp(cond_name,'main*'), cond_name='main'; end
if strcmp(cond_name,'XY*'), cond_name='XY'; end
save_dir=fullfile(pwd,'.',subj);
if ~exist(save_dir,'dir'), mkdir(save_dir); end
save_fname=[save_dir,filesep(),subj,'_QUEST_ALL_',cond_name,'_results.mat'];
save(save_fname,'designs','dparams_gathered','sparams_gathered','subjID');
disp('done.');

return
