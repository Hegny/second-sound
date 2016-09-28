function [ Distances Path] = process_graph_with_initial_distances_and_OST_size_v2( Graph, Points, Zero_point, OST_normal, Distances, show, OST_radius )
%PROCESS_GRAPH Summary of this function goes here
%   Detailed explanation goes here
%Distances = zeros(size(Points,1), 1);

%OST_radius = 9; %mm
OST_radius = OST_radius*0.9;

Path = -ones(size(Points,1), 1);

%point = 0;
if (show)
   disp('Calculating distances...');
end;
points_to_check = [0]; %start with 0 point - root of graph

pp = find(Distances>0);
points_to_check = [points_to_check; pp];

a = 0;
offset = [];

while (length(points_to_check))
%for z=1:5
    a = a+1;
   %take first point from the list
    point = points_to_check(1);
    %remove taken point from the list
    points_to_check = points_to_check(2:end);
    distance_to_point = 0;
        if(point == 0)
           Coordinates = Zero_point;
        else
           Coordinates = Points(point,:);
           distance_to_point = Distances(point);
        end;

    %search rays with that point
   [rays place] = find(Graph == point);

   
%   disp(['Point: ' int2str(point) ' Distance: ' num2str(distance_to_point)]);

       for i=1:length(rays)

           if(place(i)==1)
               pair = 2;
           else
               pair = 1;
           end;

           target = Graph(rays(i), pair);
           
           %do not recalculate distance to root
           if(target)
              
           
           
            %   target_coordinates = Points(target,:)
            
% Use real OST size
               if(point == 0) %if ray goes connected to OST
                   
                   %find the angle between Ray and OST normal
                   direction = Points(target,:) - Coordinates;                  
      %             angle_target = acosd(dot(direction, OST_normal)/(norm(direction)*norm(OST_normal)));
%                    distance_no_offset = sqrt(direction*direction');
                   
                   %find projection on X-Z plane
%this code shuold be changes for projection on OST membrane plane                   
                   direction_proj = [direction(1) direction(3)];
                   %normalizing projection
                   nnn = norm(direction_proj);
                   
                   if(nnn>0)                   
                         proj_norm = direction_proj./nnn;                   
                   %move OST in direction of projection                   
                        direction = abs(direction - OST_radius*([proj_norm(1) 0 proj_norm(2)]));
                   end;
                   distance = sqrt(direction*direction');
    %               distance_no_offset - distance;
                   
%                    if(distance_no_offset < 90)
%                       Points(target,:)
%                       Coordinates 
%                       Points(target,:) - Coordinates 
%                       distance_no_offset 
%                       direction_proj
%                   %    proj_norm
%                       direction
%                       distance
%                       distance_no_offset - distance
%                    end;    
                   
                   %offset = [offset; distance_no_offset - distance]
               else

                   distance = abs(Points(target,:) - Coordinates);
                   distance = sqrt(distance*distance');
               
               end;
               %add distance to point itself
               distance = distance + distance_to_point;
                was = Distances(target);


               if(Distances(target)==0)||(Distances(target)> distance)
                    Distances(target) = distance;
                    Path(target) = point;
               %put target point in point_to_check if not yet

                    if(isempty(find(points_to_check == target))) %was ~length
                        points_to_check = [points_to_check; target];
                    end;
               end;
           end;
      
 %disp(['target: ' int2str(target) ' distance was: ' num2str(was) ' now: ' num2str(Distances(target))]);           
           
       end %for
   
   
 points_to_check  ;
 
end; %while

if (show)
disp(['Done. Iterations: ' int2str(a)]);
end;
% offset
% min(offset)
% max(offset)

end

