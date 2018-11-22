function angle_thresholds_final=gatherAlldata_across_observers(subj,cond_name)

% function angle_thresholds_final=gatherAlldata_across_observers(subj,cond_name)
%
% gather & trim all ObliqueSlant_QUEST behavioral data
% into one *.mat file for futher analyses
%
% [input]
% subj       : subject's name, cell structure, e.g. {'HB','MP','DD'}
% cond_name  : condition name, 'main' or 'XY'
%
% [output]
% no output variable
%
% [example]
% >> gatherAlldata_across_observers('HB','main');
%
%
% Created    : "2011-06-20 14:13:56 banh"
% Last Update: "2011-06-20 16:29:31 banh"

% check input variales
fprintf('checking input variables...');
if nargin<2, help gatherAlldata_across_observers; return; end
if ~iscell(subj), subj={subj}; end
for ss=1:1:length(subj)
  if ~exist(fullfile(pwd,subj{ss}),'dir')
    error('directory: %s does not exist.',fullfile(pwd,subj{ss}));
  end
end
disp('done.');

% average over participants
fprintf('gathering all the data over participants...\n');
designsAll=zeros(8,4,length(subj));
dparams_gatheredAll=cell(length(subj),1);
sparams_gatheredAll=cell(length(subj),1);
subjects=cell(length(subj),1);
for ss=1:1:length(subj)

  % get file names
  fprintf('searching result file for: %s...',subj{ss});
  if strcmp(cond_name,'main'), cond_name='main'; end
  if strcmp(cond_name,'XY'), cond_name='XY'; end
  resultfiles=wildcardsearch(fullfile(pwd,subj{ss}),...
                             [subj{ss},'_QUEST_ALL_',cond_name,'_results.mat']);
  disp('done.')

  % loading data
  load(resultfiles{1});
  designsAll(:,:,ss)=designs;
  dparams_gatheredAll{ss}=dparams_gathered;
  sparams_gatheredAll{ss}=sparams_gathered;
  subjects{ss}=subjID;
end
disp('done.');

designsAll(:,3,:)=1/designsAll(:,3,:);

% calculate mean & sem
designsMEAN=zeros(8,4); %#ok
designsMEAN=mean(designsAll,3);
designsMEAN(:,4)=std(squeeze(designsAll(:,3,:)),[],2)./sqrt(length(subj)); %#ok

% calculate between sensitivity
tmp_thresholds=zeros(7,length(subj));
for ss=1:1:length(subj)
  for ii=1:1:7 % between a pair of slants: 8 positions ---> 7 pairs
    tmp_thresholds(ii,ss)=(designsAll(ii,3,ss)+designsAll(ii+1,3,ss))/2;
  end
end
angle_thresholds_final(:,1)=mean(tmp_thresholds,2); % mean
angle_thresholds_final(:,2)=std(tmp_thresholds,[],2)./sqrt(length(subj)); % sem

% plotting the final results
figure; hold on;
%bar(1:7,angle_thresholds_final(:,1));
%errorbar(1:7,angle_thresholds_final(:,1),angle_thresholds_final(:,2),'.');
errorbar(1:7,angle_thresholds_final(:,1),angle_thresholds_final(:,2),'b-','LineWidth',2);
plot([0,8],[1/15,1/15],'k:');
set(gca,'XLim',[0,8]);
set(gca,'XTick',1:7);
set(gca,'XTickLabel',{'-45','-30','-15','0','15','30','45'});
%set(gca,'XTickLabel',1:7);
set(gca,'YLim',[0,0.25]);
title(sprintf('angle descrimination performance against the positions (n=%d)',length(subj)));
xlabel('position of a pair of 2 slants (deg)');
ylabel('sensitivity (1/threshold)');

% save the figure
fprintf('saving the results...');
save_dir=fullfile(pwd,'ALL');
save_fname=[save_dir,filesep(),'ALL_QUEST_',cond_name,'_results'];
saveas(gcf,[save_fname,'.fig'],'fig');
saveas(gcf,[save_fname,'.png'],'png');
disp('done.');

% save the results
fprintf('saving the results...');
if strcmp(cond_name,'main*'), cond_name='main'; end
if strcmp(cond_name,'XY*'), cond_name='XY'; end
save_dir=fullfile(pwd,'ALL');
if ~exist(save_dir,'dir'), mkdir(save_dir); end
save_fname=[save_dir,filesep(),'ALL_QUEST_',cond_name,'_results.mat'];
save(save_fname,'angle_thresholds_final','designsAll','designsMEAN',...
     'dparams_gatheredAll','sparams_gatheredAll','subjects');
disp('done.');

return
