function SearchShot( ins_folder, shot_folder, output_folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
shot_matrix(1:100,1) = 's';
shot_matrix(1:100,2) = 'h';
shot_matrix(1:100,3) = 'o';
shot_matrix(1:100,4) = 't';

slash_matrix(1:100,1) = '_';



% pay attention to the image format,all image of this format will be used
% to calculate the sift feature
if (~isdir(output_folder))
    mkdir(output_folder);
end

ins_dir = dir(fullfile(ins_folder,'*.mat'));

% subfolders_dir = dir(shot_folder);


for i = 1:length(ins_dir)
   insID = ins_dir(i).name(1:4);
   load(fullfile(ins_folder, ins_dir(i).name));
   ins_fea = sp_feature;
   fprintf('\nSearching result for %s...\n',insID);
   tic
   shot_dir = dir(fullfile(shot_folder,'*.mat'));
   result = zeros(length(shot_dir)*100,3);
   
   for j = 1:length(shot_dir)
        if (mod(j, 10) == 0)
            fprintf('.');
            if (mod(j,200) == 0)
                fprintf('\n');
            end
        end
        load(fullfile(shot_folder, shot_dir(j).name));
        shot_fea = shot_sig;
        
        shot_scores = zeros(size(shot_fea,1),3);
        shot_scores(:,1:2) = shot_fea(:, 1:2);
        shot_scores(:,3) = shot_fea(:,3:end) * ins_fea';
        shot_scores(find(isnan(shot_scores)==1)) = 0;
        [drop, pos] = sortrows(shot_scores,-3);
        result(((j-1)*100+1):( j*100),:) = drop(1:100,:);
        
   end
   [drop,pos] = sortrows(result,-3);
   toc
   res = drop(1:100,:);
   save([output_folder,'\',insID,'_res.mat'],'res');
   fprintf('\nSearching result for %s... is done!\n',insID);
   
   print_matrix = [shot_matrix, num2str(res(:,1)),slash_matrix, num2str(res(:,2))]
   
   %pause;
end

end