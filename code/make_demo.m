phome();

f = fopen('Data/demo.txt');
C = textscan(f,'%s %s',1000);
fclose(f);

N = length(C{1});
test = cell(N,2);

for i=1:N
    test{i,1} = imread(strcat('Demo/plate-',C{1}{i},'.jpg'));
    test{i,2} = C{2}{i};
end

save('Data/demo.mat','test')