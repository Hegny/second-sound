function [ Graph ] = visible_from_OST_v2( OST, OST_normal, mesh, angle_thr, triangles, rays, z_shift, show_rays, show )
%cheks visibility of points in mesh from OST and adds rays for visible
%points to Rays
%   v2 - plotting adds z-shift for n_cells
%   v2 - show_rays
%   v2 - caps changed for cylinders


 %tic;
 if (show)
   disp(['Rel OST position:' num2str(OST(1)) ' ' num2str(OST(2)) ' ' num2str(OST(3))]);
   disp('check for visible points from OST...');
 end;
 Points_Visible = [];
 %check for visible points from OST
 %caps =  make_caps(mesh(:,1:3));
 %%
 [cyl_mesh cyl_triangles] = make_cylinders (mesh(:,1:3), OST);
%%
        for j=1:length(mesh) %j is a target point
           target =  mesh(j,1:3);
           target_normal = mesh(j,4:6);
           
           %there is artefact when the point is on the cutting edge on
           %opposite side from OST
           if ~((target(1)== 0)&&(target(2)<0))
         %      j
               visible = point_is_visible( OST, target, OST_normal, target_normal, angle_thr, [mesh(:,1) mesh(:,2) mesh(:,3)], triangles );
               if (visible)
                   
                   % check for crossing the caps v2
 %                  visible = point_is_visible( OST, target, OST_normal, target_normal, angle_thr, [mesh(:,1) mesh(:,2) mesh(:,3)], caps );
                  visible = point_is_visible( OST, target, OST_normal, target_normal, angle_thr, cyl_mesh, cyl_triangles );
                   
                   if (visible)
                       Points_Visible = [Points_Visible; 0 j];

                       %points
                       if(show)
                       plot3(mesh(j,1), mesh(j,2), mesh(j,3)+z_shift, 'ro');
                       end;
                       % rays
%                        OST
%                        OST(3)+z_shift
                        if(show_rays)
                           plot3([OST(1) mesh(j,1)] , [OST(2) mesh(j,2)], [OST(3)+z_shift mesh(j,3)+z_shift]);
                        end;
                   end;
                   
               end;         
           end; %if target
        end; %for j
        
%toc;        
 Points_Visible   ;
 if (show)
    disp([int2str(length(Points_Visible)) ' points are visible']);
 end;
 Graph = [Points_Visible; rays];
 OST;

end

