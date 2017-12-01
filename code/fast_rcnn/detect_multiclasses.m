clear all


K = 100;  % maximum detections
nms_thres = 0.6;
tp_thres = 0.5;  % consider as a true positive when overlapped>tp_thres
dt_thres = 0.5;  % consider as a detection when above dt_thres

% constant
CLASSES = [string('background'), string('aero'), string('bike'), ...
    string('bird'), string('boat'), string('bottle'), ...
    string('bus'), string('car'), string('cat'), ...
    string('chair'), string('cow'), string('table'), ...
    string('dog'), string('horse'), string('mbike'), string('person'), ...
    string('plant'), string('sheep'), string('sofa'), ...
    string('train'), string('tv')];

% load model
net = load('../../data/models/fast-rcnn-caffenet-pascal07-dagnn.mat');
net = preprocessNet(net);

% read img, annotations from file
img = imread('../../data/images/000369.jpg');
proposals_all = load('../../data/SSW/SelectiveSearchVOC2007test.mat');
ground_truth_xml = PASreadrecord('../../data/annotations/000369.xml');  % struct
proposal = proposals_all.boxes(186);
proposal = proposal{1,1};
annotations = get_annotations(ground_truth_xml);  % ground truth annotations

[scores_all, deltas_all] = detect(net, img, proposal);

figure(1)
imshow(img)

for i_class = 1:21
    annotated = annotations(annotations(:,1)==i_class, :);
    if length(annotated) > 0  % not empty
        score = scores_all(:,i_class);
        delta = deltas_all(:,(i_class-1)*4+1:i_class*4);
        [pred_boxes, pred_scores]= get_top_k(proposal, score, delta, K,nms_thres);
        
        above_thres = pred_scores>dt_thres;
        pred_scores = pred_scores(above_thres);
        pred_boxes = pred_boxes(above_thres,:);
        tp_indices = get_true_positives(pred_boxes, annotated(:,2:5), tp_thres);
        
        for i = tp_indices
            box = x1y1towh(pred_boxes(i,:))
            rectangle('Position', box,'Curvature',[0,0],'LineWidth',2,'LineStyle','-','EdgeColor','r')
            class_name = CLASSES(i_class);
            text(box(1)+10,box(2)+10, char(class_name+ num2str(pred_scores(i)) ), 'Color','yellow');
        end
    end
end

