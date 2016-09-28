%check intersection of vector (orig, dir) and triangle(vert0, vert1, vert2)
%based on paper of Tomas Moeller et al.

%returns 1 if intersects, and 0 if not
function [a t] =intersect_triangle(orig, dir, vert0, vert1, vert2)%, *t, *u, *v)
t = 0;
Epsilon = 0.000001;

%normalize direction vector

dir = dir/norm(dir);
%vector_length = sqrt(dir*dir');

 %find vectors for two edges sharing vert 
edge1 = vert1-vert0;
edge2 = vert2-vert0;

%begin calculating determinant  also used to calculate U parameter
pvec = cross(dir, edge2);

%if determinant is near zero ray lies in plane of triangle
det = dot(edge1, pvec);

if((det > -Epsilon)&(det < Epsilon))
    a=0;
else
    inv_det = 1/det;
    
    %calculate distance from vert to ray origin
    tvec = orig - vert0;
    
    %calculate U parameter and test bounds
    u = dot(tvec, pvec)*inv_det;
    if((u <0)||(u>1))
        a=0;
        return;
    end;
    
    %prepare to test V parameter
    qvec = cross(tvec, edge1);
    
    %calculate V parameter and test bounds
    v = dot(dir, qvec)*inv_det;
    if ((v<0)||((u+v)>1))
        a=0;
        return;
    end;
    
    %calculate distanse t, where ray intersects triangle
    %was t=abs()
    t = dot(edge2, qvec)*inv_det;
    
%     if(t<=vector_length)
%          a=1;
%     else
%         a=0;
%     end;
    
    a=1;
    
end;    %if
    
    


end