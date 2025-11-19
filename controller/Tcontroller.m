function [NewUavTeam,u] = Tcontroller(i,UavTeam,N1,N2,Vmx,Vmy,Vmz)
global AirwayNetwork AdjacentMatrix
global rh1 rh2 rh_z Airport_num Node_num Roundabout_num rh_z lanewidth laneiso
global Airport Node Roundabout AirwayList
NewUavTeam=UavTeam;
Pcur  =  NewUavTeam.Uav(i).State.CurrentPos(1:3);
Vcur  =  NewUavTeam.Uav(i).State.Velocity(1:3);
L=NewUavTeam.Uav(i).Modularity.gain;
ksi  =  Pcur + 1/L*Vcur;
% rm  =  NewUavTeam.Uav(i).r;
ra  =  NewUavTeam.Uav(i).Modularity.ra;
vmax  =  NewUavTeam.Uav(i).Modularity.vmax;

NewUavTeam.Uav(i).State.ElementType=1;
      [pt1,pt2,pt3,ptz]=tunnel(N1,N2,lanewidth,(lanewidth+laneiso)*2*(NewUavTeam.Uav(i).State.lane-1)+rh2,rh_z);  

if  (ismember(NewUavTeam.Uav(i).Routing.NextWaypoint,Airport_num))==true
    num=find(NewUavTeam.Uav(i).Routing.NextWaypoint==Airport_num);
    pt1=pt1+(pt2-pt1)*Airport(num).radius/norm(pt2-pt1);
end
NewUavTeam.Uav(i).State.verticalcommand=1;

pt4=pt1+pt3-pt2;
for ii = 1:size(AirwayList,1)
    if AirwayList(ii,1)== NewUavTeam.Uav(i).State.CurrentWaypoint && AirwayList(ii,2)==NewUavTeam.Uav(i).Routing.NextWaypoint
        NewUavTeam.Uav(i).State.ElementNum=ii;
    end
end
rb = 10;
rsr= 10000;
rrt= 1000;

u = mytunnel(i,NewUavTeam,pt1,pt2,pt3,ptz,lanewidth/2,rh_z/2,Vmx,Vmy,Vmz);

% if (ismember(NewUavTeam.Uav(i).NextNode,Node_num))==true
%     num=find(NewUavTeam.Uav(i).NextNode==Node_num)*2;
%     angle=atan2(Pcur(2)+Vcur(2)/L-Node(num).Or(2),Pcur(1)+Vcur(1)/L-Node(num).Or(1));
%     if myangle(angle,Node(num).theta1)+myangle(angle,Node(num).theta2)<=myangle(Node(num).theta1,Node(num).theta2)
%         NewUavTeam.Uav(i).NowNode = NewUavTeam.Uav(i).NextNode;
%     end
% end
% if (ismember(NewUavTeam.Uav(i).NextNode,Roundabout_num))==true
%     num=find(NewUavTeam.Uav(i).NextNode==Roundabout_num);
%     Highway_in=find(NewUavTeam.Uav(i).NowNode==Roundabout(num).connection);
% 
%     if ((AirwayNetwork(NewUavTeam.Uav(i).NextNode,:)-(Pcur+Vcur/L)')*(Roundabout(num).pos-Roundabout(num).Highway(Highway_in).p)<Roundabout(num).changedis*Roundabout(num).changedis) && norm(Pcur)~=0
%         NewUavTeam.Uav(i).NowNode = NewUavTeam.Uav(i).NextNode;
%         NewUavTeam.Uav(i).RoundaboutState =1;
%     end
% end
% if  (ismember(NewUavTeam.Uav(i).NextNode,Airport_num))==true
%     num=find(NewUavTeam.Uav(i).NextNode==Airport_num);
%     if norm(dis_pt2plane(Pcur+Vcur/L,pt2,pt3,ptz))<5
%         NewUavTeam.Uav(i).NowNode = NewUavTeam.Uav(i).NextNode;
%         NewUavTeam.Uav(i).LandingState  = 1;
%     end
% end