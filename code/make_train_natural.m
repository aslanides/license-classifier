load('Data/test.mat');

n = length(test);
N = 0;
for i=1:n
    parts = image_partition(test{i,1});
    N = N + length(parts);
end

sz = 1024;
numalpha = strcat('0':'9','A':'Z');
nsymb = numel(numalpha);
X = zeros(sz,N);
T = zeros(nsymb,N);

i=1;
j=1;
while i <= N
    parts = image_partition(test{j,1});
    plate = test{j,2};
    for k=1:length(parts)
       tmp = prepare_features(parts{k},sqrt(sz));
       X(:,i) = tmp(:);
       letter = strfind(numalpha,plate(k));
       T(letter,i) = 1;
       i = i + 1;
    end
    j = j + 1;
end

save('Data/train_natural.mat','X','T');