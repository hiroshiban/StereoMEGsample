function plot_results(subj,cond_name)

% function plot_results(subj,cond_name)
%
% plots one participant's data
%
% [input]
% subj       : subject's name, cell structure, e.g. {'HB','MP','DD'}
% cond_name  : condition name, 'main' or 'XY'
%
% [output]
% no output variable
%
% [example]
% >> plot_results('HB','main');
%
%
% Created    : "2011-06-20 14:13:56 banh"
% Last Update: "2011-06-20 15:42:07 banh"

% check input variales
fprintf('checking input variables...');
if nargin<2, help plot_results; return; end
if ~iscell(subj), subj={subj}; end
for ss=1:1:length(subj)
  if ~exist(fullfile(pwd,subj{ss}),'dir')
    error('directory: %s does not exist.',fullfile(pwd,subj{ss}));
  end
end
disp('done.');

% plotting data participant by participant
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

  % plotting

  figure('Name',subj{ss});

  % raw data
  subplot(1,2,1); hold on;
  bar(1:8,designs(:,3),'FaceColor',[0,0.2,0.5],'EdgeColor',[0,0,0]); %#ok
  plot([0,9],[15,15],'k:');
  set(gca,'XLim',[0,9]);
  set(gca,'XTick',1:8);
  set(gca,'XTickLabel',{'-52.5','-37.5','-22.5','-7.5','7.5','22.5','37.5','52.5'});
  title(sprintf('%s''s descrimination performance',subj{ss}));
  xlabel('slant position [deg]');
  ylabel('threshold (angle)');

  % sensitivity between 2 positions
  sensitivity=zeros(7,1);
  for ii=1:1:7, sensitivity(ii)=1./((designs(ii,3)+designs(ii+1,3))/2); end
  subplot(1,2,2); hold on;
  bar(1:7,sensitivity,'FaceColor',[0,0.5,0],'EdgeColor',[0,0,0]);
  plot([0,8],[1/15,1/15],'k:');
  set(gca,'XLim',[0,8]);
  set(gca,'XTick',1:7);
  set(gca,'XTickLabel',{'-45','-30','-15','0','15','30','45'});
  title(sprintf('%s''s descrimination sensitivity',subj{ss}));
  xlabel('position of a pair of 2 slants');
  ylabel('sensitivity (1/threshold)');

  % save the results
  fprintf('saving the results...');
  save_dir=fullfile(pwd,subj{ss});
  save_fname=[save_dir,filesep(),subj{ss},'_QUEST_',cond_name,'_results'];
  saveas(gcf,[save_fname,'.fig'],'fig');
  saveas(gcf,[save_fname,'.png'],'png');
  disp('done.');

end
disp('done.');

return
