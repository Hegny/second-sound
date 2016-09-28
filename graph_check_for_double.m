function [ rays_checked ] = graph_check_for_duble( rays )
%GRAPH_CHECK_FOR_DUBLE 
%checks for duplicated links
%ray: 1 2
%will chek for rays 1 2 and 2 1

rays_checked = [];
duplicats_found = 0;

    for i=1:size(rays, 1)
    %     rays(i,:)
         [in_rays place] = find(rays == rays(i,1));
    %     in_rays
         pair = rays(i, 2);
         a=0;
         for k=1:length(in_rays)
             if(in_rays(k)>i) %do not check previous checked and itself
                %  in_rays(k)
       %         ray = rays(in_rays(k),:)
                % place(k)
                 if(place(k)==1)             
                   a = rays(in_rays(k),2);
                 else
                   a = rays(in_rays(k),1);
                 end;
                 if(a == pair)
                     break;
                 end;
             end;
                       
         end;
         
         if(a~=pair)
             rays_checked = [rays_checked; rays(i,:)];
         else
             duplicats_found = duplicats_found+1;
         end;

    end;
disp(['Duplicates found: ' int2str(duplicats_found)]);

end

