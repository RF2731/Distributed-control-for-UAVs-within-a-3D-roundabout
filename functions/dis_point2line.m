function U=dis_point2line(A,B,C)
U=norm(A-B)*sqrt(1-(mycos(A,B,C)^2));%点A到直线BC的距离
