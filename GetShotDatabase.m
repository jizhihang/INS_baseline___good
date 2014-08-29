function GetShotDatabase( input_folder,output_folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('Getting Shot Database...');
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
    videoID = subname(5:end);
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        shot_folder = fullfile(input_folder,subname);
                
        fprintf('Getting database for %s...\n',shot_folder);
        file_format = '*.mat';
        shot_dir = dir(fullfile(shot_folder,file_format));
        
        
        shot_sig = zeros(length(shot_dir),2+21000);
        for j = 1:length(shot_dir)

            r = length(shot_dir(j).name)-16;
            s = length(videoID)+4+2;
            shotID = shot_dir(j).name(s:r);
            load(fullfile(shot_folder,shot_dir(j).name));
            data = [str2double(videoID) str2double(shotID) sp_feature];
            shot_sig(j,:) = data;
           
            
        end
        
        % save the sift feature
        fname = ['shot',videoID];                    
        fpath = fullfile(output_folder, [fname, '.mat']);
        save(fpath, 'shot_sig');
        
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end

end

