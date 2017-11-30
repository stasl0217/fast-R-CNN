%%% problem2.1

% current working dir: ./code/fast_rcnn
clear all
SET_SHORTER=600;
draw_img = true;

% load model
net = load('../../data/models/fast-rcnn-caffenet-pascal07-dagnn.mat');
net = preprocessNet(net);

% read and resize image
img = single(imread('../../example.jpg'));
[width, height,rgb] = size(img);
rate = SET_SHORTER/min(width,height);
resized_img = imresize(img,rate);
avg = net.meta.normalization.averageImage;
for i = 1:3
    resized_img(:,:,i) = resized_img(:,:,i) - avg(:,:,i);
end


% read and resize ROI
load('../../example_boxes.mat','boxes');
resized_box = single(boxes*rate);
forroi = transpose(resized_box);
[dimension, Nbox] = size(forroi);
RoIs = zeros(dimension+1, Nbox);
RoIs(1,:) = 1;
RoIs(2:end,:) = forroi; % 5*2888

net.eval({'data', single(resized_img), 'rois', single(RoIs)})

score_all = transpose(squeeze(net.getVar('cls_prob').value)); % 2888*21 (21 classes)
deltas_all = transpose(squeeze(net.getVar('bbox_pred').value)); % 2888*84

save('modeloutput_single.mat','score_all','deltas_all')

i_car = 8;
score = score_all(:,i_car);
delta = deltas_all(:,(i_car-1)*4+1:i_car*4);

load('../../example_boxes.mat','boxes');
pred_box = bbox_transform_inv(single(boxes), delta);  % 2888*84 (4 columns per class)

K = 100;  % maximum detections
nms_threshold = 0.5;  % suppress when overlapped area > 50%
[K_boxes, K_scores]= get_top_k(pred_box, score,K,nms_threshold);


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
img = imread('../../example.jpg');  % reload (cannot show SINGLE datatype)
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






