function [NewUavTeam,NewState,ArriveNum,Airway,Node,Roundabout]=UAVStateUpdate(UavTeam,VelocityCom,Ts,M,Airway,Node,Roundabout)
ArriveNum=[];
NewUavTeam=UavTeam;
NewState=zeros(1,4*M+1);
for kk=1:length(UavTeam.Uav)
    ID=UavTeam.Uav(kk).Modularity.ID;
    NewUavTeam.Uav(kk).State.VelocityCom=VelocityCom(3*kk-2:3*kk);
    NewUavTeam.Uav(kk).State.Velocity = (1-UavTeam.Uav(kk).Modularity.gain*Ts)*UavTeam.Uav(kk).State.Velocity+UavTeam.Uav(kk).Modularity.gain*Ts*UavTeam.Uav(kk).State.VelocityCom;
    NewUavTeam.Uav(kk).State.Velocity = [mysat(NewUavTeam.Uav(kk).State.Velocity(1:2),NewUavTeam.Uav(kk).Modularity.vmax);mysat(NewUavTeam.Uav(kk).State.Velocity(3),NewUavTeam.Uav(kk).Modularity.vzmax)];
    NewUavTeam.Uav(kk).State.CurrentPos = UavTeam.Uav(kk).State.CurrentPos+Ts*UavTeam.Uav(kk).State.Velocity;
    NewUavTeam.Uav(kk).State.TravelDistance=NewUavTeam.Uav(kk).State.TravelDistance+Ts*norm(UavTeam.Uav(kk).State.Velocity);
    NewUavTeam.Uav(kk).State.TravelTime=NewUavTeam.Uav(kk).State.TravelTime+Ts;
    NewState(3*ID-1:3*ID+1)= UavTeam.Uav(kk).State.CurrentPos;
    NewState(3*M+1+ID)=100*UavTeam.Uav(kk).State.ElementType+UavTeam.Uav(kk).State.ElementNum;
    if UavTeam.Uav(kk).State.LandingState == 1
        ArriveNum=[ArriveNum kk];
    end
    temp=NewUavTeam.Uav(kk).State.ElementNum;
    switch NewUavTeam.Uav(kk).State.ElementType
        case 1
            Airway(temp).AverageSpeed=(Airway(temp).AverageSpeed*Airway(temp).accumulation...
                -norm(UavTeam.Uav(kk).State.Velocity(1:2))+norm(NewUavTeam.Uav(kk).State.Velocity(1:2)))/Airway(temp).accumulation;
            Airway(temp).PeriodTTD=Airway(temp).PeriodTTD+Ts*norm(UavTeam.Uav(kk).State.Velocity);
            Airway(temp).PeriodTTT=Airway(temp).PeriodTTT+Ts;
        case 2
            Node(temp).AverageSpeed=(Node(temp).AverageSpeed*Node(temp).accumulation...
                -norm(UavTeam.Uav(kk).State.Velocity(1:2))+norm(NewUavTeam.Uav(kk).State.Velocity(1:2)))/Node(temp).accumulation;
            Node(temp).PeriodTTD=Node(temp).PeriodTTD+Ts*norm(UavTeam.Uav(kk).State.Velocity);
            Node(temp).PeriodTTT=Node(temp).PeriodTTT+Ts;
        case 3
            Roundabout(temp).AverageSpeed=(Roundabout(temp).AverageSpeed*Roundabout(temp).accumulation...
                -norm(UavTeam.Uav(kk).State.Velocity(1:2))+norm(NewUavTeam.Uav(kk).State.Velocity(1:2)))/Roundabout(temp).accumulation;
            Roundabout(temp).PeriodTTD=Roundabout(temp).PeriodTTD+Ts*norm(UavTeam.Uav(kk).State.Velocity);
            Roundabout(temp).PeriodTTT=Roundabout(temp).PeriodTTT+Ts;
    end

end
NewState=NewState(2:end);
