function showpass(candidates,pass)
    figure
    N = length(candidates);
    passing = 0;
    for i=1:N
       if pass(i)
          imshow(candidates{i})
          passing = passing + 1;
          pause
       end
    end
    disp([num2str(passing), ' candidates passing'])
    close 
end