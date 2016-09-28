function [ caps triangles] = make_cylinders ( Points, OST )
%MAKE_CYLINDERS  
% makes cylinders above and below the duble-bell to prevent raytraycing
% through neighbours cells

z(1) = min(Points(:,3));
z(2) = max(Points(:,3));

OST_shift = [-1; 1];

if(OST(3)>z(2))
    OST_shift(2) = OST(3)-z(2);
elseif (OST(3)<z(1))
    OST_shift(1) = OST(3)-z(1);
end;
    


caps = []; % bottom (1) and top (2) rows
triangles = [];

for l=1:2

    p = find(Points(:,3) == z(l));

    cap = [];

    for i=1:length(p)
  
        cap = [cap; Points(p(i),:)];
    end;

         % make triangles
         
     tri = [];
     
    for i=2:length(cap)
        
        triangle_1 = [(i-1) (i) (i-1)+length(cap)];
        triangle_2 = [(i)+length(cap) (i) (i-1)+length(cap)];
        
        tri = [tri; triangle_1; triangle_2];
                
    end;
    cap_shifted = cap;
    cap_shifted(:,3) = cap_shifted(:,3)+ OST_shift(l);
    cap = [cap; cap_shifted] ;

    %tri
%     tri = delaunay(cap(:,1),cap(:,2));
% 
%     for i=1:length(tri)
%         for k=1:3
%             tri(i,k) = p(tri(i,k));
%         end;
%     end;
    

    triangles = [triangles; tri+size(caps,1)];
    caps = [caps; cap];

    
end; %for

% figure;
%  trimesh(triangles,caps(:,1),caps(:,2),caps(:,3));
%  
%  axis equal;

end

