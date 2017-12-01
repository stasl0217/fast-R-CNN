function annotations = get_annotations(xmlstruct)
% xmlstruct: read xml from file
% annotations : a box per row: (i_class, class_name, x0, y0, x1, y1)
gts = xmlstruct.objects;
annotations = zeros(length(gts), 5);
count = 0;
for s = gts  %iter
    class_name = s.class;
    i_class = get_class_index(class_name);
    b = s.bndbox;
    count = count+1;
    annotations(count, :) = [i_class, b.xmin, b.ymin, b.xmax, b.ymax];
end
