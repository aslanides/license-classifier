function net = make_net(hidden_units,X,T,reg)
    % usage: net = make_net(hidden_units,X,T)
    %
    % net = make_net(hidden_units) takes synthetic training data X,T
    % trains a neuralnetwork with hidden_units.
    %
    % John Aslanides, 20150503
    if nargin == 3
       reg = 0.0; 
    end
    net = patternnet(hidden_units);
    net.performParam.regularization = reg;
    [net,tr] = train(net,X,T);
    phome();
    save('Data/net.mat','net')
end