function [K_boxes, K_scores] = get_top_K(boxes, score, K, nms_percent)
% with non-maximum suppression
% nms_percent: overlapping area>percent => suppress
% box: [x0 y0 x1 y1]
[sortedValues,sortIndex] = sort(score(:),'descend');
sorted_boxes = boxes(sortIndex,:);  % ranking by score desc

K_boxes = zeros(K, 4); % K boxes
K_scores = zeros(K, 1);

% initialize
K_boxes(1,:) = sorted_boxes(1,:);
count = 1; % how many found already
i_box = 2;  % index when sacnning boxes

while count<K
    new_box = sorted_boxes(i_box,:);
    if ~should_suppress(K_boxes(1:count,:), new_box, nms_percent)
        K_boxes(count,:) = new_box;
        K_scores(count)= sortedValues(i_box);
        count = count+1;
    end    
    i_box = i_box+1;
end
