function [ tri ] = tri_connect( tri, list, offset )
%shift points for triangles except the row, which is attached to preveous
%part of mesh


for i=1:length(tri)
    
    for point = 1:3
       %serch triangle point in top points 
       [k, l] = find(list==tri(i, point));
       if (~length(k))
          tri(i, point) = tri(i, point)+offset; 
       end
        
    end;
end;


end



