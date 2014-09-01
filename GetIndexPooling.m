function  GetIndexPooling( dictionary,input_folder, output_folder,pyramid, height, width )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Extracting Index...');

if (~isdir(output_folder))
    mkdir(output_folder);
end
subfolders_dir = dir(input_folder);


for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        fea_folder = fullfile(input_folder,subname);
        index_folder = fullfile(output_folder,subname);
        if (~isdir(index_folder))
            mkdir(index_folder);
        end
        
        fprintf('Extracting index for %s...\n',fea_folder);
        file_format = '*.mat';
        fea_dir = dir(fullfile(fea_folder,file_format));

        fea_num = length(fea_dir);
        
        bar = round(fea_num/10);

        for j = 1:fea_num
            if(rem(j,bar)==0)   % the processing bar
                ret = round(j/bar);
                fprintf('%d%%...\n',ret*10);
            end
            
            load(fullfile(fea_folder,fea_dir(j).name));
            data = shot_sift;
            
            index = ComputeCentroidsDistance(double(data'),dictionary');
            
            feature = [index';[1:size(index,1);ones(1,size(index,1))]];
            sp_feature = sp(feature, height,width, pyramid);
            
             % save the index
            [~, fname] = fileparts(fea_dir(j).name);
            fpath = fullfile(index_folder, [fname, '_idx_sp.mat']);
            save(fpath, 'sp_feature');
            
            
        end     
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end