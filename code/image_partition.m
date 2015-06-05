function output = image_partition(input,run)
    % Usage: output = image_partition(img).
    %
    % Takes an RGB image as input, and returns a cell of binary
    % images, which are the partitioning of the image.
    %
    % John Aslanides 22 April 2015
    % Last modified: 30 May 2015
    
    if nargin == 1
        run = 1;
    end
    
    img = input;
    sz = size(input);
    
    % crop image border
    img = imcrop(img,[0.03*sz(2) 0.1*sz(1) 0.94*sz(2) 0.8*sz(1)]);
    % take green channel only
    img = img(:,:,2);
    % threshold
    %img = im2bw(img,110.0/256.0);
    img = im2bw(img,graythresh(img));
    % take image complement
    if run==1
        img = imcomplement(img);
    end
    % dilate horizontally
    hor_dilate = imdilate(img,ones(1,30));
    % compute connected components of dilated image
    CC = bwconncomp(hor_dilate);
    % find tallest component in dilated image, and crop to that
    hor_crop = tallestcomponent(img,hor_dilate,CC);
    
    % now dilate vertically
    vert_dilate = imdilate(hor_crop,ones(30,1));
    % get connected components
    CC = bwconncomp(vert_dilate);
    N = CC.NumObjects;
    
    % we now have N candidate image regions
    % some of them might overlap. if so, take the bigger of the two
    % and discard the other (if the disparity is large enough)
    candidates = cell(N,1);
    current_pos = 0;
    current_size = 0;
    for i=1:N
        [~,J] = ind2sub(size(hor_crop),CC.PixelIdxList{i});
        if min(J) < current_pos && max(J)-min(J) < 0.4*current_size% overlaps
            if max(J) - min(J) > current_size % this one is significantly bigger
                candidates{i-1} = zeros(2,2); % discard the last one
            else
                candidates{i} = zeros(2,2); % else discard this one
                continue
            end
        end
            candidates{i} = hor_crop(:,min(J):max(J));
            current_pos = max(J);
            current_size = max(J) - min(J);
    end
    
    % they're all passing until we find a reason to fail them
    pass = ones(N,1);

    % fail the candidate if it's 90% black or 90% white
    for i=1:N
       if pass(i)
          candidate_size = numel(candidates{i});
          candidate_sum = sum(sum(candidates{i}));
          if candidate_sum < 0.1*candidate_size || candidate_sum > 0.95*candidate_size
              pass(i) = 0;
          end
       end
    end
    
    % get rid of other junk in candidate
    for i=1:N
        if pass(i)
           CC = bwconncomp(candidates{i});
           candidates{i} = tallestcomponent(candidates{i},candidates{i},CC,true);
        end
    end   
    % fail the candidate if its aspect ratio is out of bounds
    for i=1:N
        if pass(i)
            dims = size(candidates{i});
            aspect_ratio = dims(1)/dims(2);
            if (aspect_ratio > 10) || (aspect_ratio < 1) || (dims(1) < sz(1)/3)
               pass(i) = 0;
            end
        end
    end    
    % trim the dongles off the candidates
    for i=1:N
        if pass(i)
           sz_candi = size(candidates{i});
           if sz_candi(2) < 100
               str_el = 5;
           else
               str_el = 10;
           end
           closed_candidate = imopen(candidates{i},ones(1,str_el));
           CC = bwconncomp(closed_candidate);
           % only accept the trim if the result is >80% the height of the
           % original
           
           proposal = tallestcomponent(candidates{i},closed_candidate,CC,false);
           sz_proposal = size(proposal);
           
           if sz_proposal(1) > 0.8*sz_candi(1)
              candidates{i} = proposal; 
           end
        end
    end
    
    % true candidates should all be roughly the same height
    heights = zeros(sum(pass),1);
    j=1;
    for i=1:N
       if pass(i)
          candi_size = size(candidates{i});
          heights(j) = candi_size(1);
          j = j +1;
       end
    end
    
    good_height = mode(heights);
    %good_height = median(heights);
    
    % fail the nonconfirmists
    for i=1:N
       if pass(i)
           candi_size = size(candidates{i});
           if abs(candi_size(1) - good_height)/good_height > 0.10
              pass(i) = 0; 
           end
       end
    end
    
    % collect the finalists and count them
    output = cell(0);
    j = 1;
    for i=1:N
       if pass(i)
           output{j} = candidates{i};
           j = j + 1;
       end
    end
    
    % if fewer than 3 (!) made it through, try again with different
    % settings
    
    if run == 6
        return
    end
      
    if length(output) < 3 
        if run==1
            % invert colors
            output = image_partition(input,run+1);
        else
            % try to pull out something useful from what we've got
            % and try again with that
            bigcc = bwconncomp(hor_crop);
            new_img = tallestcomponent(hor_crop,hor_crop,bigcc);
            new_sz = size(new_img);
            new_img_rgb = zeros(new_sz(1),new_sz(2),3);
            for i=1:3
               new_img_rgb(:,:,i) = new_img; 
            end
            output = image_partition(new_img_rgb);
        end
    end
    
    % finally, perform median filtering to denoise a bit
    for i=1:length(output)
       output{i} = medfilt2(output{i},[5 5]);
    end
    
    
end