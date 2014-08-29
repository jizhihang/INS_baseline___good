function DoSearch( input_folder )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
disp('Doing Search...');

subfolders_dir = dir(input_folder);
for i = 1:length(subfolders_dir)
    subname = subfolders_dir(i).name;
    if (~strcmp(subname, '.') && ~strcmp(subname, '..'))
        insID = subfolders_dir(i).name(1:4);
        img_folder = fullfile(input_folder,subname);
        src1 = imreaed([img_folder,'\',insID,'.1.src.jpg']);
        src2 = imreaed([img_folder,'\',insID,'.2.src.jpg']);
        src3 = imreaed([img_folder,'\',insID,'.3.src.jpg']);
        src4 = imreaed([img_folder,'\',insID,'.4.src.jpg']);
        mask1 = imreaed([img_folder,'\',insID,'.1.mask.jpg']);
        mask2 = imreaed([img_folder,'\',insID,'.2.mask.jpg']);
        mask3 = imreaed([img_folder,'\',insID,'.3.mask.jpg']);
        mask4 = imreaed([img_folder,'\',insID,'.4.mask.jpg']);
        tic
        idx = find(mask1 ~= 0);
        mask1(idx) = 1;
        ins1 = immultiply(mask1,src1);
        bg1 = imsubtract(src1,ins1);
        
        idx = find(mask2 ~= 0);
        mask2(idx) = 1;
        ins2 = immultiply(mask2,src2);
        bg2 = imsubtract(src2,ins2);
        
        idx = find(mask3 ~= 0);
        mask3(idx) = 1;
        ins3 = immultiply(mask3,src3);
        bg3 = imsubtract(src3,ins3);
        
        idx = find(mask4 ~= 0);
        mask4(idx) = 1;
        ins4 = immultiply(mask4,src4);
        bg4 = imsubtract(src4,ins4);
        
        
        %Img_MSER
        ins1 = uint8(rgb2gray(ins1));
        [r, f] = vl_mser(ins1,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(ins1)) ;
        for x=r'
            s = vl_erfill(ins1, x) ;
            M(s) = M(s) + 1;
        end
        ins1_r = uint8(M).*ins1;     
        
        ins2 = uint8(rgb2gray(ins2));
        [r, f] = vl_mser(ins2,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(ins2)) ;
        for x=r'
            s = vl_erfill(ins2, x) ;
            M(s) = M(s) + 1;
        end
        ins2_r = uint8(M).*ins2;   
        
        ins3 = uint8(rgb2gray(ins3));
        [r, f] = vl_mser(ins3,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(ins3)) ;
        for x=r'
            s = vl_erfill(ins3, x) ;
            M(s) = M(s) + 1;
        end
        ins3_r = uint8(M).*ins3;   
        
        ins4 = uint8(rgb2gray(ins4));
        [r, f] = vl_mser(ins4,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(ins4)) ;
        for x=r'
            s = vl_erfill(ins4, x) ;
            M(s) = M(s) + 1;
        end
        ins4_r = uint8(M).*ins4;   
        
        bg1 = uint8(rgb2gray(bg1));
        [r, f] = vl_mser(bg1,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(bg1)) ;
        for x=r'
            s = vl_erfill(bg1, x) ;
            M(s) = M(s) + 1;
        end
        bg1_r = uint8(M).*bg1;   
        
        bg2 = uint8(rgb2gray(bg2));
        [r, f] = vl_mser(bg2,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(bg2)) ;
        for x=r'
            s = vl_erfill(bg2, x) ;
            M(s) = M(s) + 1;
        end
        bg2_r = uint8(M).*bg2; 
        
        bg3 = uint8(rgb2gray(bg3));
        [r, f] = vl_mser(bg3,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(bg3)) ;
        for x=r'
            s = vl_erfill(bg3, x) ;
            M(s) = M(s) + 1;
        end
        bg3_r = uint8(M).*bg3; 
        
        bg4 = uint8(rgb2gray(bg4));
        [r, f] = vl_mser(bg4,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;    % using the dense sift to extract the sift feature
        % compute regions mask
        M = zeros(size(bg4)) ;
        for x=r'
            s = vl_erfill(bg4, x) ;
            M(s) = M(s) + 1;
        end
        bg4_r = uint8(M).*bg4; 
        
        %Calculate SIFT
        ins1_s = im2single(ins1);
        [sift_loc_ins1, sift_fea_ins1] = vl_sift(ins1_s) ;
        
        ins2_s = im2single(ins2);
        [sift_loc_ins2, sift_fea_ins2] = vl_sift(ins2_s) ;
        
        ins3_s = im2single(ins3);
        [sift_loc_ins3, sift_fea_ins3] = vl_sift(ins3_s) ;
        
        ins4_s = im2single(ins4);
        [sift_loc_ins4, sift_fea_ins4] = vl_sift(ins4_s) ;
        
        bg1_s = im2single(bg1);
        [sift_loc_bg1, sift_fea_bg1] = vl_sift(bg1_s) ;
        
        bg2_s = im2single(bg2);
        [sift_loc_bg2, sift_fea_bg2] = vl_sift(bg2_s) ;
        
        bg3_s = im2single(bg3);
        [sift_loc_bg3, sift_fea_bg3] = vl_sift(bg3_s) ;
        
        bg4_s = im2single(bg4);
        [sift_loc_bg4, sift_fea_bg4] = vl_sift(bg4_s) ;
        
        %Get Instance SIFT
        feature_en = [];    %sift 4 times in the environment(not ROI)
        feature_diff_en = []; %sift 3 times in the environment(not ROI)
        feature_ins = [];   %sift in instance(in ROI)
        %bg
        %1
        feature_en = sift_fea_bg1;
        %2
        data = sift_fea_bg2;
        [matches, scores] = vl_ubcmatch(feature_en, data);

        diff2 = 1:size(data,2);
        diff2 = setdiff(diff2,matches(2,:));
        feature_diff_en = data(:,diff2);

        diff1 = 1:size(feature_en,2);
        diff1 = setdiff(diff1,matches(1,:));
        temp = feature_en(:,diff1);
        feature_diff_en = [feature_diff_en temp];

        feature_en = feature_en(:,matches(1,:));
        %3
        data = sift_fea_bg3;
        [matches, scores] = vl_ubcmatch(feature_diff_en, data);                
        feature_diff_en = feature_diff_en(:,matches(1,:));

        [matches, scores] = vl_ubcmatch(feature_en, data);

        diff1 = 1:size(feature_en,2);
        diff1 = setdiff(diff1,matches(1,:));                
        temp = feature_en(:,diff1);
        feature_diff_en = [feature_diff_en temp];

        feature_en = feature_en(:,matches(1,:));
        %4
        data = sift_fea_bg5;
        [matches, scores] = vl_ubcmatch(feature_diff_en, data);                
        feature_diff_en = feature_diff_en(:,matches(1,:));

        [matches, scores] = vl_ubcmatch(feature_en, data);

        diff1 = 1:size(feature_en,2);
        diff1 = setdiff(diff1,matches(1,:));                
        temp = feature_en(:,diff1);
        feature_diff_en = [feature_diff_en temp];

        feature_en = feature_en(:,matches(1,:));
        
        %ins
        %1
        feature_ins = sift_fea_ins1;
        %2
        data = sift_fea_ins2;
        [matches, scores] = vl_ubcmatch(feature_ins, data);

        diff = 1:size(data,2);
        diff = setdiff(diff,matches(2,:));
        data = data(:,diff);
        feature_ins = [feature_ins data];
        %3
        data = sift_fea_ins3;
        [matches, scores] = vl_ubcmatch(feature_ins, data);

        diff = 1:size(data,2);
        diff = setdiff(diff,matches(2,:));
        data = data(:,diff);
        feature_ins = [feature_ins data];
        %4
        data = sift_fea_ins4;
        [matches, scores] = vl_ubcmatch(feature_ins, data);

        diff = 1:size(data,2);
        diff = setdiff(diff,matches(2,:));
        data = data(:,diff);
        feature_ins = [feature_ins data];
        
        shot_represent = [feature_ins feature_en feature_diff_en];
        
        %Get Index
        load('codebook\dictionary\dic_1000000_1000_mser_sift.mat');
        index = ComputeCentroidsDistance(double(shot_represent'),dictionary');
        feature = [index';[1:size(index,1);ones(1,size(index,1))]];
        pyramid = [1, 2, 4];
        sp_feature = sp(feature,1, size(index,1), pyramid);
        
        toc
        
        pause;
    end
end
end

