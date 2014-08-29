function GetInstanceSIFT( ins_folder,en_folder,output_folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('Get SIFT for instance as a whole...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature
if (~isdir(output_folder))
    mkdir(output_folder);
end
subfolders_dir = dir(en_folder);

for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        i_folder = fullfile(ins_folder,subname);
        e_folder = fullfile(en_folder,subname);
%         fea_folder = fullfile(data_folder,subname);
%          if (~isdir(fea_folder))
%             mkdir(fea_folder);
%         end
        
        fprintf('Combining SIFT feature for %s...\n',i_folder);
        file_format = '*.mat';
        en_dir = dir(fullfile(e_folder,file_format));
        ins_dir = dir(fullfile(i_folder,file_format));

        %image_num = length(en_dir);
        %sift_path = cell(image_num,1);

        bar = round(length(subfolders_dir)/10);
        feature_en = [];    %sift 4 times in the environment(not ROI)
        feature_diff_en = []; %sift 3 times in the environment(not ROI)
        feature_ins = [];   %sift in instance(in ROI)
        for j = 1:4 %image_num
            if(rem(j,bar)==0)   % the processing bar
                ret = round(j/bar);
                fprintf('%d%%...\n',ret*10);
            end
            
            %处理环境sift，出现3次及3次以上算入
            en_path = fullfile(e_folder,en_dir(j).name);
            load(en_path);
            if (j==1)
                feature_en = feature_set.feature;
            elseif (j==2)
                data = feature_set.feature;
                [matches, scores] = vl_ubcmatch(feature_en, data);
                
                diff2 = 1:size(data,2);
                diff2 = setdiff(diff2,matches(2,:));
                feature_diff_en = data(:,diff2);
                
                diff1 = 1:size(feature_en,2);
                diff1 = setdiff(diff1,matches(1,:));
                temp = feature_en(:,diff1);
                feature_diff_en = [feature_diff_en temp];
                
                feature_en = feature_en(:,matches(1,:));
            elseif (j==3)
                data = feature_set.feature;
                [matches, scores] = vl_ubcmatch(feature_diff_en, data);                
                feature_diff_en = feature_diff_en(:,matches(1,:));
                
                [matches, scores] = vl_ubcmatch(feature_en, data);
                
                diff1 = 1:size(feature_en,2);
                diff1 = setdiff(diff1,matches(1,:));                
                temp = feature_en(:,diff1);
                feature_diff_en = [feature_diff_en temp];
                
                feature_en = feature_en(:,matches(1,:));
            elseif (j==4)
                data = feature_set.feature;
                [matches, scores] = vl_ubcmatch(feature_diff_en, data);                
                feature_diff_en = feature_diff_en(:,matches(1,:));
                
                [matches, scores] = vl_ubcmatch(feature_en, data);
                
                diff1 = 1:size(feature_en,2);
                diff1 = setdiff(diff1,matches(1,:));                
                temp = feature_en(:,diff1);
                feature_diff_en = [feature_diff_en temp];
                
                feature_en = feature_en(:,matches(1,:));
                
            end
            
            
            %处理Instance，全部算入
            ins_path = fullfile(i_folder,ins_dir(j).name);
            load(ins_path);
            if (j==1)
                feature_ins = feature_set.feature;
            else
                data = feature_set.feature;
                [matches, scores] = vl_ubcmatch(feature_ins, data);
                
                diff = 1:size(data,2);
                diff = setdiff(diff,matches(2,:));
                data = data(:,diff);
                feature_ins = [feature_ins data];
            end
            
        end
        %save the output
        fname = en_dir(j).name(1:4);                        
        fpath = fullfile(output_folder, [fname, '_sift.mat']);
        save(fpath, 'feature_en','feature_diff_en','feature_ins');
        
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end
