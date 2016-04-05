% Update figures.

% Copyright: Shaoying Lu and Yingxiao Wang 2011

function data= update_figure(data)
if isfield(data, 'im') && ~isempty(data.im{1}) && isfield(data, 'f'),

% move to get_image 09/03/2014
%     if isfield(data, 'need_apply_mask') && data.need_apply_mask,
%         file_name = strcat(data.output_path, 'mask.mat');
%         if ~isfield(data, 'mask'),
%             % Correct the title for mask selection
%             temp = get_polygon(data.im{1}, file_name, 'Please Choose the Mask Region');
%             data.mask = temp{1}; clear temp;
%         end;
%     end;

    switch data.protocol,
        case 'FRET',
            first_channel_im = preprocess(data.im{1}, data);
            second_channel_im = preprocess(data.im{2}, data);

            % data.file{3}-> ratio_im -> data.im{3} -> data.f(1)
            
            [data, ratio_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{3}, data.f(1));
            data.im{3} = ratio_im;

            figure(data.f(2)); my_imagesc(second_channel_im); % clf was included in my_imagesc
            axis off; my_title(data.channel_pattern{2}, data.index);

            clear first_channel_im second_channel_im ratio_im;
        case 'FRET-Intensity',
            first_channel_im = preprocess(data.im{1}, data);
            second_channel_im = preprocess(data.im{2}, data);
            im_3 = preprocess(data.im{3}, data);
            % file{4} -> ratio_im -> im{4} -> data.f(1)
            [data, ratio_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{4}, data.f(1));
            data.im{4} = ratio_im;

            figure(data.f(2)); my_imagesc(second_channel_im); 
            axis off; my_title(data.channel_pattern{2}, data.index);
            figure(data.f(3)); my_imagesc(im_3);
            axis off; my_title(data.channel_pattern{3}, data.index);

            clear first_channel_im second_channel_im im_3 ratio_im;
        case 'FRET-DIC',
            first_channel_im = preprocess(data.im{1}, data);
            second_channel_im = preprocess(data.im{2}, data);
            % file{4} -> ratio_im -> data.f(1)
            [data, ratio_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{4}, data.f(1));
            data.im{4} = ratio_im;

            figure(data.f(2)); my_imagesc(second_channel_im); 
            axis off; my_title(data.channel_pattern{2}, data.index);
            figure(data.f(3)); my_imagesc(data.im{3});
            colormap gray; 
            axis off; my_title('DIC', data.index);
        case 'FRET-Intensity-DIC',
            first_channel_im = preprocess(data.im{1}, data);
            second_channel_im = preprocess(data.im{2}, data);
            im_3 = preprocess(data.im{3}, data);
            % file{5} -> ratio_im -> data.f(1), im{5}
            [data, ratio_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{5}, data.f(1));
            data.im{5} = ratio_im;

            figure(data.f(2)); my_imagesc(second_channel_im); 
            axis off; my_title(data.channel_pattern{2}, data.index);
            figure(data.f(3)); my_imagesc(im_3);
            axis off; my_title(data.channel_pattern{3}, data.index);
            figure(data.f(4)); my_imagesc(data.im{4});
            colormap gray; 
            axis off; my_title('DIC', data.index);
            clear first_channel_im second_channel_im im_3 ratio_im;
        case 'FLIM',
            first_channel_im = preprocess(data.im{1}, data);
            second_channel_im = preprocess(data.im{2}, data);

            % data.file{3}-> ratio_im -> data.im{3} -> data.f(1)
            [data, flim_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{3}, data.f(1), 'local_function', []); %'update_flim_image');
            data.im{3} = flim_im;
       
            figure(data.f(2)); my_imagesc(second_channel_im); % clf was included in my_imagesc
            axis off; my_title(data.channel_pattern{2}, data.index);

            clear first_channel_im second_channel_im ratio_im;
         case 'STED',
            first_channel_im = preprocess(data.im{1}(:,:,1), data);
            second_channel_im = preprocess(data.im{2}(:,:,3), data);

            % data.file{3}-> ratio_im -> data.im{3} -> data.f(1)
            [data, sted_im] = update_ratio_image(first_channel_im, second_channel_im, data,...
                data.file{3}, data.f(1), 'local_function', []);
            data.im{3} = sted_im;
       
            figure(data.f(2)); my_imagesc(second_channel_im); % clf was included in my_imagesc
            axis off; my_title(data.channel_pattern{2}, data.index);

            clear first_channel_im second_channel_im ratio_im;

        case 'Intensity',
            second_channel_im = data.im{1};
            figure(data.f(1)); my_imagesc(second_channel_im); 
            axis off; my_title('Intensity',data.index);
            if isfield(data,'quantify_roi') && data.quantify_roi,
                data = quantify_region_of_interest(data, second_channel_im);
            end;
            clear second_channel_im;
            
            if ~exist(data.file{2}, 'file') &&...
                isfield(data, 'save_processed_image')&& data.save_processed_image,                
                im = imscale(data.im{1}, 0, 1, caxis);
                figure(data.f(1)); imwrite(im, data.file{2}, 'tiff','compression', 'none');
                clear im;
             end;

       case 'Intensity-Processing',
            second_channel_im = data.im{1};
            figure(data.f(1)); my_imagesc(second_channel_im); 
            axis off; my_title('Intensity',data.index);
            data.im{2}  = preprocess(data.im{1}, data); 
            figure(data.f(2)); my_imagesc(data.im{2}); 
            axis off; my_title('Processed',data.index);

            if isfield(data, 'show_detected_boundary') && data.show_detected_boundary,
                data = show_detected_boundary(data.im{2}, data); 
            end;
            
             if isfield(data,'quantify_roi') && data.quantify_roi,
                data = quantify_region_of_interest(data, data.im{2});
            end;

            if ~exist(data.file{2}, 'file') &&...
                    isfield(data, 'save_processed_image')&& data.save_processed_image,                
                im = imscale(data.im{2}, 0, 1, caxis);
                figure(data.f(2)); imwrite(im, data.file{2}, 'tiff','compression', 'none');
                clear im;
             end;

             clear second_channel_im;
        case 'Intensity-DIC-Processing',
            figure(data.f(1)); my_imagesc(data.im{1}); 
            axis off; my_title('Intensity',data.index);
            figure(data.f(2)); 
            my_imagesc(data.im{2});
            colormap gray; 
            axis off; my_title('DIC',data.index);
            data.im{3} = preprocess(data.im{1}, data); 
            figure(data.f(3));
            my_imagesc(data.im{3}); 
            %imagesc(data.im{3}); caxis(data.intensity_bound);
            axis off; my_title('Processed',data.index);

            %show_detected_boundary(data.im{3}, data, data.f(3));
            if isfield(data,'quantify_roi') && data.quantify_roi,
                data = quantify_region_of_interest(data, data.im{3});
            end;
            
            if ~exist(data.file{3}, 'file') &&...
                isfield(data, 'save_processed_image')&& data.save_processed_image,                
                figure(data.f(3)); im = imscale(data.im{3}, 0, 1, caxis);
                imwrite(im, data.file{3}, 'tiff','compression', 'none');
                clear im;
             end;



    end; %switch data.protocol

    % Draw the background region
    if isfield(data, 'subtract_background') && data.subtract_background,
        figure(data.f(1)); hold on; 
        file_name = strcat(data.output_path, 'background.mat');
        % draw_polygon is an interactive function 
        % If we move the roi with draw_polygon, the new roi will be saved
        % into the roi file. Meanwhile, the program will exit update_figure 
        % and return to the java interface. 
        % The background region is only shown if the image was not cropped.
        
%         if isfield(data,'crop_image') && ~data.crop_image,
%             draw_polygon(gca, data.bg_poly, 'yellow', file_name);
%         end;

% 1/27/2015 Lexie: when there is no field called 'crop_image', background
% will be displayed

        if ~isfield(data, 'crop_image') || (isfield(data,'crop_image')&&...
                ~data.crop_image),
            draw_polygon(gca, data.bg_poly, 'yellow', file_name);
        end;
        
    end; 
else
    display('Function update_figure warning: ');
    display('Please load the images or check the range of index.')
end; % if isfield(data, 'im'),
return;

% Keep the caxis from the previous plot
% Use caxis auto for a new figure
function my_imagesc(im)
temp = caxis;
axis_vector = axis;
clf; 
if temp(1) ==0 && temp(2) ==1,
    imagesc(im);
else
    imagesc(im, temp);
    axis(axis_vector);
end;
return;



