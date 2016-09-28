%v2 - inner triangles replaced by inner mesh


clear;


threshold = 5; %desired distance between points in mm
step = 0.001; 
inner_mesh_distance = 0.01; % 

% height of half_cell
top=57.7;
curve_length = 98.5; %mm

dir = 'meshes/';
save_name = strcat('mesh_',num2str(threshold),'mm');
save_name = strcat(dir, save_name,'.mat');

y=[0:step:top];

x=curve(y); %here are all points

%                     plot(x, y, 'b.', 'MarkerSize',2); hold on;
%grid on;
%select points
xx(1)=x(1);
yy(1)=y(1);
distance(1) = 0; %distance between point(n) and point(n-1);
deviation(1) = 0; %abs(distance-threshold);

%add normal for first point
n(1,:)=[1 0 0]; %normals

counter = 1; %last selected point

map_z = [0]; %z coordinate for map, add first point
%select points with distance near threshold
while (norm([x(length(x))-xx(length(xx)) y(length(y))-yy(length(yy))]) > threshold) %while distance last(x) and last(xx) > threshold
    
    %selected_points
    
    for i = counter+1 : min([ counter+ceil(threshold/step) length(y)])     %start from counter and chek next threshold/step points
        dist(i - counter) = norm([x(i)-xx(length(xx)) y(i)-yy(length(yy))]);
        dev(i - counter) =  abs(dist(i - counter) - threshold);
        
        % distance = [distance abs(norm([x(i)-xx(length(xx)) y(i)-yy(length(yy))]) - threshold)];
    end
    [m, k]  = min(dev);
    counter = k+counter;
    xx = [xx x(counter)];
    yy = [yy y(counter)];
    deviation = [deviation m];
    distance = [distance dist(k)];
 %v3  
 %map_z
     if(isempty(map_z))
         p_dist = 0;
     else
         p_dist = map_z(length(map_z));
     end;
    map_z = [map_z; p_dist+dist(k)];
  
  %calculate normal for this point
   a = [x(counter+1)-x(counter-1) y(counter+1)-y(counter-1) 0] ;
   normal=a./norm(a);
   n =[n; normal(2) -normal(1) normal(3)];
end

map_z = [map_z; curve_length]; %add last point

%add last point
distance = [distance norm([x(length(y))-xx(length(xx)) y(length(y))-yy(length(yy))])];
deviation = [deviation abs(norm([x(length(y))-xx(length(xx)) y(length(y))-yy(length(yy))]) - threshold)];

%add last point
xx = [xx x(length(y))];
yy = [yy y(length(y))];

%add normal for last point
n=[n; 1 0 0];


z = zeros(length(xx),1);
%format: point_x point_y point_z normal_x normal_y normal_z 
points=[xx' z yy'  n(:,1) n(:,3) n(:,2) map_z];

%% now points contains points with distance near threshold and their normals
% but only flat curve

inner_points = points;
inner_points(:,1) = inner_points(:,1) - inner_mesh_distance;

%% rotating the curve

mesh = [];
inner_mesh = [];

[mesh map]= rotate_curve_v2( points, threshold );
[inner_mesh inner_map] = rotate_curve_v2( inner_points, threshold );

%%
%add mirror part

[mesh_flipped top_row] = flip_mesh( mesh, top );
[inner_mesh_flipped not_used] = flip_mesh( inner_mesh, top );

map_flipped = flip_map( map, top_row, curve_length )

map = [map; map_flipped];

%%
tri = delaunay(mesh(:,1),mesh(:,2));

%remove artefacts
%find triangles with only top points
triangles = tri_remove_artefacts(tri, top_row); %sorted triangles from tri

%%
%counter part of triangles
tri_flipped = tri_connect(triangles, top_row, length(mesh));

triangles = [triangles; tri_flipped]; %full list of triangles
mesh =[mesh; mesh_flipped]; % full list of points and normals
inner_mesh =[inner_mesh; inner_mesh_flipped];

%%

 figure;

 %trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3));
     trimesh(triangles,inner_mesh(:,1),inner_mesh(:,2),inner_mesh(:,3));
   hold on;
%   axis equal;

%%


disp(['Points: ' int2str(length(mesh))]);
disp(['Triangles: ' int2str(length(triangles))]);

%% show
% figure;

 %trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3));
    trimesh(triangles,mesh(:,1),mesh(:,2),mesh(:,3));
  hold on;


%plot3(mesh(:,1), mesh(:,2), mesh(:,3), 'ro', 'MarkerSize',2);
hold on;
                     
%plot3(points(:,4)+points(:,1), points(:,5)+points(:,2), points(:,6)+points(:,3),  'b.', 'MarkerSize',5)
axis equal;
                     
% show normals       
normal_length = 5; %scale the normal for plotting
 for i=1:length(mesh)
    x = [mesh(i,1) mesh(i,1)+normal_length*mesh(i,4)];
    y = [mesh(i,2) mesh(i,2)+normal_length*mesh(i,5)];
    z = [mesh(i,3) mesh(i,3)+normal_length*mesh(i,6)];
   
    plot3(x, y, z);    
     
   
 end    

%for i=1:length(xx)  
%   text(xx(i), yy(i), num2str(i));
%end   
 
%figure; plot(deviation);
%figure; plot(distance);


% fid = fopen('points.txt', 'w'); 
% if fid == -1 
%     error('File is not opened'); 
% end 
%   
% fprintf(fid, '%.4f;%.4f\r\n', zz'); 
% fclose(fid);
% 
% 
save(save_name, 'mesh', 'triangles', 'inner_mesh', 'top', 'map');

disp(['Mesh saved in file: ' save_name]);
