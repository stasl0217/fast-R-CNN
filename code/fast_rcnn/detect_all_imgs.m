%%% Problem 2.2
clear all

nms_threshold = 0.5;  % suppress when overlapped percent > nms_threshold
K = 100; % maximum detections after non-maximum suppresion

% load images and proposals
directory = '../../data/images/';
list_dir = dir(directory);
files = {list_dir.name};
files = files(3:end);  % remove '.', '..'
n = length(files); 
proposals_all = load('../../data/SSW/SelectiveSearchVOC2007test.mat','boxes')

% load model
net = load('../../data/models/fast-rcnn-caffenet-pascal07-dagnn.mat');
net = preprocessNet(net);

for i=1:1
    path = [directory, char(files(i))];
    img = imread(path);
    proposal = proposals_all(i);
    proposal = transpose(proposal{1,1});
    net1 = net;  % copy
    [scores_all, deltas_all] = detect(net, proposals);
	%...
end
