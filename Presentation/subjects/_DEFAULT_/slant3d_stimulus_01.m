% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-10-09 15:47:27 ban"
% Last Update: "2018-10-15 11:31:35 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% load the common parameters
run(fullfile(fileparts(mfilename('fullpath')),'slant3d_stimulus_common'));

%%% overwrite some parameters specific to this configuration.

sparam.theta_deg    = sparam.theta_deg([1,3,5,7,9,11,13,16,18,20]);
sparam.orient_deg   = sparam.orient_deg([1,3,5,7,9,11,13,16,18,20]);
sparam.mask_type    = sparam.mask_type([1,3,5,7,9,11,13,16,18,20]);
sparam.mask_orient_id=sparam.mask_orient_id([1,3,5,7,9,11,13,16,18,20]);

% the stimulus selection above corresponds to the conditions below, which is exactly the same order with the fMRI scans (Ban and Welchman 2015 JNS)
% sparam.theta_deg    = [ -52.5, -22.5,   7.5,  37.5, -52.5, -22.5,  37.5, -22.5,   7.5,  37.5];
% sparam.orient_deg   = [    90,    90,    90,    90,    90,    90,    90,    90,    90,    90];
% sparam.mask_type    = {   'n',   'n',   'n',   'n',   'z',   'z',   'z',  'xy',  'xy',  'xy'};
% sparam.mask_orient_id=[     1,     1,     1,     1,     1,     1,     1,     1,     1,     1];
