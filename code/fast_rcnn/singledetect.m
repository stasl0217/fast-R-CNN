%%% problem2.1

% current working dir: ./code/fast_rcnn
clear all


% load model
net = load('../../data/models/fast-rcnn-caffenet-pascal07-dagnn.mat');
net = preprocessNet(net);

% read and resize image
img = single(imread('../../example.jpg'));

% read and resize ROI
boxes = load('../../example_boxes.mat');
boxes = boxes.boxes;  % struct

[score_all, deltas_all] = detect(net,img, boxes);

i_car = get_class_index('car');
score = score_all(:,i_car);
delta = deltas_all(:,(i_car-1)*4+1:i_car*4);

load('../../example_boxes.mat','boxes');

K = 100;  % maximum detections
nms_threshold = 0.5;  % suppress when overlapped area > 50%
[K_boxes, K_scores]= get_top_k(boxes, score, delta, K,nms_threshold);


figure(1)
thresholds = 0:0.01:1;
n_thres = length(thresholds);
num_detections = zeros(n_thres,1);
for i = 1:n_thres
    num_detections(i) = length(K_scores(K_scores>thresholds(i)));
end
plot(thresholds, num_detections);
title('No. Thresholds vs detections(after nms)')
xlabel('threshold')
ylabel('number of detections')


figure(2)
chosen_thres = 0.5;
% detections after non-maximum suppression
% read and resize image
img = imread('../../example.jpg');  % reload (cannot show SINGLE datatype), use the unresized img
imshow(img)
hold on
% draw retangles
above_thres = length(K_scores(K_scores>chosen_thres));
for i=1:above_thres
    box = K_boxes(i,:);
    rectangle('Position', x1y1towh(box),'Curvature',[0,0],'LineWidth',2,'LineStyle','-','EdgeColor','r')
    text(box(1),box(2), num2str(K_scores(i)), 'Color','yellow');
    hold on
end






