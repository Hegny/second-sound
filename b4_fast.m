clear;
mesh_size = 10;

cavity_name = 'CAV00681';
test_name = '3';

cavity = 'CAV00681t3';

%%
cavity_dir = 'cavity/';
load_name = strcat(cavity);
cavity_n = strcat(cavity_dir, load_name,'.mat');


load(cavity_n, 'cavity', 'OST', 'comment');

temp_dir = 'temp/';
temp_name = strcat('map_',int2str(mesh_size),'_', cavity);
temp_name = strcat(temp_dir, temp_name,'.mat');

load(temp_name);
%%
ss_vel = 19.9; % second sound velocity in m/s (or mm/ms)

time_thr = 60; %ms do not use OST with higher delay
time_minimum = 0;
distance_offset = 0; %0

%thr = 35;%55; %for color
speed_rmse_thr = 5; % for color


time_error = 0.1;%ms for errorbar




%load temp/map_10_CAV00681t2;
%%
curve_length = round(98.5);


%%

% finding errors from speed
deviation = [];
m = size(map,2);
n = size(map, 3);
kai = zeros(m,n);
OST_used = 0;
for i=1:size(OST,1)
            
            OST_nummer = OST(i, 1);
            OST_time = OST(i, 5);   
            
            if( OST_time< time_thr)&&(OST_time>time_minimum)
                    OST_used = OST_used +1;

                    dev =  squeeze(map(OST_nummer, :,:)-(OST_time*ss_vel));
                    dev(abs(dev)<(time_error*ss_vel))=0;
                    deviation(OST_nummer,:,:) = dev;      

                    kai = kai+(dev.*dev);
            end;
end;
kai = sqrt(kai/OST_used);
%%
%combinations

%preliminary coordinates of the quench
[h,w] = find(kai==min(abs(kai(:))));

h_orig = h;
w_orig = w;



%% deviation thresholds
thr = 10;
result = kai;
result(result>thr) = thr;

% map of maximal deviations
% deviation_max = squeeze(max(abs(deviation)));
% deviation_max(deviation_max>0.5*thr) = 0.5*thr;

% result(result<thr) = 0;
% result(result>thr) = 1;

% figure
%c_map = colormap(flipud(jet(64)));
c_map = flipud(jet(64));
c_map = c_map(1:56,:);

%% red/white color map
% red_white=[1, 0, 0; 1, 1, 1]
% c_map = colormap(red_white)


% imagesc(result)
% colorbar
% colormap(c_map);

%%

z_start = 1385; %min 0
z_stop = 1782; % max1782
z_step = 1;

phi_start = 0; %180;% start plot from angle(deg). min 0 max 359
phi_stop = 359; %;359;
phi_step = 1;

angle_aspect = 1.8*phi_step/z_step;

phi_start=round(phi_start/angle_step)+1;
phi_stop = round(phi_stop/angle_step);
phi_step = round(phi_step/angle_step);

z_start = round(z_start/height_step)+1; 
z_stop = round(z_stop/height_step);%1782;
z_step = round(z_step/height_step);


%%
show_result_map_v2( result(z_start:z_step:z_stop, phi_start:phi_step:phi_stop), angle_step, angle_aspect,  phi_start, phi_stop, phi_step, z_start, z_stop, z_step, c_map, cavity_name, test_name, mesh_size, OST_used, time_thr, time_minimum );
%%
%show_result_map_v2( r3(z_start:z_step:z_stop, phi_start:phi_step:phi_stop), angle_step, angle_aspect,  phi_start, phi_stop, phi_step, z_start, z_stop, z_step, c_map, cavity_name, test_name, mesh_size, OST_used, time_thr, time_minimum );