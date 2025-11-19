function [NewUavTeam,u]= Rcontrollerunstructure(i,UavTeam,Vmx,Vmy,Vmz)
global Roundabout AirwayNetwork
global Airport_num Node_num Roundabout_num rh1 rh2 rh_z Gainfactor_rs Gainfactor_ra StaticObstacle laneiso lanewidth
% global sampletime
global N M

NewUavTeam=UavTeam;
Pcur  =  NewUavTeam.Uav(i).State.CurrentPos;
Pcur2D  =  NewUavTeam.Uav(i).State.CurrentPos(1:2);
Vcur  =  NewUavTeam.Uav(i).State.Velocity;
Vcur2D  =  NewUavTeam.Uav(i).State.Velocity(1:2);
ksi = Pcur + Vcur / NewUavTeam.Uav(i).Modularity.gain;
rhz=rh_z/2;
num=find(NewUavTeam.Uav(i).State.CurrentWaypoint==Roundabout_num);
NewUavTeam.Uav(i).State.ElementType=3;
rs = NewUavTeam.Uav(i).Modularity.rs;
% rsz = NewUavTeam.Uav(i).rsz;
ra = NewUavTeam.Uav(i).Modularity.ra;
NewUavTeam.Uav(i).State.ElementNum=num;
vmax = NewUavTeam.Uav(i).Modularity.vmax;
vzmax = NewUavTeam.Uav(i).Modularity.vzmax;
% ksicur_z = Pcur(3) + 1/NewUavTeam.gainz*Vcur(3);
% ksicur_z = Highway(1).StateChangeHeight2 +(ksicur_z-Highway(1).StateChangeHeight2 )* rs/rsz;
Or = Roundabout(num).pos;
if StaticObstacle == true
    Rr1 = Roundabout(num).radius_i;
else
    Rr1 = 0;
end
Rr2 = Roundabout(num).radius_o;
state=1;
k1=1;
last_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)-1);
next_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)+1);
% next_point2 = NewUavTeam.Uav(i).PathPlanning(find(NewUavTeam.Uav(i).PathPlanning==NewUavTeam.Uav(i).NowNode)+2);
N1=[AirwayNetwork(NewUavTeam.Uav(i).State.CurrentWaypoint,:)]';
N2=[AirwayNetwork(next_point,:)]';
% N3=[AirwayNetwork(next_point2,:)]';
[pt1,pt2,pt3,ptz]=tunnel(N1,N2,rh1,rh2,rh_z);
Pdes=(N2-N1)/norm(N2-N1)*Roundabout(num).changedis +pt1+((NewUavTeam.Uav(i).State.lane-1)*(laneiso+lanewidth)+lanewidth/2)*(pt3-pt2)/norm(pt3-pt2);
ksi_w  = Pcur + 1/NewUavTeam.Uav(i).Modularity.gain*Vcur - Pdes;

Vw = - k1*ksi_w;
Vw2D=[Vw(1:2);0];
Vw3D=[0;0;Vw(3)];
Rrs = (Rr1 + Rr2)/2;
Rrw = (Rr2 - Rr1)/2;

Vm =  [Vmx;Vmy;Vmz];
Vm2D=[Vmx;Vmy;0];
Vm3D=[0;0;Vmz];
Vtz = [0;0;0];
k4 = 1; e = 0.001;
ksihiz = dis_pt2plane(Pcur+1/NewUavTeam.Uav(i).Modularity.gain*Vcur,pt1,pt2,pt3);
if norm(ksihiz)>=0.000001
    temp1  = (rhz-rs)/(norm(ksihiz)+e);
    temp2  = (rhz-rs) - norm(ksihiz)*mys(temp1,e);
    % wrong 负号
    ci = -k4*dmysigma(rhz-norm(ksihiz),rs,ra)/temp2 ...
        - k4*mysigma(rhz-norm(ksihiz),rs,ra)*(-mys(temp1,e)+norm(ksihiz)*dmys(temp1,e)*(rhz-rs)/(norm(ksihiz)+e)/(norm(ksihiz)+e))/(temp2^2);
    Vtz = Vtz - ci*(ksihiz/norm(ksihiz));
    %
end
u = mysat(Vw2D+Vm2D,vmax)+mysat(Vw3D+Vm3D+Vtz,vzmax);
% if norm (Pcur(1:2)-Pdes(1:2))<Rrw && dis_point2line(Pcur,pt2,pt3)<rh1/2   
%     if dis_point2line(Pcur,pt2,pt3)<rh1
%     NewUavTeam.Uav(i).NextNode = next_point; %
%     NewUavTeam.Uav(i).verticalcommand=1;
% end

