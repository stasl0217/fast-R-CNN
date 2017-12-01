function [K_boxes, K_scores, count] = get_top_k(proposal, score, delta, K, nms_percent)
% with non-maximum suppression
% nms_percent: overlapping area>percent => suppress
% box: [x0 y0 x1 y1]

boxes = bbox_transform_inv(single(proposal), delta); 
[sorted_scores,sortIndex] = sort(score(:),'descend');
sorted_boxes = boxes(sortIndex,:);  % ranking by score desc

K_boxes = zeros(K, 4); % K boxes
K_scores = zeros(K, 1);

% initialize
K_boxes(1,:) = sorted_boxes(1,:);
K_scores(1) = sorted_scores(1);
count = 1; % how many found already
i_box = 2;  % index when sacnning boxes

while count<K && i_box < length(sorted_boxes)
    new_box = sorted_boxes(i_box,:);
    if ~should_suppress(K_boxes(1:count,:), new_box, nms_percent)
        count = count+1;
        K_boxes(count,:) = new_box;
        K_scores(count)= sorted_scores(i_box);        
    end    
    i_box = i_box+1;
end

K_boxes = K_boxes(1:count,:);
K_scores = K_scores(1:count);
