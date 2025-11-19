function [UAVstate,Newaccumulation,Airway] = createUAV(time,k,AirportNum,Airway,AirwayList,Airport,gain,ll,accumulation,lanenum,vmax,vzmax,scenario,TFC)
global rs ra AllPaths totalnum
global AirwayNetwork rh1 rh2 rh_z lanewidth laneiso routingmode
% UAVstate.state = 0;
Airport_temp=Airport;
Newaccumulation= accumulation+1;
%% Parameters for Modularity
% (k-1)*lanenum+ll+totalnum(AirportNum)
UAVstate.Modularity.ID=(k-1)*lanenum+ll+totalnum(AirportNum);
UAVstate.Modularity.gain=gain;
if scenario ==1 && rh1/2>=2*ra
    UAVstate.Modularity.vmax = 8+(4*rand-2) ;
    %  UAVstate.vmax = 8 ;
else if scenario == 1
        UAVstate.Modularity.vmax = 6 ;
else if scenario==7
        UAVstate.Modularity.vmax = 8+(4*rand-2) ;
else

    UAVstate.Modularity.vmax  = vmax;
end
end
end
UAVstate.Modularity.Origin=Airport(AirportNum).num;
Airport_temp(AirportNum)=[];
% temp=ceil(rand*size(AllPaths{AirportNum}));
UAVstate.Modularity.Destination=Airport_temp(randi(length(Airport_temp))).num;
temp=AllPaths{UAVstate.Modularity.Origin,UAVstate.Modularity.Destination};

switch routingmode
    case 1
                minindex=find(min(cell2mat(temp(3,:)))==cell2mat(temp(3,:)));
        if length(minindex)>1
            temp1=randi(length(minindex));
            index=minindex(temp1);
        else
            index=minindex;
        end
        Path=temp{1,index};
UAVstate.Modularity.PathPlanning=PreRouting(Path,TFC,AirwayList,temp,UAVstate.Modularity.vmax);
    case 2
        tempnum=size(temp,2);
        tempmat=linspace(1,tempnum,tempnum);
        index=tempmat(randperm(numel(tempmat),1));
        UAVstate.Modularity.PathPlanning=temp{1,index};
    case 3
        minindex=find(min(cell2mat(temp(3,:)))==cell2mat(temp(3,:)));
        if length(minindex)>1
            temp1=randi(length(minindex));
            index=minindex(temp1);
        else
            index=minindex;
        end
        UAVstate.Modularity.PathPlanning=temp{1,index};
end
% UAVstate.Modularity.PathPlanning=temp{1,index};

UAVstate.Modularity.vzmax = vzmax;



UAVstate.Modularity.rs=rs;
UAVstate.Modularity.ra=ra;
UAVstate.State.lane=ll;% to be improved (lane changing)
if lanenum==1
maxinflow=floor(rh1/(2*ra));
else
   maxinflow=floor(lanewidth/(2*ra)); 
end
[pt1,pt2,pt3,ptz]=tunnel(AirwayNetwork(UAVstate.Modularity.PathPlanning(1),:)',AirwayNetwork(UAVstate.Modularity.PathPlanning(2),:)',rh1,rh2,rh_z);
if scenario==1||scenario==7
    temp1=rh1/2-ra;
    temp=(pt3-pt2)/norm(pt3-pt2)*(rand*2-1)*temp1;
    UAVstate.Modularity.HomePos = [AirwayNetwork(UAVstate.Modularity.PathPlanning(1),:)]'...
        +temp+[(pt3-pt2)/norm(pt3-pt2)*(rh1+rh2)/2];
