function out = mycylinder(pos,h1,h2,r,cl)

n=100;%设置多少个边逼近圆

[x1,y1,z1]=cylinder(r,n);%生成标准的100个面的圆柱数据，半径为r，高为1，底面圆心0，0；
z2=[z1(1,:)+h1;z1(2,:)+h2-1];%圆柱高增高，变为高h
mesh(x1+pos(1),y1+pos(2),z2)
map=jet(16);
% cl=14;%可设置16种颜色(1-16)
% cl=5;%可设置16种颜色(1-16)
map1=map(cl,:);
colormap(map1)
alpha(0.2)%调节透明度(0-1)axis equal
hold on