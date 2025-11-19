function [NewUavTeam,u]= VTcontroller_takeoff(i,UavTeam,Vmx,Vmy,Vmz)
global rh1 rh2 rh_z
global AirwayNetwork Airport Airport_num lanewidth laneiso
NewUavTeam=UavTeam;
% global sampletime
NewUavTeam.Uav(i).type=0;
height= AirwayNetwork(NewUavTeam.Uav(i).NowNode,3)*1.1;

Pcur  =  NewUavTeam.Uav(i).CurrentPos;
Vcur  =  NewUavTeam.Uav(i).Velocity;

ksi = Pcur + Vcur / NewUavTeam.gain;

rs = NewUavTeam.Uav(i).rs;
ra = NewUavTeam.Uav(i).ra;
vmax = NewUavTeam.Uav(i).vmax;

num=find(NewUavTeam.Uav(i).NowNode==Airport_num);
    next_point = NewUavTeam.Uav(i).PathPlanning(find(NewUavTeam.Uav(i).PathPlanning==NewUavTeam.Uav(i).NowNode)+1);

    [pt1,pt2,pt3,ptz]=tunnel([AirwayNetwork(NewUavTeam.Uav(i).NowNode,:)]',[AirwayNetwork(next_point ,:)]',lanewidth,(lanewidth+laneiso)*2*(NewUavTeam.Uav(i).lane-1)+rh2,rh_z);

    pt4=pt1+pt3-pt2;
    u = mytunnel(i,NewUavTeam,pt1,pt2,pt3,ptz,lanewidth/2,rh_z/2,Vmx,Vmy,Vmz);
