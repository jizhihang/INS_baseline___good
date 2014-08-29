function  DoPooling( input_folder,output_folder, pyramid )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

fprintf('Doing Pooling...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature
if (~isdir(output_folder))
    mkdir(output_folder);
end

subfolders_dir = dir(input_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        feature_folder = fullfile(input_folder,subname);
        sp_folder = fullfile(output_folder,subname);
        %mkdir(sift_dir);
         if (~isdir(sp_folder))
            mkdir(sp_folder);
        end
        
        fprintf('Doing SP for %s...\n',feature_folder);
        feature_format = '*.mat';
        feature_dir = dir(fullfile(feature_folder,feature_format));

        feature_num = length(feature_dir);
        %sift_path = cell(image_num,1);

        bar = round(feature_num/10);
        
        for j = 1:feature_num
            if(rem(j,bar)==0)   % the processing bar
                ret = round(j/bar);
                fprintf('%d%%...\n',ret*10);
            end

            feature_path = fullfile(feature_folder,feature_dir(j).name);
            load(feature_path);
            feature = [index';[1:size(index,1);ones(1,size(index,1))]];
            sp_feature = sp(feature,1, size(index,1), pyramid);
            
            %feature_set.feature = sp.feature;
           
            % save the sift feature
            [~, fname] = fileparts(feature_dir(j).name);                        
            fpath = fullfile(sp_folder, [fname, '_sp.mat']);
            save(fpath, 'sp_feature');
            %sift_path(j) = {fpath};
        end
        
        
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end

