function  BMPtoJPG( img_folder,output_folder )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

subfolders_dir = dir(img_folder);
if (~isdir(output_folder))
    mkdir(output_folder);
end

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        frame_folder = fullfile(img_folder,subname);
        data_folder = fullfile(output_folder,subname);
        
        if (~isdir(data_folder))
            mkdir(data_folder);
        end
         fprintf('Transfer bmp to JPG for %s...\n',frame_folder);
         
        image_format = '*.bmp';
        image_dir = dir(fullfile(frame_folder,image_format));

        image_num = length(image_dir);
        %sift_path = cell(image_num,1);

        bar = round(image_num/10);
        
        for j = 1:image_num
            if(rem(j,bar)==0)   % the processing bar
                ret = round(j/bar);
                fprintf('%d%%...\n',ret*10);
            end
              
            img_path = fullfile(frame_folder,image_dir(j).name);
            image = imread(img_path);
            [~, fname] = fileparts(image_dir(j).name); 
            
            imwrite(image,fullfile(data_folder,[fname,'.jpg']),'jpg');
            fprintf('Done!\n');
        end
        
        
       
    end
end

end

