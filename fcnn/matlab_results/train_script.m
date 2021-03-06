% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 29-Dec-2021 16:07:30
%
% This script assumes these variables are defined:
%
%   data - input data.
%   data_1 - target data.

% x_original = load("descriptors.csv");
% t_original = load("targets.csv");
x = load("descriptors.csv");
t = load("targets.csv");
% bootstrapping
% list = 1:208;
% idx = list(randi(numel(list), 1, 208));
% 
% x = [];
% t = [];
% 
% for i = list
%     n = idx(i);
%     x = cat(2, x, x_original(:,n));
%     t = cat(2, t, t_original(n));
% end

trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 5;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 0/100;
net.divideParam.testRatio = 30/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
% valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
% valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

train_list = 1:146
test_list = 1:62
train_des = []
train_tar = []
test_des = []
test_tar = []
for i = train_list
    b = tr.trainInd(i);
    train_des = cat(2, train_des, x(:,b));
    train_tar = cat(2, train_tar, t(b));
end
dlmwrite("train_des.csv", train_des)
dlmwrite("train_tar.csv", train_tar)
for i = test_list
    c = tr.testInd(i);
    test_des = cat(2, test_des, x(:,c));
    test_tar = cat(2, test_tar, t(c));
end
dlmwrite("test_des.csv", test_des)
dlmwrite("test_tar.csv", test_tar)

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end

% calculate predicted y
y = net(x)
dlmwrite("trained_results.csv", y)