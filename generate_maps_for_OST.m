function [ rotated_map, map_z, map_angle] = generate_maps_for_OST(OST_distance_from_equator,OST_height_raw,OST_angle, angle_step, height_step, mesh_size )
%GENERATE_MAPS_FOR_OST Summary of this function goes here

% mesh_size = 10; %mm

% OST_distance_from_equator = 89; % mm
% OST_height_raw = -459;
% OST_angle = 270;

curve_length = 98.5;

%% config

% angle_step = 0.5; % 1 deg -> 1,8mm for equator %180 deg -> 325 mm for equator 
% height_step = 1;

angle_aspect = 1.8;

%% load

mesh_dir = 'meshes/';
map_dir = 'raw_maps/';

load_name = strcat('mesh_',int2str(mesh_size),'mm');
mesh_name = strcat(mesh_dir, load_name,'.mat');

load_name = strcat('raw_map_',int2str(mesh_size),'mm_', int2str(OST_height_raw), '_', int2str(OST_distance_from_equator));
map_name = strcat(map_dir, load_name,'.mat');

load(mesh_name, 'mesh', 'triangles', 'inner_mesh', 'top', 'map');

load(map_name, 'OST', 'Distances', 'Path');
%load temp/map_40mm;


h_OBACHT = OST_height_raw+8*top;


%% building the map

map_angle = [];
map_z =[];
map_distance = [];

for cell = 1:10

%cell = 1;

dist = Distances(:, cell);

z = map(:,1);
angle = map(:,2);

%%

%plot3(angle, z, dist, 'b*')

%surf(angle, z, dist)
% Angle = 0:10:180;
% Z = 0:10:300;

z_shift = (cell-1)*2*curve_length;
[Angle, Z] = meshgrid(0:angle_step:180, 0:height_step:2*curve_length);
%z_shift:5:z_shift+2*curve_length
V = griddata(angle, z, dist, Angle, Z);%, 'v4');

Z = Z+z_shift;
map_distance = [map_distance; V];
map_z = [map_z; Z];
map_angle = [map_angle; Angle];
end;

% now the half of the map is done

%% map contains also half cells on top and bottom
%cut it out

cut_out = round(curve_length/height_step);

%cut_out
offset = cut_out*height_step;
map_z = map_z(cut_out+1:end-cut_out,:)-curve_length;

map_angle = map_angle(cut_out+1:end-cut_out,:);
map_distance = map_distance(cut_out+1:end-cut_out,:);

%% adding the mirror part

flip_z = map_z(:,2:end-1); % not to put points for 0 and 180 deg
flip_angle = map_angle(:, 2:end-1)+180;
flip_distance = fliplr(map_distance(:, 2:end-1));

map_distance = [map_distance flip_distance];
map_angle = [map_angle flip_angle];
map_z = [map_z flip_z ];

%% rotate the map on OST angle
rotate_columnes = round(OST_angle/angle_step);
rotated_map = [map_distance(:,end-rotate_columnes+1:end) map_distance(:,1:end-rotate_columnes)];


%figure;
% hold on;
% %mesh(Angle, Z, V);
% 
% plot3(angle, z, dist, 'o')
% plot3(Angle, Z, V, 'k.')
% 
% figure
%imagesc(map_distance);

max_angle = 360;
max_z = round(18*curve_length);

ticks = [' I1'; ' E1'; ' I2'; ' E2'; ' I3'; ' E3'; ' I4'; ' E4'; ' I5'; ' E5'; ' I6'; ' E6'; ' I7'; ' E7'; ' I8'; ' E8'; ' I9'; ' E9'; 'I10'];

figure;

imagesc([0 max_angle], [0 max_z], rotated_map);

title (['Distance map for OST ' 'a=' num2str(OST_angle) 'deg r=' num2str(OST_distance_from_equator) 'mm h=' num2str(h_OBACHT) 'mm']);
xlabel('angle, deg');
ylabel('z along surface');
zlabel('distance, mm');
axis equal;

set(gca,...
    'XLim', [0 max_angle],...
    'XTick', [0:90:max_angle],...
    'YLim', [0 max_z],...
    'YTick', [0:curve_length:max_z],...
    'YTickLabel', ticks,...
    'DataAspectRatio',[1 angle_aspect 1])

grid on
    
%  xlim([0 max_angle]);
%  ylim([0 max_z]);
 
h = colorbar;
ylabel(h,'Distance from OST, mm');


end

