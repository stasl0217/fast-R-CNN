function suppress = should_suppress(current_boxes, new_box, threshold)
% suppress the new_box if its area overlapped with previous one (above
% threshold(0~1))
% current_boxes are assumed to have higher scores than the new box here
% box all in[x0 y0 x1 y1]
% matlab uses [x y w h] for retangles
suppress = false;  % defalut
[n, tmp] = size(current_boxes);
newbox_xywh = x1y1towh(new_box);
newbox_area = newbox_xywh(3)*newbox_xywh(4);
for i = 1:n
    b1_xywh = x1y1towh(current_boxes(i,:));
    intersection = rectint(newbox_xywh, b1_xywh);
    if intersection/newbox_area > threshold
        suppress = true;
    end
end