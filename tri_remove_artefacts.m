function [ triangles ] = tri_remove_artefacts( tri, top_row )
%find triangles with only top points
triangles = []; %sorted triangles from tri

for i=1:length(tri)
    
    for point = 1:3
       %serch triangle point in top points 
       [k, l] = find(top_row==tri(i, point));
       if (~length(k))
          break; 
       end
        
    end;
    if (~length(k)) %if NOT( all 3 points in triangle are in top list)
        
    triangles = [triangles; tri(i,:)];
    
    
    end;
    
end;

end

