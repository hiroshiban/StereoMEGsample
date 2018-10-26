% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-10-09 15:47:27 ban"
% Last Update: "2018-10-15 10:37:04 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% load the common parameters
run(fullfile(fileparts(mfilename('fullpath')),'oblique3d_stimulus_common'));

%%% overwrite some parameters specific to this configuration.

sparam.theta_deg    = sparam.theta_deg(1:1:8);
sparam.orient_deg   = sparam.orient_deg(1:1:8);
sparam.mask_type    = sparam.mask_type(1:1:8);
sparam.mask_orient_id=sparam.mask_orient_id(1:1:8);
