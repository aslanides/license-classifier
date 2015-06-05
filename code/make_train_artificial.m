% this takes like an hour to run, beware
phome();
dirs=dir('Sample*');
% PARAM
sz = 32;

numalpha = strcat('0':'9','A':'Z');
nsy = numel(numalpha);

N=0;
for i=1:nsy
   cd(dirs(i).name)
   files = dir('*.png');
   N = N + length(files);
   cd('..')
end

X  = zeros(sz^2,N);
T = zeros(nsy,N);

n=1;
figure
for i=1:nsy
   cd(dirs(i).name)
   files = dir('*.png');
   
   tic
   for j=1:length(files)
      img = imcomplement(imread(files(j).name));
      img = prepare_features(img,sz);
      imshow(img)
      X(:,n) = img(:);
      T(i,n) = 1;
      n = n + 1;
      drawnow
   end
   toc
   cd('..')
end
X=X>127;
cd('../Data')
save('train_artificial.mat','X','T','-v7.3')
