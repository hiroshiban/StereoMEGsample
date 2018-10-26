function StereoMEGsample(subjID, acq, displayfile, stimulusfile, gamma_table, overwrite_flg, force_proceed_flag)

% function StereoMEGsample(subjID, acq, :displayfile, :stimlusfile, :gamma_table, :overwrite_flg, :force_proceed_flag)
% (: is optional)
%
% - Displays 3D slant consisted of Random-Dot-Stereogram (RDS) with horizontal
%   binocular disparities.
% - Used for psychophysical measurementss of perceptual oblique effects in 3D scene.
% - Participant's task is to discriminate which direction the circular RDS objects
%   is slanted (top-near: key1 or top-far: key2), when the central fixation is red.
% - The task trial (with a red central fixation) occurs every 3-5 trials.
% - During the trials in which the central fixation is white, participants have to
%   refrain from blinking and concentrate on seeing the slanted surfaces.
% - In the task trials in which the central fixation marker is red, participants
%   can blink as they like.
% - This script shoud be run with MATLAB Psychtoolbox version 3 or above.
% - Stimulus presentation timing are controled by using GetSecs() function
%   (this is internally equivalent to Windows multimedia timer), not by waiting
%   vertical blanking of the display.
% - Stimulus (trial) onsets and the MEG measurements were synchronized and aligned
%   offline based on the photo-trigger signals recorded at the upper-right corner
%   of the display in the MEG room.
%
%
% Created    : "2018-10-04 15:41:33 ban"
% Last Update: "2018-10-15 12:46:58 ban"
%
%
% [input variables]
% sujID         : ID of subject, string, such as 'HB', 's01', etc.
%                 !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
%                 !!! if 'debug' (case insensitive) is included          !!!
%                 !!! in subjID string, this program runs as DEBUG mode; !!!
%                 !!! stimulus images are saved as *.png format at       !!!
%                 !!! ~/CurvatureShading/Presentation/images             !!!
%                 !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
% acq           : acquisition number (design file number),
%                 an integer, such as 1, 2, 3, ...
% displayfile   : (optional) display condition file,
%                 *.m file, such as 'oblique3d_display_fmri.m'
%                 the file should be located in ./subjects/(subj)/
% stimulusfile  : (optional) stimulus condition file,
%                 *.m file, such as 'oblique3d_stimulus_exp1.m'
%                 the file should be located in ./subjects/(subj)/
% gamma_table   : (optional) table(s) of gamma-corrected video input values (Color LookupTable).
%                 256(8-bits) x 3(RGB) x 1(or 2,3,... when using multiple displays) matrix
%                 or a *.mat file specified with a relative path format. e.g. '/gamma_table/gamma1.mat'
%                 The *.mat should include a variable named "gamma_table" consists of a 256x3xN matrix.
%                 if you use multiple (more than 1) displays and set a 256x3x1 gamma-table, the same
%                 table will be applied to all displays. if the number of displays and gamma tables
%                 are different (e.g. you have 3 displays and 256x3x!2! gamma-tables), the last
%                 gamma_table will be applied to the second and third displays.
%                 if empty, normalized gamma table (repmat(linspace(0.0,1.0,256),3,1)) will be applied.
% overwrite_flg : (optional) whether overwriting pre-existing result file. if 1, the previous results
%                 file with the same acquisition number will be overwritten by the previous one.
%                 if 0, the existing file will be backed-up by adding a prefix '_old' at the tail
%                 of the file. 0 by default.
% force_proceed_flag : (optional) whether proceeding stimulus presentatin without waiting for
%                 the experimenter response (e.g. presesing the ENTER key) or a trigger.
%                 if 1, the stimulus presentation will be automatically carried on.
%
%
% [output variables]
% no output matlab variable.
%
%
% [output files]
% 1. behavioral result
%    stored ./subjects/(subjID)/results/(today)
%    as ./subjects/(subjID)/results/(today)/(subjID)_StereoMEGsample_results_run_(run_num).mat
%
%
% [example]
% >> StereoMEGsample('s01',1,'oblique3d_display.m','oblique3d_stimulus_exp1.m')
%
%
% [About displayfile]
% The contents of the displayfile is as below.
% (The file includs 6 lines of headers and following display parameters)
%
% (an example of the displayfile)
%
% % ************************************************************
% % This_is_the_display_file_for_OBLIQUE3D_experiment.
% % Please_change_the_parameters_below.
% % SlantfMRI.m
% %
% % Created    : "2018-09-26 18:57:59 ban"
% % Last Update: "2018-10-10 11:28:08 ban"
% % ************************************************************
%
% % "dparam" means "display-setting parameters"
%
% %%% display mode
% % one of "mono", "dual", "dualparallel", "dualcross", "cross", "parallel", "redgreen", "greenred",
% % "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn"
% dparam.ExpMode='shutter';
%
% dparam.scrID=1; % screen ID, generally 0 for a single display setup, 1 for dual display setup
%
% %%% a method to start stimulus presentation
% % 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (CiNet),
% % 3:waiting for a MR trigger pulse (BUIC) -- checking onset of pin #11 of the parallel port,
% % or 4:custom key trigger (wait for a key input that you specify as tgt_key).
% dparam.start_method=4;
%
% %%% a pseudo trigger key from the MR scanner when it starts, only valid when dparam.start_method=4;
% dparam.custom_trigger=KbName(84); % 't' is a default trigger code from MR scanner at CiNet
%
% dparam.Key1=37; % 37 is left-arrow on default Windows
% dparam.Key2=39; % 39 is right-arrow on default Windows
%
% %%% screen settings
%
% %%% whether displaying the stimuli in full-screen mode or as is (the precise resolution), true or false (true)
% dparam.fullscr=false;
%
% %%% the resolution of the screen height, integer (1024)
% dparam.ScrHeight=1200; %1024; %1200;
%
% %% the resolution of the screen width, integer (1280)
% dparam.ScrWidth=1600; %1280; %1920;
%
% % shift the screen center position along y-axis (to prevent the occlusion of the stimuli due to the coil)
% dparam.yshift=30;
%
%
% [About stimulusfile]
% The contents of the stimulusfile is as below.
% (The file includs 6 lines of headers and following stimulus parameters)
%
% (an example of the stimulusfile)
%
% % ************************************************************
% % This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% % Please_change_the_parameters_below.
% % StereoMEGsample.m
% %
% % Created    : "2018-09-26 18:57:59 ban"
% % Last Update: "2018-10-10 11:28:08 ban"
% % ************************************************************
%
% % "sparam" means "stimulus generation parameters"
%
% %%% stimulus presentation mode
% sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
% sparam.give_feedback=false;    % true or false. if true, feedback (whether the response is correct or not) is given
% sparam.task_interval=3:5;      % frequency the depth discrimination task, the task occurs every sparam.task_interval trials
%
% %%% target image generation
% sparam.fieldSize=[12,12]; % target stimulus size in deg
%
% % [Important notes on stimulus masks]
% %
% % * the parameters required to define stimulus masks
% %
% % sparam.mask_theta_deg  : a set of slopes of the slants to be used for masking. the outer regions of the intersections of all these slants' projections on the XY-axes are masked.
% %                          for instance, if sparam.mask_orient_deg=[-22.5,-45], the -22.5 and -22.5 deg slants are first generated, their non-zero components are projected on the XY plane,
% %                          and then a stimulus mask is generated in two ways.
% %                          1. 'xy' mask: the intersection of the two projections are set to 1, while the oter regions are set to 1. The mask is used to restrict the spatial extensions
% %                             of the target slants within the common spatial extent.
% %                          2. 'z'  mask: the disparity range of the slants are restricted so that the maximum disparity values are the average of all disparities contained in all set of slants.
% %                             using this mask, we can restrict the disparity range across the different angles of the slants.
% % sparam.mask_orient_deg : tilt angles of a set of slopes of the slants. if multiple values are set, masks are generated separately for each element of sparam.mask_orient_deg.
% %                          for instance, if sparam.mask_theta_deg=[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; and sparam.mask_orient_deg=[45, 90];, two masks are generated as below.
% %                          1. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
% %                          2. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
% %
% %
% % * how to set masks for the main slant stimuli
% %
% % to set the masks to the main slant stimuli, please use sparam.mask_type and sparam.mask_orient_id.
% % for details, please see the notes below.
%
% % for generating a mask, which is defined as a common filed of all the slants tilted by sparam.mask_theta_deg below.
% sparam.mask_theta_deg   = [-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; % for masking, slopes of the slant stimuli in deg, orientation: right-upper-left
% sparam.mask_orient_deg  = 90; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW
%
% % [Important notes on angles/orientations of the slants]
% %
% % * the parameters required to define stimulus conditions (slant stimuli)
% %
% % sparam.theta_deg      : angles of the slant, negative = top is near, a [1 x N (= #conditions)] matrix
% % sparam.orient_deg     : tilted orientations of the slant in deg, a [1 x N (= #conditions)] matrix 
% % sparam.mask_type      : 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent, a [1 x N (= #conditions)] cell
% % sparam.mask_orient_id : ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...., a [1 x N (= #conditions)] matrix
% %
% %
% % * the number of required slants in this experiment are: 8 slants X three mask types = 24.
% %
% % sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5];
% % sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90];
% % sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',   'z',   'z',   'z',   'z',   'z',   'z',   'z',   'z'};
% % sparam.mask_orient_id=[    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1];
% %
% % however, plese note that some slants are the same. for instance,
% % (theta,orient,mask)=(-52.5, 90, 'n') is the same with (-52.5, 90,'xy')
% % (theta,orient,mask)=( 52.5, 90, 'n') is the same with ( 52.5, 90,'xy')
% % (theta,orient,mask)=( -7.5, 90, 'n') is the same with ( -7.5, 90, 'z')
% % (theta,orient,mask)=(  7.5, 90, 'n') is the same with (  7.5, 90, 'z')
% %
% % therefore, the total number of slants we need to use is actually 20.
% %
% % sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  22.5,  37.5,  52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5]; % angle of the slant, negative = top is near
% % sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90]; % tilted orientation of the slant in deg
% % sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'z',   'z',   'z',   'z',   'z',   'z',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy'}; % 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent
% 
% sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  22.5,  37.5,  52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5]; % angle of the slant, negative = top is near
% sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90]; % tilted orientation of the slant in deg
% sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'z',   'z',   'z',   'z',   'z',   'z',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy'}; % 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent
% sparam.mask_orient_id=[    1,      1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1]; % ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...
%
% sparam.theta_deg    = sparam.theta_deg(1:2:numel(sparam.theta_deg));
% sparam.orient_deg   = sparam.orient_deg(1:2:numel(sparam.theta_deg));
% sparam.mask_type    = sparam.mask_type(1:2:numel(sparam.theta_deg));
%
% sparam.aperture_deg = 10;   % size of circular aperture in deg
% sparam.fill_val     = 0;   % value to fill the 'hole' of the circular aperture
% sparam.outer_val    = 0;   % value to fill the outer region of slant field
%
% %%% RDS parameters
% sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
% sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
% sparam.dotDens=2; % deinsity of dot in RDS image (1-100)
% sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
% sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]
%
% % the number of trials
% sparam.numTrials=10;
%
% %%% stimulus display durations etc in 'msec'
% sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
% sparam.condition_duration=1300;   % duration in msec for each condition, integer (msec)
% sparam.stim_on_duration=300;      % duration in msec for simulus ON period for each trial, integer (msec)
% sparam.response_duration=1500;    % duration in msec for response, integer (msec)
% sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
% sparam.BetweenDuration=1000;      % duration in msec between trials, integer (msec)
%
% %%% background color
% sparam.bgcolor=[128,128,128];
%
% %%% fixation size and color
% sparam.fixsize=24;         % the whole size (a circular hole) of the fixation cross in pixel
% sparam.fixlinesize=[12,2]; % [height,width] of the fixation line in pixel
% sparam.fixcolor=[255,255,255];
%
% %%% RGB for background patches
% sparam.patch_size=[30,30]; % background patch size, [height,width] in pixels
% sparam.patch_num=[20,40];  % the number of background patches along vertical and horizontal axis
% sparam.patch_color1=[255,255,255];
% sparam.patch_color2=[0,0,0];
%
% %%% size of the punch stimulus (rectangle) for signaling to the photo diode (photo trigger)
% sparam.phototrg_size=[50,50];        % size of the photo-trigger patch in pixels
% sparam.phototrg_pos=[1280-25,-720+25]; % the center position (row,col) of the photo-trigger patch in pixels
% sparam.phototrg_color=[255,255,255]; % RGB color of the photo-trigger patch.
%
% %%% viewing parameters
% run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));
% %sparam.ipd=6.4;
% %sparam.pix_per_cm=57.1429;
% %sparam.vdist=65;
%
%
% [HOWTO create stimulus files]
% 1. All of the stimuli are created in this script in real-time
%    with MATLAB scripts & functions.
%    see ../Generation & ../Common directries.
% 2. Stimulus parameters are defined in the display & stimulus file.
%
%
% [about stimuli and task]
% Stimuli are presented by default as below
% stim 1-1(1000ms) -- blank(1000ms) -- between trial duration (1000-1500ms) --
% stim 2-1(1000ms) -- blank(1000ms) -- between trial duration (1000-1500ms) --
% ...(continued)...
%
% Observer's task is to discriminate which direction the target slant stimulus is tilted
% press key 1 when the slant's top side is to near (top-near)
% press key 2 when the slant's top side is to far (top-far)
%
%
% [about feedback]
% If sparam.give_feedback is set to 'true', correct/incorrect feedback is given to observer in each task trial.
% Correct  : Green Fixation with a high-tone sound
% Incorrect: Blue Fixation with a low-tone sound
%
%
% [reference]
% - Ban, H. & Welchman, A.E. (2015).
%   fMRI analysis-by-synthesis reveals a dorsal hierarchy that extracts surface slant.
%   The Journal of Neuroscience, 35(27), 9823-9835.
% - for stmulus generation, see ../Generation & ../Common directories.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Check the input variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear global; clear mex;
if nargin<2, help(mfilename()); return; end
if nargin<6 || isempty(overwrite_flg), overwrite_flg=0; end
if nargin<7 || isempty(force_proceed_flag), force_proceed_flag=0; end

% check the aqcuisition number.
if acq<1, error('Acquistion number must be integer and greater than zero'); end
if ~exist(fullfile(pwd,'subjects',subjID),'dir'), error('can not find subj directory. check input variable.'); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Add paths to the subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add paths to the subfunctions
rootDir=fileparts(mfilename('fullpath'));
addpath(fullfile(rootDir,'..','Common'));
addpath(fullfile(rootDir,'..','gamma_table'));
addpath(fullfile(rootDir,'..','Generation'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For a log file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% result directry & file
resultDir=fullfile(rootDir,'subjects',num2str(subjID),'results',datestr(now,'yymmdd'));
if ~exist(resultDir,'dir'), mkdir(resultDir); end

% record the output window
logfname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.log']);
diary(logfname);
warning off; %#ok warning('off','MATLAB:dispatcher:InexactCaseMatch');


%%%%% try & catch %%%%%
try


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Check the PTB version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PTB_OK=CheckPTBversion(3); % check wether the PTB version is 3
if ~PTB_OK, error('Wrong version of Psychtoolbox is running. %s requires PTB ver.3',mfilename()); end

% debug level, black screen during calibration
Screen('Preference','VisualDebuglevel',3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setup random seed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InitializeRandomSeed();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Reset display Gamma-function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<5 || isempty(gamma_table)
  gamma_table=repmat(linspace(0.0,1.0,256),3,1)'; %#ok
  GammaResetPTB(1.0);
else
  GammaLoadPTB(gamma_table);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Load and validate the contents of display and stimulus files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the codes below may be too redundant. you can omit those lines if you can care about the input
% variables and the contents of display and stimulus files by yourself.

% check the number of nargin
if nargin<=1
  error('takes at least 2 input variables: StereoMEGsample(subjID, acq, :displayfile, :stimulusfile, :gamma_table, :overwrite_flg)');
elseif nargin>6
  error('takes at most 7 input variables: StereoMEGsample(subjID, acq, :displayfile, :stimulusfile, :gamma_table, :overwrite_flg, :force_proceed_flag)');
else
  if nargin==2
    useDisplayFile=false;
    useStimulusFile=false;
  end
  if nargin>=3
    % reading display (presentation) parameters from file
    if strcmp(displayfile(end-1:end),'.m')
      dfile=fullfile(rootDir,'subjects',subjID,displayfile);
    else
      dfile=fullfile(rootDir,'subjects',subjID,[displayfile,'.m']);
    end
    [is_exist,message] = IsExistYouWant(dfile,'file');
    if is_exist
      useDisplayFile=true;
    else
      error(message);
    end
  end
  if nargin>=4
    % reading stimulus generation parameters from file
    if strcmp(stimulusfile(end-1:end),'.m')
      sfile=fullfile(rootDir,'subjects',subjID,stimulusfile);
    else
      sfile=fullfile(rootDir,'subjects',subjID,[stimulusfile '.m']);
    end
    [is_exist,message]=IsExistYouWant(sfile,'file');
    if is_exist
      useStimulusFile=true;
    else
      error(message);
    end
  end
end % if nargin

% check condition files

% set display parameters
if useDisplayFile

  % load displayfile
  run(fullfile(rootDir,'subjects',subjID,displayfile));

else  % if useDisplayFile

  % otherwise, set default variables

  %%% display mode
  % one of "mono", "dual", "dualparallel", "dualcross", "cross", "parallel", "redgreen", "greenred",
  % "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn"
  dparam.ExpMode='dual';

  dparam.scrID=1; % screen ID, generally 0 for a single display setup, 1 for dual display setup

  %%% a method to start stimulus presentation
  % 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (CiNet),
  % 3:waiting for a MR trigger pulse (BUIC) -- checking onset of pin #11 of the parallel port,
  % or 4:custom key trigger (wait for a key input that you specify as tgt_key).
  dparam.start_method=4;

  %%% a pseudo trigger key from the MR scanner when it starts, only valid when dparam.start_method=4;
  dparam.custom_trigger=KbName(84); % 't' is a default trigger code from MR scanner at CiNet

  dparam.Key1=37; % 37 is left-arrow on default Windows
  dparam.Key2=39; % 39 is right-arrow on default Windows

  %%% screen settings

  %%% whether displaying the stimuli in full-screen mode or as is (the precise resolution), true or false (true)
  dparam.fullscr=false;

  %%% the resolution of the screen height, integer (1024)
  dparam.ScrHeight=1200; %1024; %1200;

  %% the resolution of the screen width, integer (1280)
  dparam.ScrWidth=1600; %1280; %1920;

  % shift the screen center position along y-axis (to prevent the occlusion of the stimuli due to the coil)
  dparam.yshift=30;

end % if useDisplayFile

% set stimulus parameters
if useStimulusFile

  % load stimulusfile
  run(fullfile(rootDir,'subjects',subjID,stimulusfile));

  % change unit from msec to sec.
  sparam.initial_fixation_time=sparam.initial_fixation_time/1000;
  sparam.condition_duration=sparam.condition_duration/1000;
  sparam.BetweenDuration=sparam.BetweenDuration/1000;
  sparam.stim_on_duration=sparam.stim_on_duration/1000;
  sparam.response_duration=sparam.response_duration/1000;
  sparam.feedback_duration=sparam.feedback_duration/1000;

  sparam.stim_off_duration=sparam.condition_duration-sparam.stim_on_duration;

else  % if useStimulusFile

  % otherwise, set default variables

  %%% stimulus presentation mode
  sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
  sparam.give_feedback=false;    % true or false. if true, feedback (whether the response is correct or not) is given
  sparam.task_interval=3:5;      % frequency the depth discrimination task, the task occurs every sparam.task_interval trials

  %%% target image generation
  sparam.fieldSize=[12,12]; % target stimulus size in deg

  % [Important notes on stimulus masks]
  %
  % * the parameters required to define stimulus masks
  %
  % sparam.mask_theta_deg  : a set of slopes of the slants to be used for masking. the outer regions of the intersections of all these slants' projections on the XY-axes are masked.
  %                          for instance, if sparam.mask_orient_deg=[-22.5,-45], the -22.5 and -22.5 deg slants are first generated, their non-zero components are projected on the XY plane,
  %                          and then a stimulus mask is generated in two ways.
  %                          1. 'xy' mask: the intersection of the two projections are set to 1, while the oter regions are set to 1. The mask is used to restrict the spatial extensions
  %                             of the target slants within the common spatial extent.
  %                          2. 'z'  mask: the disparity range of the slants are restricted so that the maximum disparity values are the average of all disparities contained in all set of slants.
  %                             using this mask, we can restrict the disparity range across the different angles of the slants.
  % sparam.mask_orient_deg : tilt angles of a set of slopes of the slants. if multiple values are set, masks are generated separately for each element of sparam.mask_orient_deg.
  %                          for instance, if sparam.mask_theta_deg=[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; and sparam.mask_orient_deg=[45, 90];, two masks are generated as below.
  %                          1. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
  %                          2. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
  %
  %
  % * how to set masks for the main slant stimuli
  %
  % to set the masks to the main slant stimuli, please use sparam.mask_type and sparam.mask_orient_id.
  % for details, please see the notes below.

  % for generating a mask, which is defined as a common filed of all the slants tilted by sparam.mask_theta_deg below.
  sparam.mask_theta_deg   = [-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; % for masking, slopes of the slant stimuli in deg, orientation: right-upper-left
  sparam.mask_orient_deg  = [0,45,90,135]; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW

  % [Important notes on angles/orientations of the slants]
  %
  % * the parameters required to define stimulus conditions (slant stimuli)
  %
  % sparam.theta_deg      : angles of the slant, negative = top is near, a [1 x N (= #conditions)] matrix
  % sparam.orient_deg     : tilted orientations of the slant in deg, a [1 x N (= #conditions)] matrix 
  % sparam.mask_type      : 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent, a [1 x N (= #conditions)] cell
  % sparam.mask_orient_id : ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...., a [1 x N (= #conditions)] matrix
  %
  %
  % * the number of required slants in this experiment are: 8 slants X three mask types = 24.
  %
  % sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5];
  % sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90];
  % sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy',   'z',   'z',   'z',   'z',   'z',   'z',   'z',   'z'};
  % sparam.mask_orient_id=[    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1];
  %
  % however, plese note that some slants are the same. for instance,
  % (theta,orient,mask)=(-52.5, 90, 'n') is the same with (-52.5, 90,'xy')
  % (theta,orient,mask)=( 52.5, 90, 'n') is the same with ( 52.5, 90,'xy')
  % (theta,orient,mask)=( -7.5, 90, 'n') is the same with ( -7.5, 90, 'z')
  % (theta,orient,mask)=(  7.5, 90, 'n') is the same with (  7.5, 90, 'z')
  %
  % therefore, the total number of slants we need to use is actually 20.
  %
  % sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  22.5,  37.5,  52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5]; % angle of the slant, negative = top is near
  % sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90]; % tilted orientation of the slant in deg
  % sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'z',   'z',   'z',   'z',   'z',   'z',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy'}; % 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent
  
  sparam.theta_deg    = [ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5, -52.5, -37.5, -22.5,  22.5,  37.5,  52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5]; % angle of the slant, negative = top is near
  sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90,    90]; % tilted orientation of the slant in deg
  sparam.mask_type    = {   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'n',   'z',   'z',   'z',   'z',   'z',   'z',  'xy',  'xy',  'xy',  'xy',  'xy',  'xy'}; % 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent
  sparam.mask_orient_id=[    1,      1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,     1]; % ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...

  sparam.theta_deg    = sparam.theta_deg(1:2:numel(sparam.theta_deg));
  sparam.orient_deg   = sparam.orient_deg(1:2:numel(sparam.orient_deg));
  sparam.mask_type    = sparam.mask_type(1:2:numel(sparam.mask_type));
  sparam.mask_orient_id=sparam.mask_orient_id(1:2:numel(sparam.mask_orient_id));

  sparam.aperture_deg = 10;   % size of circular aperture in deg
  sparam.fill_val     = 0;   % value to fill the 'hole' of the circular aperture
  sparam.outer_val    = 0;   % value to fill the outer region of slant field

  %%% RDS parameters
  sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
  sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
  sparam.dotDens=2; % deinsity of dot in RDS image (1-100)
  sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
  sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]

  % the number of trials per condition
  sparam.numTrials=10;

  %%% stimulus display durations etc in 'msec'
  sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
  sparam.condition_duration=1300;   % duration in msec for each condition, integer (msec)
  sparam.stim_on_duration=300;      % duration in msec for simulus ON period for each trial, integer (msec)
  sparam.response_duration=1500;    % duration in msec for response, integer (msec)
  sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
  sparam.BetweenDuration=1000;      % duration in msec between trials, integer (msec)

  sparam.stim_off_duration=sparam.condition_duration-sparam.stim_on_duration;

  %%% fixation size and color
  sparam.fixsize=24;         % the whole size (a circular hole) of the fixation cross in pixel
  sparam.fixlinesize=[12,2]; % [height,width] of the fixation line in pixel
  sparam.fixcolor=[255,255,255];

  %%% RGB for background patches
  sparam.patch_size=[30,30]; % background patch size, [height,width] in pixels
  sparam.patch_num=[20,40];  % the number of background patches along vertical and horizontal axis
  sparam.patch_color1=[255,255,255];
  sparam.patch_color2=[0,0,0];

  %%% size of the punch stimulus (rectangle) for signaling to the photo diode (photo trigger)
  sparam.phototrg_size=[50,50];        % size of the photo-trigger patch in pixels
  sparam.phototrg_pos=[1280-25,-720+25]; % the center position (row,col) of the photo-trigger patch in pixels
  sparam.phototrg_color=[255,255,255]; % RGB color of the photo-trigger patch.

  %%% viewing parameters
  %run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));
  sparam.ipd=6.4;
  sparam.pix_per_cm=57.1429;
  sparam.vdist=65;

end % if useStimulusFile

% set the other parameters
dparam.RunScript=mfilename();
sparam.RunScript=mfilename();

% check the parameters
if numel(sparam.theta_deg)~=numel(sparam.orient_deg)
  error('the number of elements in sparam.theta_deg and sparam.orient_deg mismatched. check the stimulus file.');
end

if numel(sparam.theta_deg)~=length(sparam.mask_type)
  error('the number of elements in sparam.theta_deg and sparam.mask_type mismatched. check the stimulus file.');
end

% set the number of conditions
sparam.numConds=numel(sparam.theta_deg);

% displaying the Presentation Parameters
disp('The Presentation Parameters are as below.');
fprintf('\n');
disp('************************************************');
disp('****** Script, Subject, Acquistion Number ******');
eval(sprintf('disp(''Running Script Name    : %s'');',mfilename()));
eval(sprintf('disp(''Subject ID             : %s'');',subjID));
eval(sprintf('disp(''Acquisition Number     : %d'');',acq));
disp('********* Run Type, Display Image Type *********');
eval(sprintf('disp(''Display Mode           : %s'');',dparam.ExpMode));
eval(sprintf('disp(''use Full Screen Mode   : %d'');',dparam.fullscr));
eval(sprintf('disp(''Start Method           : %d'');',dparam.start_method));
if dparam.start_method==4
  eval(sprintf('disp(''Custom Trigger         : %s'');',dparam.custom_trigger));
end
disp('*************** Screen Settings ****************');
eval(sprintf('disp(''Screen Height          : %d'');',dparam.ScrHeight));
eval(sprintf('disp(''Screen Width           : %d'');',dparam.ScrWidth));
disp('*********** Stimulation periods etc. ***********');
eval(sprintf('disp(''Fixation Time(ms)      : %.2f'');',1000*sparam.initial_fixation_time));
eval(sprintf('disp(''Cond Duration(ms)      : %.2f'');',1000*sparam.condition_duration));
eval(sprintf('disp(''Between Trial Dur(ms)  : %.2f'');',1000*sparam.BetweenDuration));
eval(sprintf('disp(''Stim ON Duration(ms)   : %.2f'');',1000*sparam.stim_on_duration));
eval(sprintf('disp(''Stim OFF Duration(ms)  : %.2f'');',1000*sparam.stim_off_duration));
disp('************** Stimulus Conditions *************');
eval(sprintf('disp(''#conditions            : %d'');',sparam.numConds));
eval(sprintf('disp(''#trials per condition  : %d'');',sparam.numTrials));
disp('************ Response key settings *************');
eval(sprintf('disp(''Reponse Key #1         : %d=%s'');',dparam.Key1,KbName(dparam.Key1)));
eval(sprintf('disp(''Reponse Key #2         : %d=%s'');',dparam.Key2,KbName(dparam.Key2)));
disp('************************************************');
fprintf('\n');
disp('Please carefully check before proceeding.');
fprintf('\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating stimulus presentation protocol, a design structure, and QUEST data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variables described below are for storing participant behaviors

% generate design matrix
% design matrix consists with 2 parameters: theta_deg, orient_deg.
% for instance,
% [theta_deg1, orient_deg1;
%  theta_deg2, orient_deg2;
%  theta_deg3, orient_deg3;
%  ...];
design=zeros(numel(sparam.theta_deg),2);
for ii=1:1:numel(sparam.theta_deg), design(ii,:)=[sparam.theta_deg(ii),sparam.orient_deg(ii)]; end

% % delete conditions with theta_deg==0, orient_deg~=0 since the stimuli are completely same
% % when the theta_deg==0
% idx=logical(design(:,1)==0 & design(:,2)~=0);
% if numel(find(idx==1))~=1, design(idx(2:end),:)=[]; end

%% Variables described below are tempral ones.

% stimulus IDs
% The ID array is modified during stimulus presentation and deleted after the measurements
condition_ID_holder=(1:size(design,1))';

% to store numbers of the current trials
trial_counter=zeros(size(design,1),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initialize response & event logger objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize MATLAB objects for event and response logs
event=eventlogger();
resps=responselogger([dparam.Key1,dparam.Key2]);
resps.initialize(event); % initialize responselogger


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Wait for user reponse to start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~force_proceed_flag
  [user_answer,resps]=resps.wait_to_proceed();
  if ~user_answer, diary off; return; end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initialization of Left & Right screens for binocular presenting/viewing mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set 1 only when you are sure that you are going to ignore the display vertical synch signals
%Screen('Preference','SkipSyncTests',1);

% ************************************* IMPORTANT NOTE *****************************************
% if the console PC has been connected to two 3D displays with the expanding display setups and
% some shutter goggles (e.g. nVidia 3DVision2) are used for displaying 3D stimulus with MATLAB
% Psychtoolbox3 (PTB3), the 3D stimuli can be presented properly only when we select the first
% display (scrID=1) for stimulus presentations, while left/right images seem to be flipped if
% we select the second display (scrID=2) as the main stimulus presentation window. This may be
% a bug of PTB3. So in any case, if you run 3D vision experiments with dual monitors, it would
% be safer to always chose the first monitor for stimulus presentations. Please be careful.
% ************************************* IMPORTANT NOTE *****************************************

[winPtr,winRect,nScr,dparam.fps,dparam.ifi,initDisplay_OK]=InitializePTBDisplays(dparam.ExpMode,sparam.bgcolor,0,[],dparam.scrID);
if ~initDisplay_OK, error('Display initialization error. Please check your exp_run parameter.'); end
HideCursor();

%dparam.fps=60; % set the fixed flips/sec velue just in case, as the PTB sometimes underestimates the actual vertical sync signals.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting the PTB runnning priority to MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the priority of this script to MAX
priorityLevel=MaxPriority(winPtr,'WaitBlanking');
Priority(priorityLevel);

% conserve VRAM memory: Workaround for flawed hardware and drivers
% 32 == kPsychDontShareContextRessources: Do not share ressources between
% different onscreen windows. Usually you want PTB to share all ressources
% like offscreen windows, textures and GLSL shaders among all open onscreen
% windows. If that causes trouble for some weird reason, you can prevent
% automatic sharing with this flag.
%Screen('Preference','ConserveVRAM',32);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting the PTB OpenGL functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable OpenGL mode of Psychtoolbox: This is crucially needed for clut animation
InitializeMatlabOpenGL();

% This script calls Psychtoolbox commands available only in OpenGL-based
% versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
% only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
% an error message if someone tries to execute this script on a computer without
% an OpenGL Psychtoolbox
AssertOpenGL();

% set OpenGL blend functions
Screen('BlendFunction',winPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing MATLAB OpenGL shader API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Not required for the current display and stimulus setups
% just call DrawTextureWithCLUT with window pointer alone
%DrawTextureWithCLUT(winPtr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Displaying 'Initializing...'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% displaying texts on the center of the screen
DisplayMessage2('Initializing...',sparam.bgcolor,winPtr,nScr,'Arial',36);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cm per pix
sparam.cm_per_pix=1/sparam.pix_per_cm;

% pixles per degree
sparam.pix_per_deg=round( 1/( 180*atan(sparam.cm_per_pix/sparam.vdist)/pi ) );

% sound sources for feedback correct/incorrect
if sparam.give_feedback
  beep_correct=sin(2*pi*0.2*(0:900));
  beep_incorrect=sin(2*pi*0.012*(0:900));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing height fields & image shifts by binocular disparities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to get stimulus image size
tmp_slant_field=sla_CreateCircularSlantField(sparam.fieldSize,sparam.theta_deg(1),sparam.orient_deg(1),...
                                             sparam.aperture_deg,sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);

% NOTE:
% the codes below are just to generate mask fields.
% the actual stimuli are generated each time in the main trial loop.

if sum(strcmpi(sparam.mask_type,'xy'))~=0 || sum(strcmpi(sparam.mask_type,'z'))~=0

  % generate slant heightfields for XY- and Z- masking
  slant_field=cell(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  slant_mask=cell(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      [slant_field{ii,jj},slant_mask{ii,jj}]=sla_CreateCircularSlantField(sparam.fieldSize,sparam.mask_theta_deg(ii),sparam.mask_orient_deg(jj),...
                                                        sparam.aperture_deg,sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
      slant_field{ii,jj}=slant_field{ii,jj}.*sparam.cm_per_pix; % convert pix to cm
    end
  end

  % generate xy-masked slant field

  % generate mask(s) by extracting the common spatial region over sparam.mask_theta_deg for each of sparam.mask_orient_deg
  smask=ones([size(slant_mask{1,1}),numel(sparam.mask_orient_deg)]);
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      smask(:,:,jj)=smask(:,:,jj).*slant_mask{ii,jj};
    end
  end

  % generate z-masked slant field

  % get max/min height(~=disparity) from each slant_field with each of sparam.mask_orient_deg
  max_height=zeros(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  min_height=zeros(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      max_height(ii,jj)=max(slant_field{ii,jj}(:));
      min_height(ii,jj)=min(slant_field{ii,jj}(:));
    end
  end

  clear slant_field slant_mask;

end % if sum(strcmpi(sparam.mask_type,'xy'))~=0 || sum(strcmpi(sparam.mask_type,'z'))~=0

% adjust parameters for oversampling (these adjustments shoud be done after creating heightfields)
dotDens=sparam.dotDens/sparam.oversampling_ratio;
ipd=sparam.ipd*sparam.oversampling_ratio;
vdist=sparam.vdist*sparam.oversampling_ratio;
pix_per_cm_x=sparam.pix_per_cm*sparam.oversampling_ratio;
pix_per_cm_y=sparam.pix_per_cm;

% generate ovals to be used in generating RDSs
dotSize=round(sparam.dotRadius.*[pix_per_cm_y,pix_per_cm_x]*2); % radius(cm) --> diameter(pix)
basedot=double(MakeFineOval(dotSize,[sparam.colors(1:2) 0],sparam.colors(3),1.2,2,1,0,0));
wdot=basedot(:,:,1); % get only gray scale image (white)
bdot=basedot(:,:,2); % get only gray scale image (black)
dotalpha=basedot(:,:,4)./max(max(basedot(:,:,4))); % get alpha channel value 0-1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Debug codes
%%%% just to save each images as *.png format files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%% DEBUG codes start here. The codes below are just to get stimulus images and check the dparam and sparam parameters
% note: debug stimuli have no jitters in binocular disparities
if strfind(upper(subjID),'DEBUG')

  Screen('CloseAll');

  imgL=cell(size(design,1),1);
  imgR=cell(size(design,1),1);
  posL=cell(size(design,1),1);
  posR=cell(size(design,1),1);

  for ii=1:1:size(design,1)

    % set the current stimulus parameters
    theta_deg= design(ii,1);
    orient_deg=design(ii,2);

    % generate slant height field with sinusoidal grating
    if ~strcmp(sparam.mask_type{ii},'xy')
      slant_field=sla_CreateCircularSlantField(sparam.fieldSize,theta_deg,orient_deg,sparam.aperture_deg,...
                                               sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
    else
      slant_field=sla_CreatePlaneSlantField(sparam.fieldSize,theta_deg,orient_deg,sparam.pix_per_deg,sparam.oversampling_ratio);
    end
    slant_field=slant_field.*sparam.cm_per_pix;

    % put XY-mask on the slant_field
    if strcmp(sparam.mask_type{ii},'xy')
      slant_field=slant_field.*smask(:,:,sparam.mask_orient_id(ii));
      slant_field(smask(:,:,sparam.mask_orient_id(ii))~=1)=sparam.outer_val;
    end

    % put Z-mask on the slant_field
    if strcmp(sparam.mask_type{ii},'z')
      maxH=mean(max_height(:,sparam.mask_orient_id(ii))); %maxH=min(max_height(:,sparam.mask_orient_id(ii)));
      minH=mean(min_height(:,sparam.mask_orient_id(ii))); %minH=max(min_height(:,sparam.mask_orient_id(ii)));
      slant_field(slant_field<minH | maxH<slant_field)=sparam.outer_val;
    end

    % calculate left/right eye image shifts
    [posL{ii},posR{ii}]=RayTrace_ScreenPos_X_MEX(slant_field,ipd,vdist,pix_per_cm_x,0);

    % generate RDS images
    [imgL{ii},imgR{ii}]=sla_RDSfastest_with_noise_MEX(posL{ii},posR{ii},wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3));
    imgL{ii}=imresize(imgL{ii},[1,1/sparam.oversampling_ratio].*size(imgL{ii}),'bilinear');
    if sparam.binocular_display
      imgR{ii}=imresize(imgR{ii},[1,1/sparam.oversampling_ratio].*size(imgR{ii}),'bilinear');
    else
      imgR{ii}=imgL{ii};
    end

  end % for ii=1:1:size(design,1)

  % save stimuli as *.mat
  save_dir=fullfile(pwd,'images');
  if ~exist(save_dir,'dir'), mkdir(save_dir); end
  save(fullfile(save_dir,'oblique3D_stimuli.mat'),'design','dparam','sparam','imgL','imgR','posL','posR','wdot','bdot','dotalpha');

  % plotting/saving figures
  for ii=1:1:size(design,1)

    % save generated figures as png
    if ~strcmp(dparam.ExpMode,'redgreen') && ~strcmp(dparam.ExpMode,'redblue')
      M = [imgL{ii},sparam.bgcolor(3)*ones(size(imgL{ii},1),20),imgR{ii},sparam.bgcolor(3)*ones(size(imgL{ii},1),20),imgL{ii}];
      % im_h = imagesc(M,[0 255]);
      % axis off
      % % truesize is necessary to avoid automatic scaling
      % size_one2one(im_h);
      % colormap(gray);
      % shg;
    else
      M=reshape([imgL{ii},imgR{ii},sparam.bgcolor(3)*ones(size(imgL{ii}))],[size(imgL{ii}),3]); % RGB;
      % im_h = imagesc(M);
      % axis off
      % % truesize is necessary to avoid automatic scaling
      % size_one2one(im_h);
      % shg;
    end

    figure; hold on;
    imfig=imshow(M,[0,255]);
    if ~strcmp(dparam.ExpMode,'redgreen') && ~strcmp(dparam.ExpMode,'redblue')
      fname=sprintf('oblique3D_cond%03d_theta%.2f_ori%.2f.png',ii,design(ii,1),design(ii,2));
    else
      fname=sprintf('oblique3D_red_green_cond%03d_theta%.2f_ori%.2f.png',ii,design(ii,1),design(ii,2));
    end
    %saveas(imfig,[save_dir,filesep(),fname,'.png'],'png');
    imwrite(M,[save_dir,filesep(),fname,'.png'],'png');

  end % for ii=1:1:size(design,1)

  keyboard;
  return;

end % if strfind(upper(subjID),'DEBUG')
% %%%%%% DEBUG code ends here


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating the background image with vergence-guide grids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the central aperture size of the background image
edgeY=mod(dparam.ScrHeight,sparam.patch_num(1)); % delete exceeded region
p_height=round((dparam.ScrHeight-edgeY)/sparam.patch_num(1)); % height in pix of patch_height + interval-Y

edgeX=mod(dparam.ScrWidth,sparam.patch_num(2)); % delete exceeded region
p_width=round((dparam.ScrWidth-edgeX)/sparam.patch_num(2)); % width in pix of patch_width + interval-X

aperture_size(1)=2*( p_height*ceil(size(tmp_slant_field,1)/2/p_height) );
aperture_size(2)=2*( p_width*ceil(size(tmp_slant_field,2)/sparam.oversampling_ratio/2/p_width) );
%aperture_size=[500,500];

bgimg=CreateBackgroundImage([dparam.ScrHeight,dparam.ScrWidth],...
          aperture_size,sparam.patch_size,sparam.bgcolor,sparam.patch_color1,sparam.patch_color2,sparam.fixcolor,sparam.patch_num,0,0,0);
background=Screen('MakeTexture',winPtr,bgimg{1});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating the central fixation (left/right)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create fixation cross images
[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,sparam.fixcolor,sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
fcross{1}=Screen('MakeTexture',winPtr,fix_L);
fcross{2}=Screen('MakeTexture',winPtr,fix_R);

[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[32,32,32],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
wait_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
wait_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[255,0,0],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
task_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
task_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

if sparam.give_feedback
  [fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[0,255,0],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
  correct_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
  correct_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

  [fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[0,0,255],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
  incorrect_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
  incorrect_fcross{2}=Screen('MakeTexture',winPtr,fix_R);
end
clear fix_L fix_R;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating the photo-trigger marker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trgimg=repmat(reshape(sparam.phototrg_color,[1,1,3]),sparam.phototrg_size);
trg{1}=Screen('MakeTexture', winPtr,trgimg);
trg{2}=Screen('MakeTexture', winPtr,trgimg);

notrg{1}=Screen('MakeTexture', winPtr,zeros([sparam.phototrg_size,3]));
notrg{2}=Screen('MakeTexture', winPtr,zeros([sparam.phototrg_size,3]));

clear trgimg;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% image size adjustments to match the current display resolutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if dparam.fullscr
  ratio_wid=( winRect(3)-winRect(1) )/dparam.ScrWidth;
  ratio_hei=( winRect(4)-winRect(2) )/dparam.ScrHeight;
  stimSize = [size(tmp_slant_field,2)*ratio_wid size(tmp_slant_field,1)*ratio_hei].*[1/sparam.oversampling_ratio,1];
  bgSize=[size(bgimg{1},2)*ratio_wid,size(bgimg{1},1)*ratio_hei];
  fixSize=[2*sparam.fixsize*ratio_wid,2*sparam.fixsize*ratio_hei];
  trgSize=[sparam.phototrg_size(2)*ratio_wid,sparam.phototrg_size(1)*ratio_hei];
else
  stimSize=[size(tmp_slant_field,2),size(tmp_slant_field,1)].*[1/sparam.oversampling_ratio,1];
  bgSize=[dparam.ScrWidth,dparam.ScrHeight];
  fixSize=[2*sparam.fixsize,2*sparam.fixsize];
  trgSize=[sparam.phototrg_size(2),sparam.phototrg_size(1)];
end

% for some display modes in which one screen is splitted into two binocular displays
if strcmpi(dparam.ExpMode,'cross') || strcmpi(dparam.ExpMode,'parallel') || ...
   strcmpi(dparam.ExpMode,'topbottom') || strcmpi(dparam.ExpMode,'bottomtop')
  stimSize=stimSize./2;
  bgSize=bgSize./2;
  fixSize=fixSize./2;
  trgSize=trgSize./2;
end

stimRect=[0,0,stimSize]; % used to display target stimuli
bgRect=[0,0,bgSize];     % used to display background images
fixRect=[0,0,fixSize];   % used to display the central fixation point
trgRect=[0,0,trgSize];   % used to display the photo trigger marker

% set display shift along y-axis
yshift=[0,dparam.yshift,0,dparam.yshift];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Saving the current parameters temporally
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saving the current parameters
% (this is required to analyze part of the data obtained even when the experiment is interrupted unexpectedly)
fprintf('saving the stimulus generation and presentation parameters...');
savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat']);

% backup the old file(s)
if ~overwrite_flg
  rdir=relativepath(resultDir); rdir=rdir(1:end-1);
  BackUpObsoleteFiles(rdir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat'],'_old');
  clear rdir;
end

% save the current parameters
eval(sprintf('save %s subjID acq design sparam dparam gamma_table;',savefname));

disp('done.');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Displaying 'Ready to Start'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% displaying texts on the center of the screen
DisplayMessage2('Ready to Start',sparam.bgcolor,winPtr,nScr,'Arial',36);
ttime=GetSecs(); while (GetSecs()-ttime < 0.5), end  % run up the clock.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Flip the display(s) to the background image(s) and inform the ready of stimulus presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change the screen and wait for the trigger or pressing the start button
for nn=1:1:nScr
  Screen('SelectStereoDrawBuffer',winPtr,nn-1);
  Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
  Screen('DrawTexture',winPtr,wait_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
  Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
end
Screen('DrawingFinished',winPtr);
Screen('Flip', winPtr,[],[],[],1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Wait for the start of the measurement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add time stamp (this also works to load add_event method in memory in advance of the actual displays)
fprintf('\nExperiment running...\n');
event=event.add_event('Experiment Start',strcat([datestr(now,'yymmdd'),' ',datestr(now,'HH:mm:ss')]),GetSecs());

% waiting for stimulus presentation
resps.wait_stimulus_presentation(dparam.start_method,dparam.custom_trigger);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Event logs and timer (!start here!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[event,the_experiment_start]=event.set_reference_time(GetSecs());
targetTime=the_experiment_start;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initial Fixation Period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% wait for the initial fixation period
if sparam.initial_fixation_time~=0
  event=event.add_event('Initial Fixation',[]);
  fprintf('\nfixation\n\n');

  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip', winPtr,[],[],[],1);

  % wait for the initial fixation
  targetTime=targetTime+sparam.initial_fixation_time;
  while GetSecs()<targetTime, [resps,event]=resps.check_responses(event); end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The Trial Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tBetweenTrial=GetSecs();
stimulus_order=[];
task_counter=0;
task_interval=shuffle(sparam.task_interval);
task_interval=task_interval(1);
while ~isempty(condition_ID_holder)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Stimulus generation
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % get the current stimulus ID
  tmp=shuffle(condition_ID_holder);
  stimID=tmp(1);

  % set the current stimulus parameters
  theta_deg=design(stimID,1);
  orient_deg=design(stimID,2);

  task_counter=task_counter+1; % count the task interval

  if task_counter~=task_interval
    trial_counter(stimID)=trial_counter(stimID)+1; % update the #trial per condition
    stimulus_order=[stimulus_order,stimID]; %#ok
  end

  %jitter=shuffle(-2:2); jitter=jitter(1);
  jitter=0;

  % generate slant height field with sinusoidal grating
  if ~strcmpi(sparam.mask_type{stimID},'xy')
    slant_field=sla_CreateCircularSlantField(sparam.fieldSize,theta_deg+jitter,orient_deg,sparam.aperture_deg,...
                                             sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
  else
    slant_field=sla_CreatePlaneSlantField(sparam.fieldSize,theta_deg+jitter,orient_deg,sparam.pix_per_deg,sparam.oversampling_ratio);
  end
  slant_field=slant_field.*sparam.cm_per_pix;

  % put XY-mask on the slant_field
  if strcmp(sparam.mask_type{stimID},'xy')
    slant_field=slant_field.*smask(:,:,sparam.mask_orient_id(stimID));
    slant_field(smask(:,:,sparam.mask_orient_id(stimID))~=1)=sparam.outer_val;
  end

  % put Z-mask on the slant_field
  if strcmp(sparam.mask_type{stimID},'z')
    maxH=mean(max_height(:,sparam.mask_orient_id(stimID))); %maxH=min(max_height(:,sparam.mask_orient_id(stimID)));
    minH=mean(min_height(:,sparam.mask_orient_id(stimID))); %minH=max(min_height(:,sparam.mask_orient_id(stimID)));
    zmask=zeros(size(slant_field));
    zmask(minH<=slant_field & slant_field<=maxH)=1;
    slant_field(slant_field<minH | maxH<slant_field)=sparam.outer_val;
  end

  % calculate left/right eye image shifts
  [posL,posR]=RayTrace_ScreenPos_X_MEX(slant_field,ipd,vdist,pix_per_cm_x,0);

  % generate RDS images with/without mask
  % if masking_the_outer_region_flg is set, mask all the dots located in the outer region
  if ~isstructmember(sparam,'masking_the_outer_region_flg'), sparam.masking_the_outer_region_flg=0; end
  if sparam.masking_the_outer_region_flg
    if strcmp(sparam.mask_type{stimID},'n')
      [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),smask(:,:,sparam.mask_orient_id(stimID)));
    elseif strcmp(sparam.mask_type{stimID},'xy')
      [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),smask(:,:,sparam.mask_orient_id(stimID)));
    elseif strcmp(sparam.mask_type{stimID},'z')
      [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),zmask);
    end
  else
    [imgL,imgR]=sla_RDSfastest_with_noise_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3));
  end

  stim{1}=Screen('MakeTexture',winPtr,imgL); % the first 1 = left (the first screen)
  if sparam.binocular_display % display binocular image
    stim{2}=Screen('MakeTexture',winPtr,imgR); % the first 2 = right (the second screen)
  else
    stim{2}=Screen('MakeTexture',winPtr,imgL);
  end

  % wait for the BetweenDuration with some jitters
  tBetweenTrial=tBetweenTrial+sparam.BetweenDuration+(100*randi(3,1)-100)/1000; % (100*randi(3,1)-100)/1000 is for adding a random jitter in duration [0-200,100ms steps]
  while GetSecs()<tBetweenTrial, [resps,event]=resps.check_responses(event); end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Stimulus display & animation
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  tStimulation=GetSecs(); % current time

  %% log/display the stimulus parameters
  if task_counter~=task_interval
    event=event.add_event('Start block',['ID_',num2str(stimID),'_theta_',num2str(theta_deg),'_orient_',num2str(orient_deg),...
                          '_trials_',num2str(trial_counter(stimID),'%03d')]);
    fprintf('STIM ID:%02d, THETA:% 3.2f, ORIENTATION:% 3d, TRIALS:%03d\n',stimID,theta_deg,orient_deg,trial_counter(stimID));
  else
    event=event.add_event('Task block',['ID_',num2str(stimID),'_theta_',num2str(theta_deg),'_orient_',num2str(orient_deg),...
                          '_trials_',num2str(trial_counter(stimID),'%03d')]);
    fprintf('TASK ID:%02d, THETA:% 3.2f, ORIENTATION:% 3d\n',stimID,theta_deg,orient_deg);
  end

  %% stimulus ON
  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,stim{nn},[],CenterRect(stimRect,winRect)+yshift);
    if task_counter~=task_interval
      Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,trg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
    else
      Screen('DrawTexture',winPtr,task_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
    end
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip',winPtr,[],[],[],1);

  % wait for stim_on_duration
  tStimulation=tStimulation+sparam.stim_on_duration;
  while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end

  %% stimulus OFF
  event=event.add_event('Stimulus off','');
  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    if task_counter~=task_interval
      Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
    else
      Screen('DrawTexture',winPtr,task_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
    end
    Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip',winPtr,[],[],[],1);

  % wait for stim_off_duration
  tStimulation=tStimulation+sparam.stim_off_duration;
  while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end

  %% get observer response
  if task_counter==task_interval

    tResponse=GetSecs();

    % display response cue
    event=event.add_event('Waiting for response','');
    for nn=1:1:nScr
      Screen('SelectStereoDrawBuffer',winPtr,nn-1);
      Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,wait_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      %Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
    end
    Screen('DrawingFinished',winPtr);
    Screen('Flip',winPtr,[],[],[],1);

    % get observer's response

    % the line below are just for debugging of response acquisitions and plotting results
    %respFlag=1; response=mod(randi(2,[1,1]),2);

    response=0;
    tResponse=tResponse+sparam.response_duration;
    while GetSecs()<tResponse
      [resps,event,keyCode]=resps.check_responses(event);

      % correct response
      if (keyCode(dparam.Key1) && theta_deg<0) || (keyCode(dparam.Key2) && theta_deg>0)
        response=1;
        break;
      % incorrect
      elseif (keyCode(dparam.Key1) && theta_deg>0) || (keyCode(dparam.Key2) && theta_deg<0)
        response=0;
        break;
      else % press the other key or mistake
        response=0;
      end
    end

    %% give correct/incorrect feedback and wait for dparam.BetweenDuration (duration between trials)
    if sparam.give_feedback
      tFeedback=GetSecs();

      % display feedback
      for nn=1:1:nScr
        Screen('SelectStereoDrawBuffer',winPtr,nn-1);
        Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
        if response
          event=event.add_event('Feedback','correct');
          Screen('DrawTexture',winPtr,correct_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
        else
          event=event.add_event('Feedback','incorrect');
          Screen('DrawTexture',winPtr,incorrect_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
        end
        Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
      end
      Screen('DrawingFinished',winPtr);
      Screen('Flip',winPtr,[],[],[],1);

      % sound feedback
      try % if this script can write data to sound devide
        if response
          Snd('Play',beep_correct,22000);
        else
          Snd('Play',beep_incorrect,22000);
        end
      catch %#ok %lasterror
        % do nothing
      end

      % wait for feedback_duration
      tFeedback=tFeedback+sparam.feedback_duration;
      while GetSecs()<tFeedback, [resps,event]=resps.check_responses(event); end
    end % if sparam.give_feedback

  end % if task_counter==task_interval

  %% back to the default view and wait for dparam.BetweenDuration (duration between trials)

  tBetweenTrial=GetSecs();

  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    %Screen('DrawTexture',winPtr,wait_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,notrg{nn},[],CenterRect(trgRect,winRect)+repmat(sparam.phototrg_pos,[1,2])+yshift);
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip',winPtr,[],[],[],1);

  % garbage collections, clean up the current texture & release memory
  for nn=1:1:nScr, Screen('Close',stim{nn}); end

  % delete finished condition from condition_ID_holder
  if trial_counter(stimID)==sparam.numTrials, condition_ID_holder(condition_ID_holder==stimID)=[]; end

  % refresh the task counter
  if task_counter==task_interval
    task_interval=shuffle(sparam.task_interval);
    task_interval=task_interval(1);
    task_counter=0;
  end

  % the last interval, waiting for the BetweenDuration
  if isempty(condition_ID_holder)
    tBetweenTrial=tBetweenTrial+sparam.BetweenDuration+(100*randi(3,1)-100)/1000; % (100*randi(3,1)-100)/1000 is random jitter of duration [0-200,100ms steps]
    while GetSecs()<tBetweenTrial, [resps,event]=resps.check_responses(event); end
  end
end % ~isempty(condition_ID_holder)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Experiment ends here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experimentDuration=GetSecs()-the_experiment_start;
event=event.add_event('End',[]);
disp(' ');
disp(['Experiment Duration was: ',num2str(experimentDuration),' secs']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Write experiment parameters and results into a file for post analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saving the results
fprintf('saving data...');

savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat']);
eval(sprintf('save -append %s event stimulus_order;',savefname));
disp('done.');

% tell the experimenter that the measurements are completed
try
  for ii=1:1:3, Snd('Play',sin(2*pi*0.2*(0:900)),8000); end
catch
  % do nothing
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cleaning up the PTB screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('CloseAll');
ShowCursor();
Priority(0);
GammaResetPTB(1.0);
rmpath(genpath(fullfile(rootDir,'..','Common')));
rmpath(fullfile(rootDir,'..','gamma_table'));
rmpath(fullfile(rootDir,'..','Generation'));
%close all; clear all; clear mex; clear global;
diary off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Catch the errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

catch %#ok
  % this "catch" section executes in case of an error in the "try" section
  % above.  Importantly, it closes the onscreen window if its open.
  Screen('CloseAll');
  ShowCursor;
  Priority(0);
  GammaResetPTB(1.0);
  tmp=lasterror; %#ok
  if exist('event','var'), event=event.get_event(); end %#ok % just for debugging
  diary off;
  fprintf(['\nError detected and the program was terminated.\n',...
           'To check error(s), please type ''tmp''.\n',...
           'Please save the current variables now if you need.\n',...
           'Then, quit by ''dbquit''\n']);
  keyboard;
  rmpath(genpath(fullfile(rootDir,'..','Common')));
  rmpath(fullfile(rootDir,'..','gamma_table'));
  rmpath(fullfile(rootDir,'..','Generation'));
  %psychrethrow(psychlasterror);
  close all; clear global; clear mex; clear all;
  return
end % try..catch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% That's it - we're done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return
% end % function StereoMEGsample
