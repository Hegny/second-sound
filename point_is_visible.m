function [ visible ] = point_is_visible( origin, target, origin_normal, target_normal, angle_thr, all_points,tri )
%POINT_IS_VISIBLE 
% checks if the point target is visible from the point origin
%1. checking by angles with origin normal vector
%2. checking by angles with target normal vector
%3. checking by by crossing any triangle from tri (tri - triangles with points from all_point)

%temporsry
% inner space is an array of triangles in beamtube

%v2
% inner_space = [0 0 0 30 0 0 0 0 116;
%                30 0 0 0 0 116 30 0 116];
visible = 0;
                   %take vector on point
                    direction = target-origin;
                    leng = sqrt(direction*direction');
                    %check angle between vector and normal of origin point
                    angle = acosd(dot(direction, origin_normal)/(norm(direction)*norm(origin_normal)));

                    if (angle <= 90+angle_thr)

                         %check angle between vector and normal of target point
                         angle_target = acosd(dot(direction, target_normal)/(norm(direction)*norm(target_normal))) ;
                         
                         if (angle_target >= 90-angle_thr)
                            intersection = 0;
                        
                      %      direction = direction(norm(direction));
                            %check intersection for all triangles except
                            %which contains the target point as corner
                            for n_triangles=1:length(tri)
                                triangle = tri(n_triangles,:);
                                vert1 = all_points(triangle(1),:);
                                vert2 = all_points(triangle(2),:);
                                vert3 = all_points(triangle(3),:);

                                if(~(isequal(target, vert1)))&&(~(isequal(target, vert2)))&&(~(isequal(target, vert3)))
                                   if(~(isequal(origin, vert1)))&&(~(isequal(origin, vert2)))&&(~(isequal(origin, vert3))) 
                                         if (intersection == 0)                                             
                                             [intersection distance] = intersect_triangle(origin, direction, vert1, vert2, vert3);
                                             if(intersection)
%                                               n_triangles  
%                                               target
%                                              distance  
                                             
                                             
                                                if(leng-abs(distance)<0)||(distance<0) %distance<0 if triangle is in opposite direction
                                                 intersection = 0;
                                                 
                                                                                                
                                                 
                                                end;
%                                               n_triangles
% %                                              triangle
%                                               origin
% %                                              direction
%                                               vert1
%                                               vert2
%                                               vert3
                                            %    intersection
                                             end; %if intersection
                                             

                                             
                                         else                                     
                                             break;
                                         end;
                                   end; %if origin
                                end; % if target
                            end; %triangles

                                             %check for crossing inner
                                             %space
                                             
%v2                                             
%                             if(intersection==0)  
%                             %    target
%                                 for k=1:size(inner_space, 1)
%                                     
%                                     [inters dist] = intersect_triangle(origin, direction, inner_space(k, 1:3), inner_space(k, 4:6), inner_space(k, 7:9));
%                             %        inters
%                             %        k  
%                             %        inner_space(k, 1:3)
%                             %        inner_space(k, 4:6)
%                             %        inner_space(k, 7:9)
%                                                          if(inters)
%                                                            
%                                                %      target                                                            
%                                                                if(leng-dist<0)
%                                                                      intersection = 0;
%                                                                else
%                                                                    intersection = 1;
%                                                                    break;  
%                                                                end;
%                                                                
%                                                          end;
%                                 end;
%                                                      
%                              end;                            
 %v2 end                           
                            
                            
                            
                            %if no intersection - visible
                            if (intersection == 0)
                               visible = 1;
                            end;     
               
               
                        end;
                    end;
                    

end

