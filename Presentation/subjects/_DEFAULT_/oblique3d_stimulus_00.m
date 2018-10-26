% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-10-09 15:47:09 ban"
% Last Update: "2018-10-14 11:51:47 ban"
% ************************************************************

%%% the exp_id=0 is just for test to see whether the 3D stimuli are presented in a right way.

% "sparam" means "stimulus generation parameters"

%%% load the common parameters
run(fullfile(fileparts(mfilename('fullpath')),'oblique3d_stimulus_common'));


%%% overwrite some parameters specific to this configuration.

% slopes/orientations of slants & gratings
sparam.theta_deg    = [-52.5, -37.5]; % angle of the slant in deg, negative = top is near
sparam.orient_deg   = [   90,    90]; % tilted orientation of the slant in deg
sparam.mask_type    = { 'xy',  'xy'}; % 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent
sparam.mask_orient_id=[    1,     1]; % % ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...
