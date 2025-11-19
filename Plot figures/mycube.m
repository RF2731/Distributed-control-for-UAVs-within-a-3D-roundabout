function out =  mycube(A,B,C,D,temp,tmd,height)
hold on;
E=B+C-A;
F=D+B-A;
G=D+C-A;
H=E+D-A;
e=300;
l1=[A;C];
l2=[B;E];
l3=[D;G];
l4=[F;H];
l5=[A;B;F;D;A];
l6=[C;E;H;G;C];

plot3(l1(:,1),l1(:,2),l1(:,3),'k-','LineWidth',1);
plot3(l2(:,1),l2(:,2),l2(:,3),'k-','LineWidth',1);
plot3(l3(:,1),l3(:,2),l3(:,3),'k-','LineWidth',1);
plot3(l4(:,1),l4(:,2),l4(:,3),'k-','LineWidth',1);
plot3(l5(:,1),l5(:,2),l5(:,3),'k-','LineWidth',1);
plot3(l6(:,1),l6(:,2),l6(:,3),'k-','LineWidth',1);
X=[myvector(A(1),C(1),e,height); myvector(D(1),G(1),e,height);myvector(F(1),H(1),e,height);myvector(B(1),E(1),e,height);myvector(A(1),C(1),e,height)];
Y=[myvector(A(2),C(2),e,height); myvector(D(2),G(2),e,height);myvector(F(2),H(2),e,height);myvector(B(2),E(2),e,height);myvector(A(2),C(2),e,height)];
Z=[myvector(A(3),C(3),e,height); myvector(D(3),G(3),e,height);myvector(F(3),H(3),e,height);myvector(B(3),E(3),e,height);myvector(A(3),C(3),e,height)];
% Y=[A(2):1:B(2); E(2):1:C(2);F(2):1:H(2);G(2):1:D(2);A(2):1:B(2)];
% Z=[A(3):1:B(3); E(3):1:C(3);F(3):1:H(3);G(3):1:D(3);A(3):1:B(3)];
if temp==1
    Color=[0 1 0 ];
else if temp ==0
        Color =[1 1 1];
else
    Color=[0 0 1];
end
end
fs=surf(X,Y,Z);
fs.EdgeAlpha = 0;
fs.FaceAlpha = tmd;
fs.FaceColor = Color;
% % 8个顶点
% temp = [A;B;C;D;
%      B+C+D-2*A;B+D-A;C+D-A;B+C-A];
% % dot内点分布决定连线顺序
% % 连线分了两次，不是必须）
% Dot1 = [temp(1,1:3);temp(2,1:3);temp(8,1:3);temp(3,1:3);
%         temp(1,1:3);temp(4,1:3);temp(7,1:3);temp(3,1:3)];
% Dot2 = [temp(5,1:3);temp(6,1:3);temp(4,1:3);temp(7,1:3);
%         temp(5,1:3);temp(8,1:3);temp(2,1:3);temp(6,1:3)];
% % 一张图上画两次图
% hold on;
% plot3(Dot1(1:8,1),Dot1(1:8,2),Dot1(1:8,3),'-r');
% plot3(Dot2(1:8,1),Dot2(1:8,2),Dot2(1:8,3),'-r');
