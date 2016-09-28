function [ map_flipped ] = flip_map( map, top_row, curve_length )
%FLIP_MESH Summary of this function goes here
map_flipped = [];

%find top points



for i=1:length(map)
    if( isempty(find(top_row==i, 1)))
        m = map(i,:);
        map_z = map(i,1);

        %flip Z    
        m(1) = 2*curve_length-map_z;


        map_flipped = [map_flipped; m];
    end;%if
   
end;
end

