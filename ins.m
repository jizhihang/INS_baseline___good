%% Instance Search____Baseline_____v1.1
% ins.m
%TRECVid2014 INS task
%pkusz_emlt
%@author Zheng Zi'ou
%@2014.4.14
%

%% Initialization
clear ; close all; clc;

%setup vl-feat library
%addpath('vlfeat-0.9.18');
run('vlfeat-0.9.18\toolbox\vl_setup');


skip_extract_keyframe = true;
skip_extract_keyframe_for_codebook = true;
skip_extract_dictionary = true;
skip_extract_shot_sift = false;
skip_extract_index = false;

height = 576;
width = 768;


%% ================== Part 1: Keyframe Extraction  ===============
%
%
if(~skip_extract_keyframe)   
    addpath('video');
    ExtractKeyFrames('video');     
end

%% ================== Part 2: Build up Codebook ==================
%
%
%Extract feature for codebook
if (~skip_extract_keyframe_for_codebook)
    ChooseKeyFrameForCodebook('keyframe\shot0','codebook\keyframe');
    CalculateMSER('codebook\keyframe','codebook\MSER')
    CalculateImageMSER_r('codebook\MSER','codebook\keyframe','codebook\keyframe_MSER')
    CalculateShotSIFT('codebook\keyframe_MSER','codebook\SIFT')
end

% training the visual word dictionary
dic_option.max_num = 1000000;
dic_option.k = 1000;

dic_path = fullfile('codebook\dictionary','dic_',[num2str(dic_option.max_num),'_',num2str(dic_option.k),'_mser_sift','.mat']);
if ~isdir('codebook\dictionary')
    mkdir('codebook\dictionary');
end
if (~skip_extract_dictionary)
    dictionary = GetDictionary('codebook\SIFT\shot0',dic_option);
    save(dic_path,'dictionary');
end


%% ================== Part 3: Offline Database ===================

if (length(dir('feature'))<247)
    for i = 0:244  
        name = ['shot',num2str(i)]; 
        path = ['feature\SIFT\',name];
        mkdir(path); 
    end
end
% extract SIFT feature from all key frames
if(~skip_extract_shot_sift)
    CalculateMSER('keyframe','feature\MSER')
    CalculateImageMSER_r('feature\MSER','keyframe','keyframe_MSER')
    CalculateShotSIFT('keyframe_MSER','feature\SIFT')    

end

% %Get Index according to the codebook
% if (~skip_extract_index)
%     load(dic_path);
%     GetIndex(dictionary,'feature\SIFT','feature\SIFT_index');
% end
% 
% %Do Max Pooling similiar to spatial pyramid
% pyramid = [1, 2, 4];               % spatial block number on each level of the pyramid
% DoPooling('feature\SIFT_index','feature\SIFT_index_sp',pyramid);

%OR------------------------
if (~skip_extract_index)
    load(dic_path);
    pyramid = [1, 2, 4];               % spatial block number on each level of the pyramid
    GetIndexPooling(dictionary,'feature\SIFT','feature\SIFT_index_sp',pyramid, height, width);
end

GetShotDatabase('feature\SIFT_index_sp','shot_sig');

%% ================== Part 4: Process Instance ===================

%transfer bmp to jpg
BMPtoJPG('ins\ori_bmp','ins\ori_jpg');

%Get Instance and Environment
GetInstance('ins\ori_jpg','ins');

CalculateMSER('ins\instance','ins\feature\instance\MSER')
CalculateMSER('ins\environment','ins\feature\environment\MSER')

CalculateImageMSER_r('ins\feature\instance\MSER','ins\instance','ins\instance_r')
CalculateImageMSER_r('ins\feature\environment\MSER','ins\environment','ins\environment_r')

CalculateSIFT('ins\instance_r','ins\feature\instance\SIFT')
CalculateSIFT('ins\environment_r','ins\feature\environment\SIFT')

GetInstanceSIFT('ins\feature\instance\SIFT','ins\feature\environment\SIFT','ins\feature\ins_SIFT')
GetIndexPoolingIns(dictionary,'ins\feature\ins_SIFT','ins\feature\ins_SIFT_idx_sp',pyramid);
% GetIndex(dictionary,'ins\feature\ins_SIFT','ins\feature\ins_SIFT_index');
% 
% DoPooling('ins\feature\ins_SIFT_index','ins\feature\ins_SIFT_index_sp',pyramid);

%% ======================= Part 5: Ranking ======================

SearchShot('ins\feature\ins_SIFT_idx_sp','shot_sig','result')