else
    if lanenum==1
        laneindex= (rem(k,maxinflow)+1);
        iso=(rh1-2*ra*maxinflow)/(maxinflow+1);
        temp=(pt3-pt2)/norm(pt3-pt2)*(-laneindex*iso-(2*laneindex-1)*ra);
        UAVstate.Modularity.HomePos = [AirwayNetwork(UAVstate.Modularity.PathPlanning(1),:)]'...
            +temp+[(pt3-pt2)/norm(pt3-pt2)*(rh1+rh2/2)];
    else
        laneindex= (rem(k,maxinflow)+1);
        iso=(lanewidth-2*ra*maxinflow)/(maxinflow+1);
        temp=(pt3-pt2)/norm(pt3-pt2)*(-laneindex*iso-(2*laneindex-1)*ra);
        UAVstate.Modularity.HomePos = [AirwayNetwork(UAVstate.Modularity.PathPlanning(1),:)]'...
            +temp+[(pt3-pt2)/norm(pt3-pt2)*((lanewidth+rh2/2)+(UAVstate.State.lane-1)*(laneiso+lanewidth))];
    end
end
%% Parameters for State
ans1=find(UAVstate.Modularity.PathPlanning(1)==AirwayList(:,1));
ans2=find(UAVstate.Modularity.PathPlanning(2)==AirwayList(:,2));
index=intersect(ans1,ans2);
UAVstate.State.CurrentPos = UAVstate.Modularity.HomePos;

UAVstate.State.verticalcommand=1;
unit=(AirwayNetwork(UAVstate.Modularity.PathPlanning(2),:)-AirwayNetwork(UAVstate.Modularity.PathPlanning(1),:))';
UAVstate.State.Velocity = unit/norm(unit)*UAVstate.Modularity.vmax;
UAVstate.State.VelocityCom=UAVstate.State.Velocity;
UAVstate.State.CurrentWaypoint=UAVstate.Modularity.PathPlanning(1);
UAVstate.State.ElementType=0;%%%state
UAVstate.State.ElementNum=index;%%%type
UAVstate.State.LandingState = 0;
UAVstate.State.TakeOffState = 1;%%% to be improved
UAVstate.State.TravelTime=0;
UAVstate.State.TravelDistance = 0;
UAVstate.State.RoundaboutState=[];
%% Parameters for Scheduling
UAVstate.Scheduling.DepartTimePlanned=time;
UAVstate.Scheduling.DepartTime=time;
% UAVstate.Scheduling.ClearToDepart=[];
UAVstate.Scheduling.CurrentElementArriveTime=[];
UAVstate.Scheduling.CurrentElementArriveTimePlanned=[];
UAVstate.Scheduling.FinalArriveTime=[];
UAVstate.Scheduling.FinalArriveTimePlanned=[];
UAVstate.Scheduling.ArriveTimeVector=[time];
UAVstate.Scheduling.ArriveTimeVectorPlanned=[time];
%% Parameters for Routing
UAVstate.Routing.PathPlanning=UAVstate.Modularity.PathPlanning;
UAVstate.Routing.LastWaypoint=[];
UAVstate.Routing.RecordWaypoint=[];
UAVstate.Routing.OriginWaypoint=UAVstate.Modularity.PathPlanning(1);
UAVstate.Routing.NextWaypoint=UAVstate.Modularity.PathPlanning(2);
UAVstate.Routing.FinalWaypoint=UAVstate.Modularity.PathPlanning(end);
UAVstate.Routing.RoutingActive=0;
%% Parameters for Speed Limit
UAVstate.SpeedLimit.vmaxPlanned=UAVstate.Modularity.vmax;
UAVstate.SpeedLimit.vzmaxPlanned=UAVstate.Modularity.vzmax;
UAVstate.SpeedLimit.vmaxLimited=UAVstate.Modularity.vmax;
UAVstate.SpeedLimit.vzmaxLimited=UAVstate.Modularity.vzmax;
UAVstate.SpeedLimit.SpeedLimitActive=0;
%% Parameters for Signal Control
UAVstate.Signal.Wait = 0;
%% Update Airway
Airway(index).AverageSpeed=(Airway(index).AverageSpeed*Airway(index).accumulation+norm(UAVstate.State.Velocity(1:2)))/(Airway(index).accumulation+1);
Airway(index).PeriodNum=Airway(index).PeriodNum+1;

Airway(index).accumulation=Airway(index).accumulation+1;