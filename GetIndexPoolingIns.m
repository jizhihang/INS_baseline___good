function  GetIndexPoolingIns( dictionary,input_folder, output_folder,pyramid )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp('Extracting Index...');

if (~isdir(output_folder))
    mkdir(output_folder);
end
subfolders_dir = dir([input_folder,'/*.mat']);


for i = 1:length(subfolders_dir),
    subname = subfolders_dir(i).name;
    
    insID = subname(1:4);
    load(fullfile(input_folder,subname));
    
    %method: ins sift+ environment 3+ sift
    ins_sift =  [feature_ins feature_en feature_diff_en];
            
    index = ComputeCentroidsDistance(double(ins_sift'),dictionary');

    feature = [index';[1:size(index,1);ones(1,size(index,1))]];
    sp_feature = sp(feature,1, size(index,1), pyramid);

     % save the index
   
    fpath = fullfile(output_folder, [subname, '_idx_sp.mat']);
    save(fpath, 'sp_feature');
         
end
   
end
