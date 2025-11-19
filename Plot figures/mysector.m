function out = mysector(pos,h1,h2,ri,ro,cl,th1,th2,para,cyl,e,tmd,sign)
hold on;
Color=cl;
h=h2-h1;
center=[pos(1) pos(2) (h1+h2)/2];
temp=[];
[x1,y1,z1]=cylinder(ri,e);%创建以(0,0)为圆心，高度为[0,1]，半径为R的圆柱----生成的xyz是圆柱上下两个端面圆的离散数据，使用两行数据表示
[x2,y2,z2]=cylinder(ro,e);
if cyl==0
for ii=e+1:-1:1
    angle=atan2(y1(1,ii),x1(1,ii));
    if myangle(angle,th1)+myangle(angle,th2)>myangle(th1,th2)+0.0001
        temp=[temp; ii];
    end
end
for ii=1:length(temp)
    x1(:,temp(ii))=[];
    y1(:,temp(ii))=[];
    z1(:,temp(ii))=[];
    x2(:,temp(ii))=[];
    y2(:,temp(ii))=[];
    z2(:,temp(ii))=[];
end
if ~ismember(1,temp) && ~ismember(e+1,temp)
    x1=[x1(:,temp(end):end) x1(:,1:temp(end)-1)];
    y1=[y1(:,temp(end):end) y1(:,1:temp(end)-1)];
    z1=[z1(:,temp(end):end) z1(:,1:temp(end)-1)];
    x2=[x2(:,temp(end):end) x2(:,1:temp(end)-1)];
    y2=[y2(:,temp(end):end) y2(:,1:temp(end)-1)];
    z2=[z2(:,temp(end):end) z2(:,1:temp(end)-1)];
end
end
z1=(z1-0.5)*h;
z2=(z2-0.5)*h;
x1=x1+center(1);
x2=x2+center(1);
y1=y1+center(2);
y2=y2+center(2);
z1=z1+center(3);
z2=z2+center(3);
x=[];
y=[];
z=[];
temp2=z2;
z2(1,:)=temp2(2,:);
z2(2,:)=temp2(1,:);
th1=floor(th1*e/(2*pi))+1;
th2=floor(th2*e/(2*pi))+1;
if para ~=0
temp=[];
for ii=0:para/(size(z1,2)-1):para
    temp=[temp sign*para*mysigma(ii,0,para)];
end
z1(1,:)=z1(1,:)-temp;
    z1(2,:)=z1(2,:)-temp;
    z2(1,:)=z2(1,:)-temp;
    z2(2,:)=z2(2,:)-temp;
end
x=[x1;x2;x1(1,:)];
y=[y1;y2;y1(1,:)];
z=[z1;z2;z1(1,:)];
fs=surf(x,y,z);
fs.EdgeAlpha = 0;
fs.FaceAlpha = tmd;
fs.FaceColor = Color;
% set(fs,'handlevisibility','off');
plot3(x1(1,:),y1(1,:),z1(1,:),'k-','LineWidth',1);
plot3(x1(2,:),y1(2,:),z1(2,:),'k-','LineWidth',1);
plot3(x2(1,:),y2(1,:),z2(1,:),'k-','LineWidth',1);
plot3(x2(2,:),y2(2,:),z2(2,:),'k-','LineWidth',1);