phome();

f = fopen('Data/test.txt');
C = textscan(f,'%s %s %s',1000);
fclose(f);

N = length(C{1});
test = cell(N,2);

for i=1:N
    test{i,1} = imread(strcat('Plates/',C{1}{i},'/',C{2}{i},'.jpg'));
    test{i,2} = C{3}{i};
end

save('Data/test.mat','test')