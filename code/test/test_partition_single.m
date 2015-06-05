function test_partition_single(partition_function,image)
    parts = partition_function(image);
    N = length(parts);
    figure
    for i=1:N+1
        subplot(1,N+1,i)
        if i==N+1
            imshow(image)
        else
            imshow(parts{i})
        end
        
    end

end