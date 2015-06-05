function out = prepare_features(img,out_size)
   % usage: output = prepare_input(img,size)
   %
   % crop letter, then resize to square, changing aspect ratio
   CC = bwconncomp(img);
   [I,J] = ind2sub(size(img),CC.PixelIdxList{1});
   out = img(min(I):max(I),min(J):max(J));
   out = imresize(out,[out_size out_size]);
end