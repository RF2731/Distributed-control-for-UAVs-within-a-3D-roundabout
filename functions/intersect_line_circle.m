function out=intersect_line_circle(N1,N2,N3,r)
syms x y z
t=N2-N1;

if (t(1) == 0) &&(t(2) ~= 0)&&(t(3) ~= 0)
    temp=1;
end
if (t(1) ~= 0) &&(t(2) == 0)&&(t(3) ~= 0)
    temp=2;
end
if (t(1) ~= 0) &&(t(2) ~= 0)&&(t(3) == 0)
    temp=3;
end
if (t(1) ~= 0) &&(t(2) == 0)&&(t(3) == 0)
    temp=4;
end
if (t(1) == 0) &&(t(2) ~= 0)&&(t(3) == 0)
    temp=5;
end
if (t(1) == 0) &&(t(2) == 0)&&(t(3) ~= 0)
    temp=6;
end
if (t(1) ~= 0) &&(t(2) ~= 0)&&(t(3) ~= 0)
    temp=7;
end
switch temp
    case 1
        str1='x==N1(1)';
        str2='(y-N1(2))/t(2)==(z-N1(3))/t(3)';
    case 2
        str1='y==N1(2)';
        str2='(x-N1(1))/t(1)==(z-N1(3))/t(3)';
    case 3
        str1='z==N1(3)';
        str2='(y-N1(2))/t(2)==(x-N1(1))/t(1)';
    case 4
        str1='y==N1(2)';
        str2='z==N1(3)';
    case 5
        str1='x==N1(1)';
        str2='z==N1(3)';
    case 6
        str1='x==N1(1)';
        str2='y==N1(2)';
    case 7
        str1='(y-N1(2))/t(2)==(x-N1(1))/t(1)';
        str2='(y-N1(2))/t(2)==(z-N1(3))/t(3)';
end

    s=solve((x-N3(1))^2+(y-N3(2))^2+(z-N3(3))^2==r^2,eval(str1),eval(str2),x,y,z);

X=double(s.x);
Y=double(s.y);
Z=double(s.z);
out1=[X(1);Y(1);Z(1)];
out2=[X(2);Y(2);Z(2)];
if mycos(N1,out1,N2) <0
    out = out1;
else
    out = out2;
end