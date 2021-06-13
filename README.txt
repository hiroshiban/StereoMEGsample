****************************************
About Slant 3D experiment

Created    : "2018-10-04 15:21:12 ban"
Last Update: "2021-06-13 22:09:06 ban"
****************************************

- This is a sample MATLAB Psychtoolbox-3 (PTB3) script for MEG experiment on 3D vision.
- Displays 3D slant consisted of Random-Dot-Stereogram (RDS) with horizontal
  binocular disparities.
- Used for psychophysical measurementss of perceptual oblique effects in 3D scene.
- Participant's task is to discriminate which direction the circular RDS objects
  is slanted (top-near: key1 or top-far: key2), when the central fixation is red.
- The task trial (with a red central fixation) occurs every 3-5 trials.
- During the trials in which the central fixation is white, participants have to
  refrain from blinking and concentrate on seeing the slanted surfaces.
- In the task trials in which the central fixation marker is red, participants
  can blink as they like.
- This script shoud be run with MATLAB Psychtoolbox version 3 or above.
- Stimulus presentation timing are controled by using GetSecs() function
  (this is internally equivalent to Windows multimedia timer), not by waiting
  vertical blanking of the display.
- Stimulus (trial) onsets and the MEG measurements were synchronized and aligned
  offline based on the photo-trigger signals recorded at the upper-right corner
  of the display in the MEG room.

[how to run the script]
1. On the MATLAB shell, please change the working directory to
   ~/StereoMEGsample/Presentation/
2. Run the "run_exp" script
   >> run_exp('subj_name',1);
   Here, the first input variable is subject name or ID, such as 'HB' or 's01',
   the second variable should be 1 or 2,

For more details, please see the documents in StereoMEGsample.m
Also please see the parameter files in ~/StereoMEGsample/Presentation/subj/_DEFAULT_

[input variables]
sujID         : ID of subject, string, such as 'HB', 's01', etc.
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
                !!! if 'debug' (case insensitive) is included          !!!
                !!! in subjID string, this program runs as DEBUG mode; !!!
                !!! stimulus images are saved as *.png format at       !!!
                !!! ~/CurvatureShading/Presentation/images             !!!
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
acq           : acquisition number (design file number),
                an integer, such as 1, 2, 3, ...
displayfile   : (optional) display condition file,
                *.m file, such as 'oblique3d_display_fmri.m'
                the file should be located in ./subjects/(subj)/
stimulusfile  : (optional) stimulus condition file,
                *.m file, such as 'oblique3d_stimulus_exp1.m'
                the file should be located in ./subjects/(subj)/
gamma_table   : (optional) table(s) of gamma-corrected video input values (Color LookupTable).
                256(8-bits) x 3(RGB) x 1(or 2,3,... when using multiple displays) matrix
                or a *.mat file specified with a relative path format. e.g. '/gamma_table/gamma1.mat'
                The *.mat should include a variable named "gamma_table" consists of a 256x3xN matrix.
                if you use multiple (more than 1) displays and set a 256x3x1 gamma-table, the same
                table will be applied to all displays. if the number of displays and gamma tables
                are different (e.g. you have 3 displays and 256x3x!2! gamma-tables), the last
                gamma_table will be applied to the second and third displays.
                if empty, normalized gamma table (repmat(linspace(0.0,1.0,256),3,1)) will be applied.
overwrite_flg : (optional) whether overwriting pre-existing result file. if 1, the previous results
                file with the same acquisition number will be overwritten by the previous one.
                if 0, the existing file will be backed-up by adding a prefix '_old' at the tail
                of the file. 0 by default.
force_proceed_flag : (optional) whether proceeding stimulus presentatin without waiting for
                the experimenter response (e.g. presesing the ENTER key) or a trigger.
                if 1, the stimulus presentation will be automatically carried on.


[output variables]
no output matlab variable.


[output files]
1. behavioral result
   stored ./subjects/(subjID)/results/(today)
   as ./subjects/(subjID)/results/(today)/(subjID)_Slant3D_MEG_results_run_(run_num).mat


