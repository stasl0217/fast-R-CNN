function newbox = x1y1towh(box)
% box : [x0 y0 x1 y1]
% newbox: [x0 y0 w h]
x0 = box(1);
y0 = box(2);
x1 = box(3);
y1 = box(4);
w = x1 - x0;
h = y1 - y0;
newbox = [x0 y0 w h];