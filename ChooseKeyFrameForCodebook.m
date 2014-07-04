function ChooseKeyFrameForCodebook(keyframe_folder,output_folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

keyframe_dir = dir(keyframe_folder);
%keyframe_path(1,:)='null';
is_empty = 1; % 1 for there is no keyframe for codebook, 0 for there are some.

for i=1:length(keyframe_dir)
    if (~strcmp(keyframe_dir(i).name, '.') && ~strcmp(keyframe_dir(i).name, '..'))
        %if (strcmp(keyframe_path(1,:),'null'))   
        if (is_empty)     
            image_path = [keyframe_folder,'/',keyframe_dir(i).name];
            %keyframe_path(1,:)=image_path;
            is_empty = 0;
            image = imread(image_path);
            imwrite(image,[output_folder,'/',keyframe_dir(i).name],'jpg');
        else
            image_path = [keyframe_folder,'/',keyframe_dir(i).name];
            image = imread(image_path);
            image_flag = 0;  % 1 for similiar, 0 for non_similiar
            
            for j = 1:i-1
                if(image_flag)
                    break;
                end
                if (~strcmp(keyframe_dir(j).name, '.') && ~strcmp(keyframe_dir(j).name, '..'))
                    former_image_path = [keyframe_folder,'/',keyframe_dir(j).name];
                    former_image = imread(former_image_path);
                    dist = CalculateEuclideanDistance(image, former_image);
                    if (dist<103)
                        image_flag = 1;
                    end   
                end                
            end
            if (~image_flag)
                imwrite(image,[output_folder,'/',keyframe_dir(i).name],'jpg');
                %keyframe_path = [keyframe_path;image_path];
            end            
        end
    end
end

end