[example]
>> StereoMEGsample('s01',1,'oblique3d_display.m','oblique3d_stimulus_exp1.m')


[About displayfile]
The contents of the displayfile is as below.
(The file includs 6 lines of headers and following display parameters)

(an example of the displayfile)

% ************************************************************
% This_is_the_display_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% SlantfMRI.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-06-10 01:36:09 ban"
% ************************************************************

% "dparam" means "display-setting parameters"

%%% display mode
% display mode, one of "mono", "dual", "dualcross", "dualparallel", "cross", "parallel", "redgreen", "greenred",
% "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn", "propixxmono", "propixxstereo"
dparam.ExpMode='shutter';

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

% whther skipping the PTB's vertical-sync signal test. if 1, the sync test is skipped
dparam.skip_sync_test=0;


[About stimulusfile]
The contents of the stimulusfile is as below.
(The file includs 6 lines of headers and following stimulus parameters)

(an example of the stimulusfile)

% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% StereoMEGsample.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-06-10 01:36:09 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% stimulus presentation mode
sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
sparam.give_feedback=false;    % true or false. if true, feedback (whether the response is correct or not) is given
sparam.task_interval=4:6;      % frequency the depth discrimination task, the task occurs every sparam.task_interval trials

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
sparam.mask_orient_deg  = 90; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW

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
sparam.orient_deg   = sparam.orient_deg(1:2:numel(sparam.theta_deg));
sparam.mask_type    = sparam.mask_type(1:2:numel(sparam.theta_deg));

sparam.aperture_deg = 10;   % size of circular aperture in deg
sparam.fill_val     = 0;   % value to fill the 'hole' of the circular aperture
sparam.outer_val    = 0;   % value to fill the outer region of slant field

%%% RDS parameters
sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
sparam.dotDens=2; % deinsity of dot in RDS image (1-100)
sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]

% the number of trials
sparam.numTrials=10;

%%% stimulus display durations etc in 'msec'
sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
sparam.condition_duration=1300;   % duration in msec for each condition, integer (msec)
sparam.stim_on_probe_duration=[100,100]; % durations in msec for presenting a probe before the actual stimulus presentation (msec) [duration_of_red_fixation,duration_of_waiting]. if [0,0], the probe is ignored.
sparam.stim_on_duration=300;      % duration in msec for simulus ON period for each trial, integer (msec)
sparam.response_duration=1500;    % duration in msec for response, integer (msec)
sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
sparam.BetweenDuration=1000;      % duration in msec between trials, integer (msec)

%%% background color
sparam.bgcolor=[128,128,128];

%%% fixation size and color
sparam.fixsize=18;        % the whole size (a circular hole) of the fixation cross in pixel
sparam.fixlinesize=[9,2]; % [height,width] of the fixation line in pixel
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
run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));
%sparam.ipd=6.4;
%sparam.pix_per_cm=57.1429;
%sparam.vdist=65;


[HOWTO create stimulus files]
1. All of the stimuli are created in this script in real-time
   with MATLAB scripts & functions.
   see ../Generation & ../Common directries.
2. Stimulus parameters are defined in the display & stimulus file.


[about stimuli and task]
Stimuli are presented by default as below
stim 1-1(1000ms) -- blank(1000ms) -- between trial duration (1000-1500ms) --
stim 2-1(1000ms) -- blank(1000ms) -- between trial duration (1000-1500ms) --
...(continued)...

Observer's task is to discriminate which direction the target slant stimulus is tilted
press key 1 when the slant's top side is to near (top-near)
press key 2 when the slant's top side is to far (top-far)


[about feedback]
If sparam.give_feedback is set to 'true', correct/incorrect feedback is given to observer in each task trial.
Correct  : Green Fixation with a high-tone sound
Incorrect: Blue Fixation with a low-tone sound


[reference]
- Ban, H. & Welchman, A.E. (2015).
  fMRI analysis-by-synthesis reveals a dorsal hierarchy that extracts surface slant.
  The Journal of Neuroscience, 35(27), 9823-9835.
- for stmulus generation, see ../Generation & ../Common directories.
