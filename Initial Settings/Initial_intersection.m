function intersection = Initial_intersection(k,AirwayNetwork,AdjacentMatrix)
global PathPlanning Node r_node Node_num Node

intersection = zeros(size(Node,1),12);
    adjacent_point = find(AdjacentMatrix(Node(k).num,:)==1);
    N1=AirwayNetwork(adjacent_point(1),:)';
    N2=AirwayNetwork(Node(k).num,:)';
    N3=AirwayNetwork(adjacent_point(2),:)';
    [pt1,pt2,pt3]=tunnel(N1,N2);
    pt4=pt1+pt3-pt2;
    [pts1,pts2,pts3]=tunnel(N2,N3);
    pts4=pts1+pts3-pts2;
    new1=intersect_line_circle(pt1,pt2,N2,Node(k).radius);
    new2=intersect_line_circle(pt3,pt4,N2,Node(k).radius);

    new3=intersect_line_circle(pts1,pts2,N2,Node(k).radius);
    new4=intersect_line_circle(pts3,pts4,N2,Node(k).radius);
    
    [pt1,pt2,pt3,ptz]=tunnel(N2,N1);
    pt4=pt1+pt3-pt2;
    [pts1,pts2,pts3,ptsz]=tunnel(N3,N2);
    pts4=pts1+pts3-pts2;
    new5=intersect_line_circle(pts1,pts2,N2,Node(k).radius);
    new6=intersect_line_circle(pts3,pts4,N2,Node(k).radius);
    new7=intersect_line_circle(pt1,pt2,N2,Node(k).radius);
    new8=intersect_line_circle(pt3,pt4,N2,Node(k).radius);

%     intersection=[new1',new2',new3',new4',new5',new6',new7',new8'];
intersection=[new1',new3',new5',new7'];