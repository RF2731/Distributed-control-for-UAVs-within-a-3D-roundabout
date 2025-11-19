function fs=plotsphere(x,y,z,r,z_div_x,FaceAlpha,FaceColor)
hold on
[u,v,w]=sphere(50);
u=r*u+x;
v=r*v+y;
w=r*w*z_div_x+z;
fs=surf(u,v,w);
fs.EdgeAlpha = 0;
fs.FaceAlpha = FaceAlpha;
fs.FaceColor = FaceColor;