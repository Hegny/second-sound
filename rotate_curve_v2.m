function [ mesh map] = rotate_curve_v2( points, threshold )
%ROTATE_CURVE rotates flat curve
mesh =[];
map = [];
for i=1:size(points,1)
    
    r = points(i, 1);
    %calculate angle for minimum distance
    angle_step = 360*threshold/(2*pi*r);
    angle_step = 180/(ceil(180/angle_step));
    
    nx = points(i, 5);
    ny = points(i, 4);
    nz = points(i, 6);
    for n=0:angle_step:180
        
        s = sind(n);
        c = cosd(n);
        
        %point coordinates
        x = r*s;
        y = r*c;
        
        %normal vector
         %rotation matrix (vertical axis z)
        R = [c -s; s c];
        nn = [nx ny]; 
        nn = nn*R;
        
        nn = [nn(1) nn(2) nz];
        nn = nn/norm(nn);

    
        mesh = [mesh; x y points(i, 3) nn(1) nn(2) nn(3)];
        map = [map; points(i, 7) n];
    end;
    
end;    
end

