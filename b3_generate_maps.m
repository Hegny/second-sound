clear;

mesh_size = 10;

angle_step = 0.5; % 1 deg -> 1,8mm for equator %180 deg -> 325 mm for equator 
height_step = 1; %mm

height_zero = 5; % h =0 at equator 5

%% name of cavity config file

cavity = 'CAV00681t3';
%cavity = 'CAV00681t2'; 
% cavity = 'CAV00518t3'; 
% cavity = 'CAV00087t1';
% cavity = 'CAV00518t5';


%%
cavity_dir = 'cavity/';
load_name = strcat(cavity);
cavity_name = strcat(cavity_dir, load_name,'.mat');

save_dir = 'temp/';
save_name = strcat('map_',int2str(mesh_size),'_', cavity);
save_name = strcat(save_dir, save_name,'.mat');

load(cavity_name, 'cavity', 'OST', 'comment');
%%

show = 0;
disp(['Mesh size: ' num2str(mesh_size)]);
disp('Building maps...');


for i=1:size(OST, 1)
    
    
    OST_distance_from_equator = OST(i, 2);
    OST_height_raw = OST(i, 4);
    OST_angle = OST(i, 3);
    OST_number = OST(i, 1);
    
    disp(['OST# ' int2str(OST_number)]);
  %  tic;
    trace_OST_v4( OST_distance_from_equator, OST_height_raw, mesh_size, height_zero, show );
    
    [map(OST_number,:,:) Z Angle ]= generate_maps_for_OST(OST_distance_from_equator,OST_height_raw,OST_angle, angle_step, height_step, mesh_size );
  %  toc;
    disp(' ');
    
end;

disp('Done');

%save temp/map_10_CAV00518t5 map Z Angle mesh_size height_step angle_step

%CAV00087
save(save_name, 'map', 'Z', 'Angle', 'mesh_size', 'height_step', 'angle_step');
%save temp/map_10_CAV00518t5 map Z Angle mesh_size height_step angle_step