% ************************************************************
% This_is_the_display_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% SlantfMRI.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2019-02-19 19:08:12 ban"
% ************************************************************

% "dparam" means "display-setting parameters"

%%% display mode
% one of "mono", "dual", "dualparallel", "dualcross", "cross", "parallel", "redgreen", "greenred",
% "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn"
dparam.ExpMode='dualparallel';

dparam.scrID=1; % screen ID, generally 0 for a single display setup, 1 for dual display setup

%%% a method to start stimulus presentation
% 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (CiNet),
% 3:waiting for a MR trigger pulse (BUIC) -- checking onset of pin #11 of the parallel port,
% or 4:custom key trigger (wait for a key input that you specify as tgt_key).
dparam.start_method=0;

%%% a pseudo trigger key from the MR scanner when it starts, only valid when dparam.start_method=4;
dparam.custom_trigger=KbName(84); % 't' is a default trigger code from MR scanner at CiNet

dparam.Key1=37; % 37 is left-arrow on default Windows
dparam.Key2=39; % 39 is right-arrow on default Windows

%%% screen settings

%%% whether displaying the stimuli in full-screen mode or as is (the precise resolution), true or false (true)
dparam.fullscr=false;

%%% the resolution of the screen height, integer (1024)
dparam.ScrHeight=1440; %1024; %1200;

%% the resolution of the screen width, integer (1280)
dparam.ScrWidth=2560; %1280; %1920;

% shift the screen center position along y-axis (to prevent the occlusion of the stimuli due to the coil)
dparam.yshift=0;

% whther skipping the PTB's vertical-sync signal test. if 1, the sync test is skipped
dparam.skip_sync_test=0;
