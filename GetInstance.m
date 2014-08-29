function GetInstance( img_folder ,output_folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('Extracting Instances...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature
if (~isdir(output_folder))
    mkdir(output_folder);
end
subfolders_dir = dir(img_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        instance_folder = fullfile(img_folder,subname);
        out_ins_folder = fullfile(output_folder,'instance',subname);
        out_en_folder = fullfile(output_folder,'environment',subname);
        if (~isdir(out_ins_folder))
            mkdir(out_ins_folder);
        end
        if (~isdir(out_en_folder))
            mkdir(out_en_folder);
        end
        
        image_format = '*.jpg';
        image_dir = dir(fullfile(instance_folder,image_format));

        image_num = length(image_dir);
        %sift_path = cell(image_num,1);        
        instance_id = subname(1:4);
        for j = 1:image_num/2
            image_mask = imread([instance_folder,'\',instance_id,'.',num2str(j),'.mask.jpg']);
            idx = find(image_mask ~= 0);
            image_mask(idx)= 1;
            image_src = imread([instance_folder,'\',instance_id,'.',num2str(j),'.src.jpg']);
            image_instance = immultiply(image_mask,image_src);
            image_environment = imsubtract(image_src,image_instance);
            imwrite(image_instance,[out_ins_folder,'\',instance_id,'.',num2str(j),'.ins.jpg'],'jpg');
            imwrite(image_environment,[out_en_folder,'\',instance_id,'.',num2str(j),'.en.jpg'],'jpg');
        end
        
    end
end

end

