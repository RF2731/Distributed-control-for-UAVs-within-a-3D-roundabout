function [NewUavTeam,u] = Hcontroller(i,UavTeam,Vmx,Vmy,Vmz)
global AirwayNetwork
global rh1 rh2 rh_z Airport_num Node_num Roundabout_num
global Airport Node Roundabout min_turn_radius lanewidth laneiso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NewUavTeam=UavTeam;
Pcur  =  NewUavTeam.Uav(i).State.CurrentPos(1:3);
Vcur  =  NewUavTeam.Uav(i).State.Velocity(1:3);
ksi  = Pcur + 1/NewUavTeam.Uav(i).Modularity.gain*Vcur;
ra = NewUavTeam.Uav(i).Modularity.ra;
vmax = NewUavTeam.Uav(i).Modularity.vmax;
NewUavTeam.Uav(i).State.ElementType=2;
NewUavTeam.Uav(i).State.verticalcommand=1;
%%
L=NewUavTeam.Uav(i).Modularity.gain;
last_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)-1);
next_point = NewUavTeam.Uav(i).Routing.PathPlanning(find(NewUavTeam.Uav(i).Routing.PathPlanning==NewUavTeam.Uav(i).State.CurrentWaypoint)+1);

[pt1,pt2,pt3,ptz]=tunnel(AirwayNetwork(last_point,:)',AirwayNetwork(NewUavTeam.Uav(i).State.CurrentWaypoint,:)',lanewidth,(lanewidth+laneiso)*2*(NewUavTeam.Uav(i).State.lane-1)+rh2,rh_z);


num = find(NewUavTeam.Uav(i).State.CurrentWaypoint==Node_num);

if last_point<next_point
    jj=1;
else
    jj=2;
end%%%只适用于特殊情况！需要后续修改
NewUavTeam.Uav(i).State.ElementNum=2*(num-1)+jj;

switch Node(2*(num-1)+jj).state
    case 1
        u=Arccontroller(i,NewUavTeam,Node(2*(num-1)+jj).Or,Node(2*(num-1)+jj).ro-lanewidth-(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),Node(2*(num-1)+jj).ro,Node(2*(num-1)+jj).state,Vmx,Vmy,Vmz);
    case -1
        u=Arccontroller(i,NewUavTeam,Node(2*(num-1)+jj).Or,Node(2*(num-1)+jj).ri,Node(2*(num-1)+jj).ri+lanewidth+(NewUavTeam.Uav(i).State.lane-1)*(lanewidth+laneiso),Node(2*(num-1)+jj).state,Vmx,Vmy,Vmz);
end
%%%%%%%
N1=[AirwayNetwork(NewUavTeam.Uav(i).State.CurrentWaypoint,:)]';
N2=[AirwayNetwork(next_point,:)]';
[pt1,pt2,pt3,ptz]=tunnel(N1,N2,lanewidth,(lanewidth+laneiso)*2*(NewUavTeam.Uav(i).State.lane-1)+rh2,rh_z);
pt4=pt1+pt3-pt2;
angle=atan2(Pcur(2)+Vcur(2)/L-Node(2*(num-1)+jj).Or(2),Pcur(1)+Vcur(1)/L-Node(2*(num-1)+jj).Or(1));

% if myangle(angle,Node(2*(num-1)+jj).theta1)+myangle(angle,Node(2*(num-1)+jj).theta2)>myangle(Node(2*(num-1)+jj).theta1,Node(2*(num-1)+jj).theta2)+0.0001
%     NewUavTeam.Uav(i).NextNode = next_point; %
% end
