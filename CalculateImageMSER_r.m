function  CalculateImageMSER_r( mser_folder, image_folder, output_folder )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Calculate after-mask images...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature
if (~isdir(output_folder))
    mkdir(output_folder);
end

subfolders_dir = dir(image_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        frame_folder = fullfile(image_folder,subname);
        fea_folder = fullfile(mser_folder,subname);
        output_image_folder = fullfile(output_folder,subname);
        %mkdir(sift_dir);
         if (~isdir( output_image_folder))
            mkdir( output_image_folder);
        end
        
        fprintf('Calculate after-mask images for %s...\n',frame_folder);        
        image_format = '*.jpg';
        image_dir = dir(fullfile(frame_folder,image_format));

        image_num = length(image_dir);
        %sift_path = cell(image_num,1);

        bar = round(image_num/10);
        
        for j = 1:image_num
            if(rem(j,bar)==0)   % the processing bar
                ret = round(j/bar);
                fprintf('%d%%...\n',ret*10);
            end

            image_path = fullfile(frame_folder,image_dir(j).name);
            image = imread(image_path);
            
            if (numel(size(image))>2 )              
                image = rgb2gray(image);
            end
            
            %Process
            [~, fname] = fileparts(image_dir(j).name); 
            load(fullfile(fea_folder,[fname,'_mser.mat']));
            
            % compute regions mask
            M = zeros(size(image)) ;
            for x=feature_set.location'
                s = vl_erfill(image, x) ;
                M(s) = M(s) + 1;
            end
            
            image_after_mask = uint8(M).*image;            
                   
            % save the  feature

            imwrite(image_after_mask, fullfile(output_image_folder,image_dir(j).name),'jpg');
            %sift_path(j) = {fpath};
        end
        
        
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end

