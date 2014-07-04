%% Instance Search____Baseline_____v1.0
% ins.m
%TRECVid2014 INS task
%pkusz_emlt
%@author Zheng Zi'ou
%@2014.4.14
%

%% Initialization
clear ; close all; clc;


addpath('keyframe');
addpath('feature');
addpath('codebook');

%setup vl-feat library
addpath('vlfeat-0.9.18');
run('vlfeat-0.9.18/toolbox/vl_setup')


skip_extract_keyframe = true;
skip_extract_keyframe_for_codebook = false;
skip_extract_sift = true;

skip_extract_dictionary = false;

skip_compute_kf_sig = false;



%% ================== Part 1: Keyframe Extraction  ===================
%
%
if(~skip_extract_keyframe)   
    addpath('video');
    ExtractKeyFrames('video');     
end


%% ================== Part 2: Build up Codebook ===================
%
%
if (~skip_extract_keyframe_for_codebook)
    ChooseKeyFrameForCodebook('keyframe/shot0','codebook/keyframe');
end


if (length(dir('feature'))<247)
    for i = 0:244  
        name = ['shot',num2str(i)]; 
        path = ['feature/DSIFT/',name];
        mkdir(path); 
    end
end
if(~skip_extract_sift)
    CalculateSiftDescriptor('keyframe','feature/DSIFT');
else
    %dsift_database = retrievalDatabase('feature/DSIFT','*_dsift.mat');
end


%% ================== Part 3: Estimate the dataset statistics ===================

