function u = mytunnel(i,UavTeam,p1,p2,p3,ptz,rh,rh_z,Vmx,Vmy,Vmz)
global Airport Node R_island vm_matrix height

 
Pcur  =  UavTeam.Uav(i).State.CurrentPos(1:3);
Vcur  =  UavTeam.Uav(i).State.Velocity(1:3);
L=UavTeam.Uav(i).Modularity.gain;
ksicur=Pcur+1/L*Vcur;
% Pdes  =  UavTeam.Uav(i).Waypoint(:,UavTeam.Uav(i).CurrentTaskNum);
rs = UavTeam.Uav(i).Modularity.rs;
ra = UavTeam.Uav(i).Modularity.ra;
vmax = UavTeam.Uav(i).Modularity.vmax;
p1=p1+(p3-p2)/2;
ptz=ptz+(p3-p2)/2;
p2=p2+(p3-p2)/2;
vzmax = UavTeam.Uav(i).Modularity.vzmax;
% rh=rh/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
At12 = (p1-p2)*(p1-p2)'/(norm(p1-p2)*norm(p1-p2));
At23 = (p2-p3)*(p2-p3)'/(norm(p2-p3)*norm(p2-p3));
%% Velocity to line
k1 = 1;
el = ksicur - p2;
Vl = -mysat(k1*At12*el,vmax);
%% Velocity away other multicopter

Vm=[Vmx;Vmy;Vmz];
Vm2D=[Vmx;Vmy;0];
Vm3D=[0;0;Vmz];
%% Velocity within the tunnel
Vt = [0;0;0];
k3 = 1; e = 0.000001;
% ksihi = At12*((Pcur-p2) + 1/UavTeam.gain*Vcur);
ksihi = dis_pt2plane(ksicur,p1,p2,ptz);
if norm(ksihi)~=0
temp1  = (rh-rs)/(norm(ksihi)+e);
temp2  = (rh-rs) - norm(ksihi)*mys(temp1,e);
ci = -k3*dmysigma(rh-norm(ksihi),rs,ra)/temp2 ...
    - k3*mysigma(rh-norm(ksihi),rs,ra)*(-mys(temp1,e)+norm(ksihi)*dmys(temp1,e)*(rh-rs)/(norm(ksihi)+e)/(norm(ksihi)+e))/(temp2^2);%
Vt = Vt - ci*(ksihi/norm(ksihi));
end
%% Velocity within the z-axis tunnel
Vtz = [0;0;0];
k4 = 1; e = 0.000001;
ksihiz = dis_pt2plane(Pcur+1/UavTeam.Uav(i).Modularity.gain*Vcur,p1,p2,p3);
if norm(ksihiz)~=0
temp1  = (rh_z-rs)/(norm(ksihiz)+e);
temp2  = (rh_z-rs) - norm(ksihiz)*mys(temp1,e);
% wrong ¸ººÅ
ci = -k4*dmysigma(rh_z-norm(ksihiz),rs,rs+ra)/temp2 ...
    - k4*mysigma(rh_z-norm(ksihiz),rs,rs+ra)*(-mys(temp1,e)+norm(ksihiz)*dmys(temp1,e)*(rh_z-rs)/(norm(ksihiz)+e)/(norm(ksihiz)+e))/(temp2^2);
Vtz = Vtz - ci*(ksihiz/norm(ksihiz));
end
%
Vw=[0;0;0];
% ksi_w  = Pcur(3) + 1/UavTeam.gain*Vcur(3) - height;
% Vw = - mysat(k1*ksi_w,vmax);
% Vw = [0;0;1]*Vw;

% Sum of all velocities
u = mysat(Vl+Vm2D+Vt,vmax)+mysat(Vm3D+Vtz+Vw,vzmax);
