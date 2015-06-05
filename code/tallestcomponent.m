function [hor_crop,cropping] = tallestcomponent(img,dilation,CC,fullcrop)
    % get the tallest connected component in an image, return its 
    % vertical bounds (i.e. crop it out of img by making horizontal cuts)
    if nargin < 4
        fullcrop = false;
    end
    
    N = CC.NumObjects;
    if N == 0
        
       disp(N);
    end
    maxheight = 0;
    ymin=0;
    ymax=0;
    xmin=0;
    xmax=0;
    for i=1:N 
       [I,J] = ind2sub(size(dilation),CC.PixelIdxList{i});
       tmpmin = min(I);
       tmpmax = max(I);
       tmpheight = tmpmax - tmpmin;
       if tmpheight > maxheight
          maxheight = tmpheight;
          ymin = tmpmin;
          ymax = tmpmax;
          xmin = min(J);
          xmax = max(J);
       end
    end
    % crop to the tallest connected component
    % this will bound the glyphs from above and below
    if fullcrop
        hor_crop = img(ymin:ymax,xmin:xmax);
    else
        hor_crop = img(ymin:ymax,:);
    end
    cropping = [ymin ymax];
end