function fs=mydrawcolorball(o2,rs,k1,k2)
global ra height
para=5;
alpha = 0:pi/20:2*pi;
x = o2(1) +  rs*cos(alpha);
y = o2(2) +  rs*sin(alpha);
x1 = o2(1) +  rs/para*cos(alpha);
y1 = o2(2) +  rs/para*sin(alpha);
% hold on
if k1==0
    switch k2
        case 'r'
            h=fill(x,y,'r-');
        case 'b'
            h=fill(x,y,'b-');
        case 'y'
            h=fill(x,y,'y-');
        case 'g'
            h=fill(x,y,'g-');
        case 'c'
            h=fill(x,y,'c-');
        case 'k'
            h=fill(x,y,'k-');
        case 'm'
            h=fill(x,y,'m-');
        case 'w'
            h=fill(x,y,'w-');
    end
    set(h,'edgealpha',0.5,'facealpha',1);
else

      fs=  plot3(o2(1),o2(2),o2(3),'k-o','MarkerFaceColor','k','MarkerSize',2);

end
