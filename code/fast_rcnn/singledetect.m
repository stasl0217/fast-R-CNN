% current working dir: ./code/fast_rcnn
clear all
SET_SHORTER=600;

% load model
net = load('../../data/models/fast-rcnn-caffenet-pascal07-dagnn.mat');
net = preprocessNet(net);

% read and resize image
img = single(imread('../../example.jpg'));
[width, height,rgb] = size(img);
rate = SET_SHORTER/min(width,height);
img = imresize(img,rate);
avg = net.meta.normalization.averageImage;
for i = 1:3
    img(:,:,i) = img(:,:,i) - avg(:,:,i);
end
imshow(img)


% read and resize ROI
load('../../example_boxes.mat','boxes');
resized_box = single(boxes*rate);
forroi = transpose(resized_box);
[dimension, Nbox] = size(forroi);
RoIs = zeros(dimension+1, Nbox);
RoIs(1,:) = 1;
RoIs(2:end,:) = forroi; % 5*2888

net.eval({'data', single(img), 'rois', single(RoIs)})

score_all = transpose(squeeze(net.getVar('cls_prob').value)); % 2888*21 (21 classes)
deltas_all = transpose(squeeze(net.getVar('bbox_pred').value)); % 2888*84

save('modeloutput_single.mat','score_all','deltas_all')

% THEN execute plot1.m





