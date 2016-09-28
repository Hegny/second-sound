clear;

mesh_size = 40; %mm

r = 35; %mm diametr of iris
%visualization
show_loaded = 1;
show_point = 45; %show point during graph building % shows only rays and neighbours to the points with higher ID
% to visualize all rays for point use utility utils_show_rays.m

angle_thr = 10;%10; %deg

%distance_to_neighbour = 1.7*30;

%alpha = l/r;
max_distance = 2*r*(sin(mesh_size/r));
distance_to_neighbour = max_distance*0.85;%95;

disp(['Mesh size: ' int2str(mesh_size) ' mm']);
disp(['Neighbour distance: ' num2str(distance_to_neighbour)]);

load_dir = 'meshes/';

load_name = strcat('mesh_',int2str(mesh_size),'mm');
load_name = strcat(load_dir, load_name,'.mat');

save_dir = 'graphs/';
save_name = strcat('graph_',int2str(mesh_size),'mm');
save_name = strcat(save_dir, save_name,'.mat');


disp(['Loading...']);

load(load_name, 'mesh', 'triangles', 'inner_mesh', 'top');
%load 'meshes/mesh_40mm';




disp('Mesh loaded.');
disp(['Points: ' int2str(length(mesh))]);
disp(['Triangles: ' int2str(length(triangles))]);

%% show loaded mesh

if (show_loaded)
    figure;
    trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3));
      hold on;
      axis equal;
    % show normals       
%     normal_length = 7; %scale the normal for plotting
%      for i=1:length(mesh)
%         x = [mesh(i,1) mesh(i,1)+normal_length*mesh(i,4)];
%         y = [mesh(i,2) mesh(i,2)+normal_length*mesh(i,5)];
%         z = [mesh(i,3) mesh(i,3)+normal_length*mesh(i,6)];
% 
%         plot3(x, y, z);    
% 
% 
%      end   
 
end; %show_loaded


 %% build graph
 disp('Building graph...');
 tic;
 save_every_points = 0; %for long-time calculation result will be saved after every n points in temp file. Delete temp file before starting. Use 0 to disable this feature.
rays = build_graph_v7([mesh(:,1) mesh(:,2) mesh(:,3)], [mesh(:,4) mesh(:,5) mesh(:,6)], triangles, inner_mesh(:,1:3), top, angle_thr, distance_to_neighbour, show_point, save_every_points);
%rays = build_graph_v6([mesh(:,1) mesh(:,2) mesh(:,3)], [mesh(:,4) mesh(:,5) mesh(:,6)], triangles, inner_mesh(:,1:3), top, angle_thr, distance_to_neighbour, show_point);
toc;
disp('Graph built');
disp(['Links found: ' int2str(length(rays))]);

%% check for duplicating links
 disp('Checking for duplicating links...');
  tic;
rays = graph_check_for_double(rays);
toc;
disp(['Links found: ' int2str(length(rays))]);

%save graph_40mm rays;
save(save_name, 'rays');