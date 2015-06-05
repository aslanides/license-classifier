function bad_images = test_partition(partition_function,source)
    phome();
    if nargin == 1
        load('Data/test.mat');
    else
        load(strcat('Data/',source,'.mat'));
    end
    
    N = length(test);
    warning('off','images:initSize:adjustingMag');
    bad_images = [];
    for i=1:N
        img = test{i,1};
        parts = partition_function(img);
        
        if length(parts) ~= length(test{i,2});
            bad_images = [bad_images i];
            figure
            for j=1:length(parts)+1
                subplot(1,length(parts)+1,j)
                if j==length(parts)+1
                    imshow(img)
                else
                    imshow(parts{j})
                end
            end
        end
    end
end