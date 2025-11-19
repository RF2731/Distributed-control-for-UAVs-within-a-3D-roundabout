function Dis_vector=dis_pt2plane(pt,p1,p2,p3)
n=cross((p2-p1),(p3-p1));
Dis_vector=(n*n'/(n'*n))*(pt-p1);
