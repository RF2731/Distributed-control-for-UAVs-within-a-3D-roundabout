function [V1,V2,V3,V4]=tunnel(N1,N2,rh1,rh2,rh_z)
x1=((rh2)/(2*norm(N2-N1)));
x2=(rh2+2*rh1)/(rh2);
np=x1.*-[0 -1;1 0]*(N2(1:2)-N1(1:2));
np=[np;0];
np_z=cross(N2-N1,np);
V1=N1+np;
V2=N2+np;
V3=N2+np*x2;
V4=V2+np_z/norm(np_z)*rh_z/2;
%