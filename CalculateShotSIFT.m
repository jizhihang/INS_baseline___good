function CalculateShotSIFT(img_folder, data_folder)
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

disp('Extracting SIFT features...');
% pay attention to the image format,all image of this format will be used
% to calculate the sift feature

subfolders_dir = dir(img_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders_dir)
    subname = subfolders_dir(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        frame_folder = fullfile(img_folder,subname);
        sift_folder = fullfile(data_folder,subname);
        %mkdir(sift_dir);
         if (~isdir(sift_folder))
            mkdir(sift_folder);
        end
        
        fprintf('Extracting SIFT feature for %s...\n',frame_folder);
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
            
            %image_dir(j).name = 'shot',shot_n,'_',tag,'_FF.jpg
            if (length(image_dir(j).name)>=8 && strcmp(image_dir(j).name(6),'_')==1 && strcmp(image_dir(j).name(8),'_')==1)
                tag = image_dir(j).name(7);
                shot_n = image_dir(j).name(5);
            elseif (length(image_dir(j).name)>=9 && strcmp(image_dir(j).name(6),'_')==1 && strcmp(image_dir(j).name(9),'_')==1)
                tag = image_dir(j).name(7:8);   
                shot_n = image_dir(j).name(5);
            elseif (length(image_dir(j).name)>=10 && strcmp(image_dir(j).name(6),'_')==1 && strcmp(image_dir(j).name(10),'_')==1)
                tag = image_dir(j).name(7:9);
                shot_n = image_dir(j).name(5);
            elseif (length(image_dir(j).name)>=11 && strcmp(image_dir(j).name(6),'_')==1 && strcmp(image_dir(j).name(11),'_')==1)
                tag = image_dir(j).name(7:10);  
                shot_n = image_dir(j).name(5);
				
			elseif (length(image_dir(j).name)>=9 && strcmp(image_dir(j).name(7),'_')==1 && strcmp(image_dir(j).name(9),'_')==1)
                tag = image_dir(j).name(8);  	
                shot_n = image_dir(j).name(5:6);
			elseif (length(image_dir(j).name)>=10 && strcmp(image_dir(j).name(7),'_')==1 && strcmp(image_dir(j).name(10),'_')==1)
                tag = image_dir(j).name(8:9); 
                shot_n = image_dir(j).name(5:6);
			elseif (length(image_dir(j).name)>=11 && strcmp(image_dir(j).name(7),'_')==1 && strcmp(image_dir(j).name(11),'_')==1)
                tag = image_dir(j).name(8:10); 
                shot_n = image_dir(j).name(5:6);
			elseif (length(image_dir(j).name)>=12 && strcmp(image_dir(j).name(7),'_')==1 && strcmp(image_dir(j).name(12),'_')==1)
                tag = image_dir(j).name(8:11); 	
                shot_n = image_dir(j).name(5:6);
				
			elseif (length(image_dir(j).name)>=10 && strcmp(image_dir(j).name(8),'_')==1 && strcmp(image_dir(j).name(10),'_')==1)
                tag = image_dir(j).name(9); 	
                shot_n = image_dir(j).name(5:7);
			elseif (length(image_dir(j).name)>=11 && strcmp(image_dir(j).name(8),'_')==1 && strcmp(image_dir(j).name(11),'_')==1)
                tag = image_dir(j).name(9:10);
                shot_n = image_dir(j).name(5:7);
			elseif (length(image_dir(j).name)>=12 && strcmp(image_dir(j).name(8),'_')==1 && strcmp(image_dir(j).name(12),'_')==1)
                tag = image_dir(j).name(9:11);
                shot_n = image_dir(j).name(5:7);
			elseif (length(image_dir(j).name)>=13 && strcmp(image_dir(j).name(8),'_')==1 && strcmp(image_dir(j).name(13),'_')==1)
                tag = image_dir(j).name(9:12);	
                shot_n = image_dir(j).name(5:7);
            end
            current_shot = str2num(tag);
            if (j == 1)
                 former_shot = current_shot;
            end

            if (current_shot == former_shot)
                %去掉重复的sift，保存到shot_sift
                if (j==1)
                    img_path = fullfile(frame_folder,image_dir(j).name);
                    image = imread(img_path);
                    if (numel(size(image))>2 )              
                        image = rgb2gray(image);
                    end
                    image = im2single(image);
                    [sift_location, sift_feature] = vl_sift(image) ;   
                    shot_sift = [sift_location; sift_feature];
                else
                    img_path = fullfile(frame_folder,image_dir(j).name);
                    image = imread(img_path);
                    if (numel(size(image))>2 )              
                        image = rgb2gray(image);
                    end
                    image = im2single(image);
                    [sift_location, sift_feature] = vl_sift(image) ;   
                    
                    current_sift = [sift_location; sift_feature];
                    [matches, scores] = vl_ubcmatch(shot_sift, current_sift);
                    diff = 1:size(current_sift,2);
                    diff = setdiff(diff,matches(2,:));
                    current_sift = current_sift(:,diff);
                    shot_sift = [shot_sift current_sift];
                end       
            else
                %保存shot_sift
                                     
                fpath = fullfile(sift_folder, ['shot',shot_n,'_',num2str(former_shot), '_sift.mat']);
                save(fpath, 'shot_sift');
                former_shot = current_shot;
                
                img_path = fullfile(frame_folder,image_dir(j).name);
                image = imread(img_path);
                if (numel(size(image))>2 )              
                    image = rgb2gray(image);
                end
                image = im2single(image);


                [sift_location, sift_feature] = vl_sift(image) ;
                shot_sift = [sift_location; sift_feature];
            end       
        end
        
        fpath = fullfile(sift_folder, ['shot',shot_n,'_',num2str(former_shot), '_sift.mat']);
        save(fpath, 'shot_sift');
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end
end
end