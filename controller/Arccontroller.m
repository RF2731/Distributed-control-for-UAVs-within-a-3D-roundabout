function u= Arccontroller(i,UavTeam,Or,Rr1,Rr2,state,Vmx,Vmy,Vmz)
global rs rsz Roundabout_num height Roundabout rh_z
Pcur  =  UavTeam.Uav(i).State.CurrentPos;
Pcur2D  =  UavTeam.Uav(i).State.CurrentPos(1:2);
Vcur  =  UavTeam.Uav(i).State.Velocity;
Vcur2D  =  UavTeam.Uav(i).State.Velocity(1:2);
vzmax = UavTeam.Uav(i).Modularity.vzmax;

rs = UavTeam.Uav(i).Modularity.rs;

ra = UavTeam.Uav(i).Modularity.ra;

vmax = UavTeam.Uav(i).Modularity.vmax;

Rrs = (Rr1 + Rr2)/2;
Rrw = (Rr2 - Rr1)/2;

k1 = 1;
R90 = state*[0 1;-1 0]; 

eu = Pcur2D + 1/UavTeam.Uav(i).Modularity.gain*Vcur2D - Or(1:2);
Vu = vmax *R90*eu/norm(eu);
Vu = [1 0; 0 1;0 0] * Vu;
Vm =  [Vmx;Vmy;Vmz];
Vm2D=[Vmx;Vmy;0];
Vm3D=[0;0;Vmz];

Vw = [0;0;0];

num=find(UavTeam.Uav(i).State.CurrentWaypoint==Roundabout_num);
if UavTeam.Uav(i).State.verticalcommand == 2
    ksi_w  = Pcur(3) + 1/UavTeam.Uav(i).Modularity.gain*Vcur(3) - (height+Roundabout(num).StateChangeHeight);
else
    ksi_w  = Pcur(3) + 1/UavTeam.Uav(i).Modularity.gain*Vcur(3) - (height);
end
Vw = - mysat(k1*ksi_w,vmax);
Vw = [0;0;1]*Vw;

Vr = [0;0];
ksii = Pcur2D + Vcur2D / UavTeam.Uav(i).Modularity.gain;
k3 = 1; e = 0.00001;
ksipi = Or(1:2) + Rrs * (ksii - Or(1:2))/(norm(ksii - Or(1:2)) + e); 
ksiri = ksii - ksipi;
temp1  = (Rrw-rs)/(norm(ksiri)+e);
temp2  = (Rrw-rs) - norm(ksiri)*mys(temp1,e);
ci =- k3*dmysigma(Rrw-norm(ksiri),rs,ra)/temp2 ...
    - k3*mysigma(Rrw-norm(ksiri),rs,ra)*(-mys(temp1,e)+norm(ksiri)*dmys(temp1,e)*(Rrw-rs)/(norm(ksiri)+e)/(norm(ksiri)+e))/(temp2^2);
if ksiri == 0
else
    Vr = Vr - ci*(ksiri/norm(ksiri));
end
Vr = [1 0; 0 1;0 0] * Vr;

Vtz = [0;0;0];
k4 = 1; e = 0.00001;
if UavTeam.Uav(i).State.verticalcommand == 1
    ksihiz = Pcur(3)+1/UavTeam.Uav(i).Modularity.gain*Vcur(3)-height;
else
    ksihiz = Pcur(3)+1/UavTeam.Uav(i).Modularity.gain*Vcur(3)-(height+Roundabout(num).StateChangeHeight);
end
if norm(ksihiz)~=0
    temp1  = (rh_z/2-rs)/(norm(ksihiz)+e);
    temp2  = (rh_z/2-rs) - norm(ksihiz)*mys(temp1,e);
    ci = -k4*dmysigma(rh_z/2-norm(ksihiz),rs,rs+ra)/temp2 ...
        - k4*mysigma(rh_z/2-norm(ksihiz),rs,rs+ra)*(-mys(temp1,e)+norm(ksihiz)*dmys(temp1,e)*(rh_z/2-rs)/(norm(ksihiz)+e)/(norm(ksihiz)+e))/(temp2^2);
    Vtz = Vtz - ci*(ksihiz/norm(ksihiz))*[0;0;1];
end
u = mysat(Vu+Vm2D+Vr,vmax)+mysat(Vm3D+Vtz+Vw,vzmax);

