%Change file name

clc;
clear;

addpath('keyframe with shot directory');
addpath('keyframe');

keyframe_folder = ('keyframe');
shot_dir = dir('keyframe with shot directory');
shot_name_tag = 0;
mkdir([keyframe_folder, '/shot0']);

for i = 1:length(shot_dir)
    
    if (~strcmp(shot_dir(i).name, '.') && ~strcmp(shot_dir(i).name, '..'))
       
        if (length(shot_dir(i).name)>=6 && strcmp(shot_dir(i).name(6),'_')==1)
            tag = shot_dir(i).name(5);
        end
        if (length(shot_dir(i).name)>=7 && strcmp(shot_dir(i).name(7),'_')==1)
            tag = shot_dir(i).name(5:6);
        end
        if (length(shot_dir(i).name)>=8 && strcmp(shot_dir(i).name(8),'_')==1)
            tag = shot_dir(i).name(5:7);
        end
        if (strcmp(tag, num2str(shot_name_tag))==0)
            shot_name_tag = tag;
            mkdir([keyframe_folder, '/shot', num2str(shot_name_tag) ]);
        end
        keyframe_dir = dir(['keyframe with shot directory/',shot_dir(i).name,'/*.jpg']);
        keyframe_num = length(keyframe_dir);
        
        for j =1:keyframe_num
            img = imread(['keyframe with shot directory/', shot_dir(i).name,'/', keyframe_dir(j).name]);
            img_name = [shot_dir(i).name, '_', keyframe_dir(j).name];
            imwrite(img, [keyframe_folder, '/shot', num2str(shot_name_tag),'/', img_name], 'jpg');
            
            
        end
        disp([shot_dir(i).name,' is done']);
    end
    
end