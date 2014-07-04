function  ExtractKeyFrames(video_folder)
%UNTITLED2 Summary of this function goes here
%video_dir denotes the directory of video
%
%   Detailed explanation goes here
    
    %VideoName <244*19 char> includes the name of video, video_id = row-1
    %ShotInformation<471526*3 double> includes [video_id shot_start_frame
    %shot_end_frame] shot_id = 'shot'+video_id+'_'+ the row of this video_id

    
    disp(['Key Frame Extraction...']);   
    load('video_information.mat');
    data_dir = dir([video_folder,'/*.mp4']);
    dist_vector= [0];

    for i=1:length(data_dir)

        file_path = ['video/', data_dir(i).name];
        video = VideoReader(file_path);
        
        %number_of_frames = video.NumberOfFrames

        find_flag = 0; %0 for not found, 1 for found
        for row=1:244
            if (strcmp(VideoName(row,:),data_dir(i).name(1:19)) == 1)
                video_id =  row-1;
                find_flag = 1;
                break;
            end
        end
        if (find_flag ==0)
            disp([data_dir(i).name, 'has not been found in the list']);
        end

        row = find (ShotInformation(:,1) == video_id);
        shot_row_start = min(row);
        shot_row_end = max(row);
        shot_path = ['keyframe/shot',num2str(video_id)];
        mkdir(shot_path);

        for j =  shot_row_start : shot_row_end 
            frame_folder = [shot_path,'/shot',num2str(video_id), '_', num2str(j - shot_row_start + 1)];
            %mkdir(frame_dir);
            frame =  read(video, ShotInformation(j, 2)+1); 
            gray_frame = rgb2gray(frame);
            gray_frame(gray_frame<25)=0;
            frame_path = [frame_folder, '_', num2str(ShotInformation(j, 2)+1), '.jpg'];  
            imwrite(frame, frame_path, 'jpg');
            for frame_number = ShotInformation(j, 2)+2 :ceil((ShotInformation(j, 3)-ShotInformation(j, 2))/6) : ShotInformation(j, 3)+1       
                current_frame = read(video, frame_number);    
                current_gray_frame = rgb2gray(current_frame);
                current_gray_frame(current_gray_frame<25)=0;
                dist = CalculateEuclideanDistance(double(gray_frame)/255,double(current_gray_frame)/255);
                dist_vector = [dist_vector dist];
%             dist = pdist([double(max(gray_frame))/255;double(max(current_gray_frame))/255])

                if (dist >103)                
                    frame = current_frame;
                    gray_frame = current_gray_frame;                              
                    frame_path = [frame_folder, '_', num2str(frame_number), '.jpg'];                
                    imwrite(current_frame, frame_path, 'jpg');
                end

                if (frame_number + 5 >ShotInformation(j, 3) +1)
                     current_frame = read(video, ShotInformation(j, 3) +1);    
                     current_gray_frame = rgb2gray(current_frame);
                     current_gray_frame(current_gray_frame<25)=0;
                     dist = CalculateEuclideanDistance(double(gray_frame)/255,double(current_gray_frame)/255);
                     dist_vector = [dist_vector dist];
                     
                     if (dist >70)        

                          frame = current_frame;
                          gray_frame = current_gray_frame;                             
                          frame_path = [frame_folder, '_', num2str(ShotInformation(j, 3) +1), '.jpg'];         
                          imwrite(current_frame, frame_path, 'jpg');
                      end
                end

%             frame_path = [frame_folder, '/', num2str(frame_number), '.jpg'];    
%             imwrite(current_frame, frame_path, 'jpg');
            end
            disp(['shot',num2str(video_id), '_', num2str(j - shot_row_start + 1), ' is completed...']);
        end 
    end
end

