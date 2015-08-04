addpath('../');
%% Run demo: Humanizing the song Billie Jean
% the demo folder is part of the Humanizer package and contains
% humanizer_script_demo.m
% org_BillieJean_core.txt
% org_BillieJean.mid
% org_bj_footer.txt
% org_bj_header.txt

%% enter path to demo folder
% The Humanizer will write the humanized song (and if verbose=1 also other files) into the demo folder
cd /Users/xavierriley/Projects/humanizer/demo

% place mf2t and t2mf in your bin folder and add path to bin
setenv('PATH',[getenv('PATH') ':/Users/holgerh/bin/'])

%% enter path to input file org_BillieJean_core.txt. The files org_bj_footer.txt and org_bj_header.txt need to be in the same folder
filename = 'org/org_BillieJean_core.txt'; 

%% input parameters (optional)
sigma = 15; % standard deviation of delays in ms
alpha = 0.9; % fractal exponent
type = 4; % humanizing type. type=1: Group humanize: Coupling the time series using two-component ARFIMA process
seed = round(10*sigma); % for reproducible results
verbose=0; % verbose=1: write misc files to disk

[notes_humanized, seed, sort_ind] = humanizer(filename,sigma,alpha,type,seed,verbose);


