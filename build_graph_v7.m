function Rays = build_graph_v7(Points, Normals, Triangles, Inner_mesh, top, angle_thr, distance_to_neighbour, show_point, save_every_points)
% Points - points (x y z)
% Normals - normal vectors (x y z)for points
% Triangles - triangles (point1ID point2ID point3ID)

%v3 - with checking of Inner_triangles
%v4 - take direct neighbours by distance_to_neighbour

%parts - save result into temp file

%show_point = 5; %visualize links for point#
%points_with_inner = [Points; 0 0 0; 0 0 2*top];

%angle_thr = 10; %angle tolerance for visible by angle 

temp_dir = 'temp/';
file_name = 'temp_graph';
load_name = strcat(temp_dir, file_name,'.mat');



Rays = []; % all connected points
%v6
rays_checked = [];

bar = waitbar(0,'Building graph...');
steps = length(Points);

start = 1;

if(save_every_points)

    load(load_name, 'Rays', 'rays_checked', 'start');
    disp(['file loaded. last point: ' int2str(start)])    
%    previous_save = start;
      bar2 = waitbar(0,'Building graph...');
      tic;
      
end;    


    for i=start+1:steps
        
        
        %take one point % i - is a number of point taken

        % add direct neighbours
        Direct_n = []; %direct neighbours
        Points_Visible = [];
        
        %check this point already in Rays
%v6        [in_rays aa] = find(Rays == i);
%parts [in_rays aa] = find(rays_checked == i);

%          [in_rays aa] = find(Rays == i);
%         points_checked = [];
%         
%       %  size(in_rays,1)
%         if(size(in_rays,1))
%             
%             for r=1:length(in_rays)
%                 if(Rays(in_rays(r), 1)==i)
% %parts               if(rays_checked(in_rays(r), 1)==i)
%                     points_checked = [points_checked; Rays(in_rays(r), 2)];
% %parts                  points_checked = [points_checked; rays_checked(in_rays(r), 2)];
%                %end;
%                 elseif(Rays(in_rays(r), 2)==i)
% %parts               elseif(rays_checked(in_rays(r), 2)==i)
%                    points_checked = [points_checked; Rays(in_rays(r), 1)];
% %parts                  points_checked = [points_checked; rays_checked(in_rays(r), 1)];
%                end;
% 
%             end;
%         end;
    
      
        %% search for direct neighbours
            %search point in TRI
            
            
%  v4       [k, l] = find(Triangles==i);
%         
%         for ii=1:length(k)
%             for in=1:3                
%                 a = Triangles(k(ii),in); %triangle with point
%                 if(a~=i)
%                     %add point to the neighbours list
%                     m = find(Direct_n==a);
%                     if(length(m)==0)
%                         Direct_n = [Direct_n; a];
%                     end;    
%           
%                 end;
%             end;
%         end;  
           
        
        %% chek all points one by one to be visible from the point taken
        
 %parts       for j=1:length(Points) %j is a target point
         for j=i:length(Points) %j is a target point
 %v4           [kk ll]=find(Direct_n==j);
 %parts           [mm nn]=find(points_checked==j);
            


  %          if (length(mm)==0) % do not chek direct neighbours and if already checked from other side                
 %parts            if (isempty(mm))
                 
                if (j~=i)%compare only different points and not already in visible list
                    
                    %check for direct_neighbour threshold
                    
                    distance = Points(j,:) - Points(i,:);
                    distance = sqrt(distance*distance'); %take the distance

                    
                    if(distance <= distance_to_neighbour)
                        Points_Visible = [Points_Visible; j]; % neighbour is visible
                                if (i==show_point)
                                      Direct_n = [Direct_n; j]; % only for visualisation
                                end;
                    
                    else
                        
                    visible = point_is_visible( Points(i,:), Points(j,:), Normals(i,:), Normals(j,:), angle_thr, Points, Triangles );


                            if (visible)
                                
                                 
                                 visible_inner = point_is_visible( Points(i,:), Points(j,:), Normals(i,:), Normals(j,:), angle_thr, Inner_mesh, Triangles); 
                                 if(~visible_inner)
                       %               disp(['Not passed checking for inner volume: ' int2str(i) ' - ' int2str(j)]);
                                 
                                 else
                                    Points_Visible = [Points_Visible; j];
                               
                                 end;
                            end; 
%parts                            
%parts                    rays_checked = [rays_checked; i j];        
                    end; % if distance, else
%v5                    
 %parts                   rays_checked = [rays_checked; i j];
                end %if j~=i
            
 %parts          end; %if(mm)
            
        end %for j

   %   Points_Visible = [Points_Visible; Direct_n];

      Rays = [Rays; ones(length(Points_Visible),1)*i Points_Visible];
        
      
      %% visualization

        if (i==show_point)
            % hold on;
            % for g=1:length(Points_to_check)
            %     a = Points_to_check(g);
            %      plot3(A(a,1), A(a,2), A(a,3), 'bo');
            % end

            hold on;
            for g=1:length(Direct_n)
                a = Direct_n(g);
                 plot3(Points(a,1), Points(a,2), Points(a,3), 'r*');
            end

            hold on;
            for g=1:length(Points_Visible)
                a = Points_Visible(g);
                 plot3(Points(a,1), Points(a,2), Points(a,3), 'bo');

                % rays
                plot3([Points(i,1) Points(a,1)] , [Points(i,2) Points(a,2)], [Points(i,3) Points(a,3)]);
            end

            hold on;
                 plot3(Points(i,1), Points(i,2), Points(i,3), 'ro');


        end; %show point
    
        %% show progress
%     disp(['Point: ' int2str(i) ' done']);  
%     toc;
%     tic;
    waitbar(i/steps, bar);

           
    disp([int2str(i) ' points done']);  
            if(save_every_points)
               waitbar((i-start)/save_every_points, bar2);
               if((i - start) >= save_every_points)
                    start = i;   
                    save(load_name, 'Rays', 'rays_checked', 'start');
                    disp(['file saved. last point: ' int2str(start)]) 
                    toc;
                    tic;
            %previous_save = i;
               end;
               
           end;   
    
    end %for i

close(bar) ;
end