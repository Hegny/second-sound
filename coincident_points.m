function [ coincident_points ] = coincident_points( mesh )
%COINCIDENT_POINTS Summary of this function goes here
%   Detailed explanation goes here


z_bottom = min(mesh(:,3));
z_top = max(mesh(:,3));

bottom_points = (find(mesh(:,3)==z_bottom));

top_points = (find(mesh(:,3)==z_top));

coincident_points = [];
for i=1:length(bottom_points)
    for j=1:length(top_points)
         if isequal(mesh(bottom_points(i),1:2), mesh(top_points(j),1:2))
               coincident_points = [coincident_points; bottom_points(i) top_points(j)];
         end;
    end;
end;%for    
%coincident_points
end

