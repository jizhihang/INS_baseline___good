function dictionary = GetDictionary(feature_folder,dic_option)

%Select features
feature_dir = dir([feature_folder,'\*.mat']);
shot_num  = length(feature_dir);
feature_per_shot = dic_option.max_num/shot_num;

feature = [];  


for i = 1:shot_num
    load(fullfile(feature_folder,feature_dir(i).name));
    data = shot_sift;    
    rand_sel = randperm(size(data,2));
    if(floor(feature_per_shot)>length(rand_sel))
        sel_feature = data;
    else
        sel_feature = data(:,rand_sel(1:floor(feature_per_shot)));
    end    
    feature = [feature sel_feature];
end

%K-means by vl-feat library
[centers, assignments] = vl_kmeans(feature, dic_option.k);


dictionary = centers;

end