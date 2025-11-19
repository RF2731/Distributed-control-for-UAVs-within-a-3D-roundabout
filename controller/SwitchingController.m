function [NewUavTeam,Airway,Node,Roundabout,TrafficCharacteristicsMatrix]=SwitchingController(UavTeam,AirwayNetwork,AirwayList,mode,...
    Airway,Node,Roundabout,Airport,Airport_num,Node_num,Roundabout_num,time)
global lanenum lanewidth laneiso rh1 rh2 rh_z
NewUavTeam=UavTeam;
for ii=1:length(NewUavTeam.Uav)
    next_point = NewUavTeam.Uav(ii).Routing.PathPlanning(find(NewUavTeam.Uav(ii).Routing.PathPlanning==NewUavTeam.Uav(ii).State.CurrentWaypoint)+1);
    Pcur=NewUavTeam.Uav(ii).State.CurrentPos;
    Vcur=NewUavTeam.Uav(ii).State.Velocity;
    L=NewUavTeam.Uav(ii).Modularity.gain;
    switch NewUavTeam.Uav(ii).State.ElementType
        case 0    %takeoff
            num=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==Airport_num);
            if norm(Pcur-Airport(num).pos)>Airport(num).radius
                NewUavTeam.Uav(ii).Routing.NextWaypoint = next_point;
            end
        case 1    %

            [pt1,pt2,pt3,ptz]=tunnel(AirwayNetwork(NewUavTeam.Uav(ii).State.CurrentWaypoint,:)',AirwayNetwork(NewUavTeam.Uav(ii).Routing.NextWaypoint,:)',lanewidth,(lanewidth+laneiso)*2*(NewUavTeam.Uav(ii).State.lane-1)+rh2,rh_z);
            V2D=norm(NewUavTeam.Uav(ii).State.Velocity(1:2));

            if (ismember(NewUavTeam.Uav(ii).Routing.NextWaypoint,Node_num))==true
                num=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==Node_num)*2;
                angle=atan2(Pcur(2)+Vcur(2)/L-Node(num).Or(2),Pcur(1)+Vcur(1)/L-Node(num).Or(1));
                if myangle(angle,Node(num).theta1)+myangle(angle,Node(num).theta2)<=myangle(Node(num).theta1,Node(num).theta2)
                    ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                    ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));
                    index=intersect(ans1,ans2);
                    Airway(index).accumulation=Airway(index).accumulation-1;
                    Airway(index).PeriodNexit = Airway(index).PeriodNexit+1;
                    Node(num).accumulation=Node(num).accumulation+1;
                    Node(num).PeriodNum=Node(num).PeriodNum+1;
                    if Airway(index).accumulation==1
                        Airway(index).AverageSpeed=0;
                    else
                        Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation+1)-V2D)/(Airway(index).accumulation);
                    end
                    Node(num).AverageSpeed=(Node(num).AverageSpeed*(Node(num).accumulation-1)+V2D)/(Node(num).accumulation);
                    NewUavTeam.Uav(ii).Routing.LastWaypoint=NewUavTeam.Uav(ii).State.CurrentWaypoint;
                    NewUavTeam.Uav(ii).Routing.RecordWaypoint=[NewUavTeam.Uav(ii).Routing.RecordWaypoint;NewUavTeam.Uav(ii).State.CurrentWaypoint];
                    NewUavTeam.Uav(ii).State.CurrentWaypoint = NewUavTeam.Uav(ii).Routing.NextWaypoint;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=Airway(index).distance/UavTeam.Uav(ii).Modularity.vmax;
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];

                end
            end
            if (ismember(NewUavTeam.Uav(ii).Routing.NextWaypoint,Roundabout_num))==true
                num=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==Roundabout_num);
                Highway_in=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==Roundabout(num).connection);
                if ((AirwayNetwork(NewUavTeam.Uav(ii).Routing.NextWaypoint,:)-(Pcur+Vcur/L)')*(Roundabout(num).pos-Roundabout(num).Highway(Highway_in).p)<Roundabout(num).changedis*Roundabout(num).changedis) && norm(Pcur)~=0
                    NewUavTeam.Uav(ii).State.RoundaboutState =1;
                    ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                    ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));

                    index=intersect(ans1,ans2);
                    Airway(index).accumulation=Airway(index).accumulation-1;
                    Airway(index).PeriodNexit = Airway(index).PeriodNexit+1;

                    Roundabout(num).accumulation=Roundabout(num).accumulation+1;
                    Roundabout(num).PeriodNum=Roundabout(num).PeriodNum+1;
                    if Airway(index).accumulation==1
                        Airway(index).AverageSpeed=0;
                    else
                        Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation+1)-V2D)/(Airway(index).accumulation);
                    end
                    Roundabout(num).AverageSpeed=(Roundabout(num).AverageSpeed*(Roundabout(num).accumulation-1)+V2D)/(Roundabout(num).accumulation);
                    NewUavTeam.Uav(ii).Routing.LastWaypoint=NewUavTeam.Uav(ii).State.CurrentWaypoint;
                    NewUavTeam.Uav(ii).Routing.RecordWaypoint = [NewUavTeam.Uav(ii).Routing.RecordWaypoint;NewUavTeam.Uav(ii).State.CurrentWaypoint];
                    NewUavTeam.Uav(ii).State.CurrentWaypoint = NewUavTeam.Uav(ii).Routing.NextWaypoint;
                    %                     NewUavTeam.Uav(ii).Routing.NextWaypoint = next_point;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=Airway(index).distance/UavTeam.Uav(ii).Modularity.vmax;
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];

                end
            end
            if  (ismember(NewUavTeam.Uav(ii).Routing.NextWaypoint,Airport_num))==true
                num=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==Airport_num);
                if norm(dis_pt2plane(Pcur+Vcur/L,pt2,pt3,ptz))<5
                    ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                    ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));
                    index=intersect(ans1,ans2);
                    Airway(index).accumulation=Airway(index).accumulation-1;
                    Airway(index).PeriodNexit = Airway(index).PeriodNexit+1;
                    if Airway(index).accumulation==0
                        Airway(index).AverageSpeed=0;
                    else
                        Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation+1)-V2D)/(Airway(index).accumulation);
                    end
                    NewUavTeam.Uav(ii).Routing.LastWaypoint=NewUavTeam.Uav(ii).State.CurrentWaypoint;
                    NewUavTeam.Uav(ii).Routing.RecordWaypoint=[NewUavTeam.Uav(ii).Routing.RecordWaypoint;NewUavTeam.Uav(ii).State.CurrentWaypoint];
                    NewUavTeam.Uav(ii).State.CurrentWaypoint = NewUavTeam.Uav(ii).Routing.NextWaypoint;
                    NewUavTeam.Uav(ii).State.LandingState = 1;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=Airway(index).Dx/UavTeam.Uav(ii).Modularity.vmax+NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned;
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];
                    NewUavTeam.Uav(ii).Scheduling.FinalArriveTime=time;
                    NewUavTeam.Uav(ii).Scheduling.FinalArriveTimePlanned=NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned;
                end
            end
        case 2
            last_point = NewUavTeam.Uav(ii).Routing.PathPlanning(find(NewUavTeam.Uav(ii).Routing.PathPlanning==NewUavTeam.Uav(ii).State.CurrentWaypoint)-1);
            num = find(NewUavTeam.Uav(ii).State.CurrentWaypoint==Node_num);
            if last_point<next_point
                jj=1;
            else
                jj=2;
            end
            V2D=norm(NewUavTeam.Uav(ii).State.Velocity(1:2));
            angle=atan2(Pcur(2)+Vcur(2)/L-Node(2*(num-1)+jj).Or(2),Pcur(1)+Vcur(1)/L-Node(2*(num-1)+jj).Or(1));
            if myangle(angle,Node(2*(num-1)+jj).theta1)+myangle(angle,Node(2*(num-1)+jj).theta2)>myangle(Node(2*(num-1)+jj).theta1,Node(2*(num-1)+jj).theta2)+0.0001
                NewUavTeam.Uav(ii).Routing.NextWaypoint = next_point;
                ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));
                index=intersect(ans1,ans2);
                Node(num).accumulation=Node(num).accumulation-1;
                Node(num).PeriodNexit = Node(num).PeriodNexit+1;
                Airway(index).accumulation=Airway(index).accumulation+1;
                Airway(index).PeriodNum=Airway(index).PeriodNum+1;
                if Node(num).accumulation==0
                    Node(num).AverageSpeed=0;
                else
                    Node(num).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation+1)-V2D)/(Airway(index).accumulation);
                end
                Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation-1)+V2D)/(Airway(index).accumulation);
                NewUavTeam.Uav(ii).Routing.LastWaypoint=NewUavTeam.Uav(ii).State.CurrentWaypoint;
                NewUavTeam.Uav(ii).Routing.RecordWaypoint=[NewUavTeam.Uav(ii).Routing.RecordWaypoint;NewUavTeam.Uav(ii).State.CurrentWaypoint];
                NewUavTeam.Uav(ii).State.NextWaypoint = next_point;
                NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=(myangle(Node(num).theta1,Node(num).theta2)*(Node(num).ri+Node(num).ro)/2)/UavTeam.Uav(ii).Modularity.vmax+NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned;
                NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];
            end
        case 3
            num=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==Roundabout_num);
            Or = Roundabout(num).pos;
            last_point = NewUavTeam.Uav(ii).Routing.PathPlanning(find(NewUavTeam.Uav(ii).Routing.PathPlanning==NewUavTeam.Uav(ii).State.CurrentWaypoint)-1);
            Highway_in=find(last_point==Roundabout(num).connection);
            Highway_out=find(next_point==Roundabout(num).connection);
            angle1=atan2(Pcur(2)+Vcur(2)/L-Roundabout(num).Highway(Highway_in).om(2),Pcur(1)+Vcur(1)/L-Roundabout(num).Highway(Highway_in).om(1));
            angle2=atan2(Pcur(2)+Vcur(2)/L-Roundabout(num).Highway(Highway_out).od(2),Pcur(1)+Vcur(1)/L-Roundabout(num).Highway(Highway_out).od(1));
            theta1=atan2(Or(2)-Roundabout(num).Highway(Highway_in).om(2),Or(1)-Roundabout(num).Highway(Highway_in).om(1));
            theta2=atan2(Roundabout(num).Highway(Highway_in).p(2)-Roundabout(num).Highway(Highway_in).om(2),Roundabout(num).Highway(Highway_in).p(1)-Roundabout(num).Highway(Highway_in).om(1));
            theta3=atan2(Or(2)-Roundabout(num).Highway(Highway_out).od(2),Or(1)-Roundabout(num).Highway(Highway_out).od(1));
            theta4=atan2(Roundabout(num).Highway(Highway_out).p(2)-Roundabout(num).Highway(Highway_out).od(2),Roundabout(num).Highway(Highway_out).p(1)-Roundabout(num).Highway(Highway_out).od(1));
            V2D=norm(NewUavTeam.Uav(ii).State.Velocity(1:2));
            if (mode==1 || mode==2) && NewUavTeam.Uav(ii).State.RoundaboutState ==4  && myangle(angle2,theta3)+myangle(angle2,theta4)>myangle(theta3,theta4)+0.0001
                NewUavTeam.Uav(ii).Routing.NextWaypoint = next_point;
                ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));

                index=intersect(ans1,ans2);%
                Roundabout(num).accumulation=Roundabout(num).accumulation-1;
                Roundabout(num).PeriodNexit = Roundabout(num).PeriodNexit+1;
                Airway(index).accumulation=Airway(index).accumulation+1;
                Airway(index).PeriodNum=Airway(index).PeriodNum+1;
                if Roundabout(num).accumulation==0
                    Roundabout(num).AverageSpeed=0;
                else
                    Roundabout(num).AverageSpeed=(Roundabout(num).AverageSpeed*(Roundabout(num).accumulation+1)-V2D)/(Roundabout(num).accumulation);
                end
                Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation-1)+V2D)/(Airway(index).accumulation);
                theta5=atan2(Roundabout(num).pos(2)-Roundabout(num).Highway(Highway_in).om(2),Roundabout(num).pos(1)-Roundabout(num).Highway(Highway_in).om(1));
                theta6=atan2(Roundabout(num).pos(2)-Roundabout(num).Highway(Highway_out).od(2),Roundabout(num).pos(1)-Roundabout(num).Highway(Highway_out).od(1));
                temp=(Roundabout(num).radius_o-Roundabout(num).radius_i)/2;
                NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=(myangle(theta5,theta6)*(Roundabout(num).radius_i+Roundabout(num).radius_o)/2)+(myangle(theta1,theta2)*(Roundabout(num).ra+temp)*2)...
                    /UavTeam.Uav(ii).Modularity.vmax+NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned;
                NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];

            end
            %unstructured airspace
            if mode==3
                next_point = NewUavTeam.Uav(ii).Routing.PathPlanning(find(NewUavTeam.Uav(ii).Routing.PathPlanning==NewUavTeam.Uav(ii).State.CurrentWaypoint)+1);
                N1=[AirwayNetwork(NewUavTeam.Uav(ii).State.CurrentWaypoint,:)]';
                N2=[AirwayNetwork(next_point,:)]';
                [pt1,pt2,pt3,ptz]=tunnel(N1,N2,rh1,rh2,rh_z);
                pt2_n=pt1+(pt2-pt1)/norm(pt2-pt1)*Roundabout(num).changedis;
                pt3_n=pt2_n+pt3-pt2;
                if norm(Pcur+1/UavTeam.Uav(ii).Modularity.gain*Vcur-(pt2_n+pt3_n)/2)<=rh1/2
                    NewUavTeam.Uav(ii).Routing.NextWaypoint = next_point; %
                    NewUavTeam.Uav(ii).State.verticalcommand=1;
                    ans1=find(NewUavTeam.Uav(ii).State.CurrentWaypoint==AirwayList(:,1));
                    ans2=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==AirwayList(:,2));
                    index=intersect(ans1,ans2);
                    Roundabout(num).accumulation=Roundabout(num).accumulation-1;
                    Roundabout(num).PeriodNexit = Roundabout(num).PeriodNexit+1;
                    Airway(index).accumulation=Airway(index).accumulation+1;
                    Airway(index).PeriodNum=Airway(index).PeriodNum+1;
                    if Roundabout(num).accumulation==0
                        Roundabout(num).AverageSpeed=0;
                    else
                        Roundabout(num).AverageSpeed=(Roundabout(num).AverageSpeed*(Roundabout(num).accumulation+1)-V2D)/(Roundabout(num).accumulation);
                    end
                    Airway(index).AverageSpeed=(Airway(index).AverageSpeed*(Airway(index).accumulation-1)+V2D)/(Airway(index).accumulation);
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime=time;
                    %%%%
                    NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned=Airway(index).Dx/UavTeam.Uav(ii).Modularity.vmax+NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned;
                    %%%%
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVector;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTime];
                    NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned=[NewUavTeam.Uav(ii).Scheduling.ArriveTimeVectorPlanned;NewUavTeam.Uav(ii).Scheduling.CurrentElementArriveTimePlanned];

                end
            end
        case 4
            if NewUavTeam.Uav(ii).type==4 && norm(Pcur(3))<=1
                NewUavTeam.Uav(ii).LandingState=2;
            end
    end

end
TrafficCharacteristicsMatrix=zeros(1,length(Airway)*2+length(Node)*2+length(Roundabout)*2+1);%%2023.2.9gaiguo
TrafficCharacteristicsMatrix(1)=time;
for ii=1:length(Airway)
    TrafficCharacteristicsMatrix(2*ii)=Airway(ii).accumulation;
    TrafficCharacteristicsMatrix(2*ii+1)=Airway(ii).AverageSpeed;
end
for ii=1:length(Node)
    TrafficCharacteristicsMatrix(2*length(Airway)+2*ii)=Node(ii).accumulation;
    TrafficCharacteristicsMatrix(2*length(Airway)+2*ii+1)=Node(ii).AverageSpeed;
end
for ii=1:length(Roundabout)
    TrafficCharacteristicsMatrix(2*length(Airway)+2*length(Node)+2*ii)=Roundabout(ii).accumulation;
    TrafficCharacteristicsMatrix(2*length(Airway)+2*length(Node)+2*ii+1)=Roundabout(ii).AverageSpeed;
end
TrafficCharacteristicsMatrix=mat2cell(TrafficCharacteristicsMatrix',ones(1,length(Airway)*2+length(Node)*2+length(Roundabout)*2+1));