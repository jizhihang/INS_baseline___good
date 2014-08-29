function  CalculateMSER(img_folder, data_folder)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%==========================================================================
% usage: calculate the sift descriptors given the image directory
%
% inputs
% img_dir    -image database root path
% data_dir   -feature database root path
% outputs
% database      -directory for the calculated sift features
%
% VL_SIFT is used 
%
% written by Jianchao Yang
% Mar. 2009, IFP, UIUC
% changed by huangying April,2014
% usage :
% img_dir = 'image';  %  every subfolder contains images from one class
% data_dir = 'data'; % this data folder to store the extracted sift in images
%==========================================================================

disp('Extracting MSER features...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature

subfolders_dir = dir(img_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        frame_folder = fullfile(img_folder,subname);
        fea_folder = fullfile(data_folder,subname);
        %mkdir(sift_dir);
         if (~isdir(fea_folder))
            mkdir(fea_folder);
        end
        
        fprintf('Extracting MSER feature for %s...\n',frame_folder);
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

            img_path = fullfile(frame_folder,image_dir(j).name);
            image = imread(img_path);
            if (numel(size(image))>2 )              
                image = rgb2gray(image);
            end
            image = uint8(image);                      
            
            [r, f] = vl_mser(image,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature

            feature_set.location = r;            
            feature_set.feature = f;
           
            % save the sift feature
            [~, fname] = fileparts(image_dir(j).name);                        
            fpath = fullfile(fea_folder, [fname, '_mser.mat']);
            save(fpath, 'feature_set');
            %sift_path(j) = {fpath};
        end
        
        
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end

