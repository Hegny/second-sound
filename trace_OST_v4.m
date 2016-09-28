function [ output_args ] = trace_OST_v4(OST_distance_from_equator, OST_height_raw, mesh_size, height_zero, show );
%v3 - fixed connecting with cells lower OST

%v4 - added OST_radius from outside

%clear;

OST_radius = 3.5; %mm
disp(['OST radius: ' num2str(OST_radius) ' mm']);

show_rays = 0;

 cells = 10; %how many cells up to calculate (10 for full cavity)
 
% height_zero = 5; %put height zero infront of equator #5

graph_dir = 'graphs/';
mesh_dir = 'meshes/';

map_dir = 'raw_maps/';

load_name = strcat('graph_',int2str(mesh_size),'mm');
graph_name = strcat(graph_dir, load_name,'.mat');

load_name = strcat('mesh_',int2str(mesh_size),'mm');
mesh_name = strcat(mesh_dir, load_name,'.mat');

load(graph_name, 'rays');
load(mesh_name, 'mesh', 'triangles', 'inner_mesh', 'top');



% load 'make_shape/mesh_15mm';
% load 'graph_15mm';

%OST coordinates
OST = [0 0 0];
OST_normal = [0 -1 0];

tesla_r = 103.3; %radius of Equator
angle_thr = 5;

 height_zero_offset= (1+height_zero)*2*top;
 


OST_height = height_zero_offset+OST_height_raw;
%%

OST(2)=tesla_r+OST_distance_from_equator;
OST(3)=OST_height;

if(show)

figure;

%  trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3));
%       hold on;

      
 plot3(OST(1), OST(2), OST(3), 'r*');   
 
hold on;
 
end;
 %%
  % find coincident points in top and bottom rows for connecting between cells
 c_points = coincident_points( mesh(:,1:3)); %[bottom top]
 

 
 
 Distances = zeros(size(mesh,1), cells);
 Path = zeros(size(mesh,1), cells);
%  
%  bar = waitbar(0,'0%', 'Name','Calculating distances','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
%  
%  setappdata(bar,'canceling',0);
 bar = waitbar(0,'0%', 'Name','Calculating distances');
 
 tic;
 
%%
cells_up = ceil(cells-height_zero-OST_height_raw/(2*top));
%cells_up = ceil(cells-height_zero-(-480)/(2*top));
if(cells_up<0)
    cells_up=0;
end;
%cells_up
cells_down = cells-cells_up;

cell_numer = cells-cells_up+1;

%cells_up = cells;
 
 %%
 %calculating cells upper OST
 if(cells_up>0)
 %    cell_numer = cells-cells_up+1;
     for cell = 1:cells_up
        % Check for Cancel button press
%         if getappdata(bar,'canceling')
%             break
%         end 
         
        z_shift = (cell-1)*2*top+cell_numer*2*top; %shift of mesh
        OST(3) = OST_height-z_shift;
         
        

        Graph = visible_from_OST_v2( OST, OST_normal, mesh, angle_thr, triangles, rays, z_shift, show_rays, show ); 



        initial_distances = zeros(size(mesh,1), 1); 

        % check which row to use as initial dist. if new cell is above the OST
        % - use top row from previous cell, else use low row from previous cell
        if(cell>1)

          for k=1:length( c_points)

              initial_distances( c_points(k, 1)) = Distances( c_points(k, 2), cell_numer+cell-2);

          end;

        end; %if cell
      %  initial_distances 
 %       [Dist P] = process_graph_with_initial_distances( Graph, mesh(:,1:3),  OST, initial_distances, 1 ); 
        [Dist P] = process_graph_with_initial_distances_and_OST_size_v2( Graph, mesh(:,1:3),  OST, OST_normal, initial_distances, show, OST_radius);
        
        Distances(:, cell_numer+cell-1) = Dist;
        Path(:, cell) = P;
         if(show)
             trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3)+z_shift, Dist);
             disp(' ');
         end;
       waitbar(cell/cells, bar, sprintf('%d %%', 100*(cell)/cells));
      %  Distances
         
     end;  
 end;% if cells_up
 
 %% 
  %calculating cells lower OST
   if(cells_down>0)
     cell_numer = cell_numer;%-1;
     %%
     for cell = 1:cells_down
        % Check for Cancel button press
%         if getappdata(bar,'canceling')
%             break
%         end          
         
        z_shift = (cell)*2*top;
        OST(3) = OST_height-cell_numer*2*top+z_shift    ;    

        Graph = visible_from_OST_v2( OST, OST_normal, mesh, angle_thr, triangles, rays, cell_numer*2*top-z_shift, show_rays, show ); 

       initial_distances = zeros(size(mesh,1), 1); 
       
       for k=1:length( c_points)

              initial_distances( c_points(k, 2)) = Distances( c_points(k, 1), cell_numer-cell+1);

       end;
     %   [Dist P] = process_graph_with_initial_distances( Graph, mesh(:,1:3),  OST, initial_distances, 1 ); 
        [Dist P] = process_graph_with_initial_distances_and_OST_size_v2( Graph, mesh(:,1:3),  OST, OST_normal, initial_distances, show, OST_radius );
        Distances(:, cell_numer-cell) = Dist;
        Path(:, cell) = P;
         if(show)
             trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3)+cell_numer*2*top-z_shift, Dist);
             disp(' ');
         end;
       waitbar((cell+cells_up)/cells, bar, sprintf('%d %%', 100*(cell+cells_up)/cells));
      %  Distances
                
         
         
     end;
   end;
  
  
 %%
 toc;
 delete(bar) ;
 
 if(show)
  axis equal;
 end;
 %add OST to main graph
% Graph = visible_from_OST( OST, OST_normal, mesh, angle_thr, triangles, rays );
% 
% 
% initial_distances = zeros(size(mesh,1), 1);


%% find coincident points in top and bottom rows for connecting between cells
% coincident_points( mesh(:,1:3))


%% here the distances are calculated

% [Distances Path] = process_graph_with_initial_distances( Graph, mesh(:,1:3),  OST, initial_distances );
% 
% Distances

save_name = strcat('raw_map_',int2str(mesh_size),'mm_', int2str(OST_height_raw), '_', int2str(OST_distance_from_equator));
save_name = strcat(map_dir, save_name,'.mat');

save(save_name, 'Distances', 'Path', 'OST', 'mesh_size');
% save temp/map_15mm Distances Path OST;
end

