function [ mesh_flipped top_row] = flip_mesh( mesh, top )
%FLIP_MESH Summary of this function goes here
mesh_flipped = [];

%find top points
[top_row b] = find(mesh(:,3)==top);


for i=1:length(mesh)
    if( ~(length(find(top_row==i))))
        row = mesh(i,:);

        %flip Z    
        row(3) = 2*top-row(3);

        %flip Z for normal vector
        row(6) = -row(6);

        mesh_flipped = [mesh_flipped; row];
    end;%if
   
end;
end

