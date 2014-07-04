function CalculateSiftDescriptor(img_folder, data_folder)
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

subfolders = dir(img_folder);

%database_sift.img_num = 0; % total image number of the database
%database_sift.path = {}; % contain the pathes for each image of each class

for i = 1:length(subfolders),
    subname = subfolders(i).name;
    tic
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        frame_folder = fullfile(img_folder,subname);
        sift_folder = fullfile(data_folder,subname);
        %mkdir(sift_dir);
        
        fprintf('extracting sift feature for %s...\n',frame_folder);
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
            image = im2single(rgb2gray(image));
                      
            binSize = 8 ;
            magnif = 3 ;
            step = 3;
            image_smooth = vl_imsmooth(image, sqrt((binSize/magnif)^2 - .25)) ;
            [sift_kp, sift_des] = vl_dsift(image_smooth, 'size', binSize,'step',step) ;     % using the dense sift to extract the sift feature

            feature_set.sift_kp = sift_kp;            
            feature_set.sift_des = sift_des;
           
            % save the sift feature
            [~, fname] = fileparts(image_dir(j).name);                        
            fpath = fullfile(sift_folder, [fname, '_dsift.mat']);
            save(fpath, 'feature_set');
            %sift_path(j) = {fpath};
        end
        
        
        %database_sift.img_num = database_sift.img_num + image_num;
        %database_sift.path = [database_sift.path;sift_path(:)];
        toc
        fprintf('Processing for %s finished!\n',subname);
    end;
end;