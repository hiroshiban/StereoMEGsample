% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-10-09 15:47:27 ban"
% Last Update: "2018-10-30 09:28:15 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% stimulus presentation mode
sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
sparam.give_feedback=false;    % true or false. if true, feedback (whether the response is correct or not) is given
sparam.task_interval=4:6;      % frequency of the depth discrimination task, the task occurs every sparam.task_interval(1)-sparam.task_interval(end) (randomly selected) trials

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
%                          1. an intersection/mean of the -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
%                          2. an intersection/mean of the -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
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
% sparam.mask_orient_id=[     1,     1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1,    1,      1,     1,     1,     1,     1];
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

sparam.aperture_deg = 10;   % size of circular aperture in deg
sparam.fill_val     = 0;    % value to fill the 'hole' of the circular aperture
sparam.outer_val    = 0;    % value to fill the outer region of slant field

%%% RDS parameters
sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
sparam.dotDens=2; % density of dot in RDS image (1-100)
sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]

% the number of trials per condition
sparam.numTrials=20;

%%% stimulus display durations etc in 'msec'
sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
sparam.condition_duration=1300;   % duration in msec for each condition, integer (msec)
sparam.stim_on_probe_duration=[100,500]; % durations in msec for presenting a probe before the actual stimulus presentation (msec) [duration_of_red_fixation,duration_of_waiting]. if [0,0], the probe is ignored.
sparam.stim_on_duration=300;      % duration in msec for simulus ON period for each trial, integer (msec)
sparam.response_duration=1500;    % duration in msec for response, integer (msec)
sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
sparam.BetweenDuration=500;       % duration in msec between trials, integer (msec)

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
