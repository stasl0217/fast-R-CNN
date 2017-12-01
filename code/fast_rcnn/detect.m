% current working dir: ./code/fast_rcnn
function [scores_all, deltas_all] = detect(net,img, proposals)
% K: maximum detections
% nms_threshold: suppress when overlapped percent > nms_threshold
% net: after preprocess
% img, proposals: data from file, no resizing
% scores_all: 2888*21 (21 classes, first for background)
% deltas_all: 2888*84 (4 per class)


% read and resize image
SHORTER=600;
img = single(img);
[width, height,rgb] = size(img);
rate = SHORTER/min(width,height);
resized_img = imresize(img,rate);
avg = net.meta.normalization.averageImage;
for i = 1:3
    resized_img(:,:,i) = resized_img(:,:,i) - avg(:,:,i);
end

resized_box = single(proposals*rate);
forroi = transpose(resized_box);
[dimension, Nbox] = size(forroi);
RoIs = zeros(dimension+1, Nbox);
RoIs(1,:) = 1;
RoIs(2:end,:) = forroi; % 5*2888

net.eval({'data', single(resized_img), 'rois', single(RoIs)})

scores_all = transpose(squeeze(net.getVar('cls_prob').value)); % 2888*21 (21 classes)
deltas_all = transpose(squeeze(net.getVar('bbox_pred').value)); % 2888*84








