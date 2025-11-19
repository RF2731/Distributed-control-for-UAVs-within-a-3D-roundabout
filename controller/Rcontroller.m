function [NewUavTeam,u]= Rcontroller(i,UavTeam,Vmx,Vmy,Vmz)
global Roundabout Highway v_ro
global rs rsz vmax vzmax Airport_num Node_num Roundabout_num rh1 rh2 lanewidth mode laneiso
% global sampletime
global N M
NewUavTeam=UavTeam;
Pcur  =  NewUavTeam.Uav(i).State.CurrentPos;
Vcur  =  NewUavTeam.Uav(i).State.Velocity;
ksi = Pcur + Vcur / NewUavTeam.Uav(i).Modularity.gain;
num=find(NewUavTeam.Uav(i).State.CurrentWaypoint==Roundabout_num);
NewUavTeam.Uav(i).State.ElementType=3;
rs = NewUavTeam.Uav(i).Modularity.rs;
% rsz = NewUavTeam.Uav(i).rsz;
ra = NewUavTeam.Uav(i).Modularity.ra;
NewUavTeam.Uav(i).State.ElementNum=num;
L=NewUavTeam.Uav(i).Modularity.gain;
vmax = NewUavTeam.Uav(i).Modularity.vmax;
% ksicur_z = Pcur(3) + 1/NewUavTeam.gainz*Vcur(3);
% ksicur_z = Highway(1).StateChangeHeight2 +(ksicur_z-Highway(1).StateChangeHeight2 )* rs/rsz;
Or = Roundabout(num).pos;
Rr1 = Roundabout(num).radius_i;
Rr2 = Roundabout(num).radius_o;
state=1;

last_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)-1);
next_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)+1);
Highway_in=find(last_point==Roundabout(num).connection);
Highway_out=find(next_point==Roundabout(num).connection);

angle1=atan2(Pcur(2)+Vcur(2)/L-Roundabout(num).Highway(Highway_in).om(2),Pcur(1)+Vcur(1)/L-Roundabout(num).Highway(Highway_in).om(1));
angle2=atan2(Pcur(2)+Vcur(2)/L-Roundabout(num).Highway(Highway_out).od(2),Pcur(1)+Vcur(1)/L-Roundabout(num).Highway(Highway_out).od(1));
theta1=atan2(Or(2)-Roundabout(num).Highway(Highway_in).om(2),Or(1)-Roundabout(num).Highway(Highway_in).om(1));
theta2=atan2(Roundabout(num).Highway(Highway_in).p(2)-Roundabout(num).Highway(Highway_in).om(2),Roundabout(num).Highway(Highway_in).p(1)-Roundabout(num).Highway(Highway_in).om(1));
theta3=atan2(Or(2)-Roundabout(num).Highway(Highway_out).od(2),Or(1)-Roundabout(num).Highway(Highway_out).od(1));
theta4=atan2(Roundabout(num).Highway(Highway_out).p(2)-Roundabout(num).Highway(Highway_out).od(2),Roundabout(num).Highway(Highway_out).p(1)-Roundabout(num).Highway(Highway_out).od(1));
if NewUavTeam.Uav(i).State.RoundaboutState ==1  && myangle(angle1,theta1)+myangle(angle1,theta2)>myangle(theta1,theta2)+0.0001 ...
        && norm(Pcur+Vcur/L-Roundabout(num).pos)<Roundabout(num).radius_o
    NewUavTeam.Uav(i).State.RoundaboutState =2;
end%%%%%%%%merging area
if NewUavTeam.Uav(i).State.RoundaboutState ==2  && myangle(angle2,theta3)<=Roundabout(num).buffer+0.0001...
        && norm(Pcur+Vcur/L-Roundabout(num).Highway(Highway_out).od)>Roundabout(num).ra && norm(Pcur+Vcur/L-Roundabout(num).Highway(Highway_out).od)<Roundabout(num).ra+rh1
    NewUavTeam.Uav(i).State.RoundaboutState =3;
end
if NewUavTeam.Uav(i).State.RoundaboutState ==3  && myangle(angle2,theta3)+myangle(angle2,theta4)<=myangle(theta3,theta4)+0.0001...
        && norm(Pcur+Vcur/L-Roundabout(num).Highway(Highway_out).od)>Roundabout(num).ra && norm(Pcur+Vcur/L-Roundabout(num).Highway(Highway_out).od)<Roundabout(num).ra+rh1
    NewUavTeam.Uav(i).State.RoundaboutState =4;
end

switch NewUavTeam.Uav(i).State.RoundaboutState
    case 1
        u=Arccontroller(i,NewUavTeam,Roundabout(num).Highway(Highway_in).om,norm(Roundabout(num).Highway(Highway_in).om-Roundabout(num).Highway(Highway_in).p)-lanewidth-(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso)-rh2/2,norm(Roundabout(num).Highway(Highway_in).om-Roundabout(num).Highway(Highway_in).p)-rh2/2,1,Vmx,Vmy,Vmz);
    case 2
        if mode ==1
            NewUavTeam.Uav(i).State.verticalcommand=2;
        end
        u=Arccontroller(i,NewUavTeam,Or,Rr1+(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),Rr1+lanewidth+(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),-1,Vmx,Vmy,Vmz);
    case 3
        if mode ==1
            NewUavTeam.Uav(i).State.verticalcommand=1;
        end
        u=Arccontroller(i,NewUavTeam,Or,Rr1+(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),Rr1+lanewidth+(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),-1,Vmx,Vmy,Vmz);
    case 4
        u=Arccontroller(i,NewUavTeam,Roundabout(num).Highway(Highway_out).od,norm(Roundabout(num).Highway(Highway_out).od-Roundabout(num).Highway(Highway_out).p)-lanewidth-(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso)-rh2/2,norm(Roundabout(num).Highway(Highway_out).od-Roundabout(num).Highway(Highway_out).p)-rh2/2,1,Vmx,Vmy,Vmz);
end

