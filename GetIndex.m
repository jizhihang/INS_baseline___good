function  GetIndex( dictionary,input_folder, output_folder )
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
            
             % save the index
            [~, fname] = fileparts(fea_dir(j).name);
            index_path = fullfile(index_folder,[fname, '_idx.mat']);
            save(index_path,'index');
            
            
        end     
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end