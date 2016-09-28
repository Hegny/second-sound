function [ output_args ] = show_result_map_v2( result, angle_step, angle_aspect, phi_start, phi_stop, phi_step, z_start, z_stop, z_step, c_map, cavity_name, test_name, mesh_size, OST_used, time_thr, time_minimum )

curve_length = round(98.5);

[height width] = size(result);



%% plotting 
clear ylab;
clear yticks;

show_z_ticks = 0;
show_text = 1;

angle_ticks_interval = 30; %deg
height_ticks_interval = 50;
height_ticks_thr = 5; % in steps

text_position = 0; % 0 - bottom, 1 - top


% calculating angle interval for ticks
if (phi_stop-phi_start)<100
  angle_ticks_interval = 10;  
    
end;    

to_show(1,:,:) = result;
show_title(1) = {'RMSE quench map for '};
show_color(1) = {'RMSE, mm'};

handles = zeros(1, size(to_show, 1));



xlab = [(phi_start-1)*angle_step:angle_ticks_interval:phi_stop*angle_step]; 
ticks = {'I1'; 'E1'; 'I2'; 'E2'; 'I3'; 'E3'; 'I4'; 'E4'; 'I5'; 'E5'; 'I6'; 'E6'; 'I7'; 'E7'; 'I8'; 'E8'; 'I9'; 'E9'; 'I10'};

 added = 1;
for i=1:1782
    if(mod(i, curve_length)<1)||(i==1)
         n =  floor(i/curve_length)+1;
         ylab{added} = ticks{n};  
         if(i==1)
            yticks(added) = (n-1)*curve_length+1;
         else
            yticks(added) = (n-1)*curve_length;
         end;
         added = added+1;
    elseif (mod(i, height_ticks_interval)<1)
        if(show_z_ticks)
            if abs(i-(floor(i/curve_length)*curve_length)) > height_ticks_interval/3
             ylab{added} = num2str(i);   
            else
                ylab{added} = '';  
            end; 
             yticks(added) = i;  
             added = added+1;
        end;
       
    end;
    
end;
%z_start

yticks = (yticks-z_start)/z_step+1;

% ylab=fliplr(ylab);
% yticks = fliplr(yticks);
%yticks = [1-z_start/z_step:(curve_length/z_step):height];
%yticks = [1-z_start/z_step:(height_ticks_interval/z_step):height];



if(text_position)
    text_v_align = 'top'; 
    text_h_position = height-2;    
else    
    text_v_align = 'bottom'; 
    text_h_position = 2;
end;


figure;

for sh=1:size(to_show, 1)
%    figure;
    handles(sh) = subplot(1,size(to_show, 1),sh);
    what_to_show = squeeze(to_show(sh,:,:));  
    h = imagesc(what_to_show);

    

    set(gca,...
        'XTick', [1:angle_ticks_interval/(phi_step*angle_step):width],...
        'XTickLabel', xlab,...
        'YTick', yticks ,...
        'YTickLabel', ylab,...
        'YDir', 'normal',...
        'DataAspectRatio',[1 angle_aspect 1])

    grid on
    hold on;  
      colormap(c_map);
    cbar = colorbar;
    ylabel(cbar,show_color(sh));
    title (strcat(show_title(sh), cavity_name, ' Test: ', test_name));
    xlabel('angle, deg');
    ylabel('z along surface, mm');
    if(show_text)
        text(2,text_h_position,...
            {['\color{white}' cavity_name ' Test ' test_name];...
            ['mesh size: ' num2str(mesh_size)];...
            ['OST used: ' num2str(OST_used)];...
            ['time_{min}: ' num2str(time_minimum) ' sec'];...
            ['time_{max}: ' num2str(time_thr) ' sec'] },...
            'HorizontalAlignment','left',...
            'VerticalAlignment', text_v_align )      
    end;% show text
    
%     ax1 = gca; % current axes
%     ax2 = axes('Position',get(ax1,'Position'),...         
%         'YAxisLocation','right',... 
%         'Color','none',... 
%         'XColor','k','YColor','k');
 %       set(gca,'Box','off');   %# Turn off the box surrounding the whole axes
%         axesPosition = get(gca,'Position');          %# Get the current axes position
%         hNewAxes = axes('Position',axesPosition,...  %# Place a new axes on top...
%                         'Color','none',...           %#   ... with no background color
%                         'YLim',[0 10],...            %#   ... and a different scale
%                         'YAxisLocation','right',...  %#   ... located on the right
%                         'XTick',[],...               %#   ... with no x tick marks
%                         'Box','off');                %#   ... and no surrounding box
%         ylabel(hNewAxes,'scale 2');  %# Add a label to the right y axis


    %     set(gca,'YDir', 'normal')
end; %for sh    
squeeze_axes(handles);
end

