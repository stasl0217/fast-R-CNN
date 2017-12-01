function suppress = should_suppress(boxes_to_compare, new_box, threshold)
% Compare the box with each baseline box
% if the overlapped area > area(box)*threshold
% return true(should suppress), else false
%
% This function can also be used to see if one box belongs to the ground
% truth. If suppress=yes, it's a true positive (overlapped with ground
% truth)
%
% current_boxes are assumed to have higher scores than the new box here
% box all in[x0 y0 x1 y1]
% matlab uses [x y w h] for retangles


suppress = false;  % defalut
[n, tmp] = size(boxes_to_compare);
newbox_xywh = x1y1towh(new_box);
newbox_area = newbox_xywh(3)*newbox_xywh(4);
for i = 1:n
    b1_xywh = x1y1towh(boxes_to_compare(i,:));
    intersection = rectint(newbox_xywh, b1_xywh);
    if intersection/newbox_area > threshold
        suppress = true;
        break
    end
end