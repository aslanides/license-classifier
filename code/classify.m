function [plate,partitions] = classify(im,net,showme)
    % usage: [plate,partitions] = classify(im,net,showme)
    %
    % takes an image (im) as input,
    % partitions it, resizes it, and feeds it to the neural net (net)
    % and returns the neural net's output along with the image partitions.
    %
    % John Aslanides 3 May 2015
    % Last modified: 30 May 2015
    %
    
    if nargin == 0
        error('Input image required')
    elseif nargin == 1
        load('Data/net.mat');
        showme = true;
    elseif nargin ==2
        showme = true; 
    end
    
    if ~isinteger(im)
        error('Must pass in an image!')
    end
    
    sz = sqrt(net.inputs{1}.size);
    alphanum = strcat('0':'9','A':'Z');
    partitions = image_partition(im);
    N = length(partitions);
    plate = '';
    for i=1:N
        input = prepare_features(partitions{i},sz);
        output = net(input(:));
        [val idx] = max(output);
        plate = strcat(plate,alphanum(idx));
    end
    
    if showme
       figure
       subplot(2,N,1:N)
       imshow(im)
       for i=1:N
          subplot(2,N,N+i)
          imshow(partitions{i})
       end
    end
    
end