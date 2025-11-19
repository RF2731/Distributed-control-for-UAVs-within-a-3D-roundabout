function [NewUavTeam,routingnum]=Routing(UavTeam,TrafficCharacteristics,TFC,AirwayList,AllPaths)
global routingmode
NewUavTeam=UavTeam;
routingnum=0;
for ii=1:length(NewUavTeam.Uav)
    if NewUavTeam.Uav(ii).State.ElementType==1 && routingmode==1
        temp=find(NewUavTeam.Uav(ii).Routing.NextWaypoint==NewUavTeam.Uav(ii).Routing.PathPlanning);
        routelist=AllPaths{NewUavTeam.Uav(ii).Routing.PathPlanning(temp),NewUavTeam.Uav(ii).Routing.FinalWaypoint};
        if size(routelist,2)>1
            arrivetime=zeros(size(routelist,2),1);
            for jj=1:size(routelist,2)
                for kk=1:length(routelist{1,jj})-1
                    temp1=find(routelist{1,jj}(kk)==AirwayList(:,1));
                    temp2=find(routelist{1,jj}(kk+1)==AirwayList(:,2));
                    index=intersect(temp1,temp2);
                    if ~isempty(TFC.Airway(index).AverageSpeed) && TFC.Airway(index).AverageSpeed(end)~=0
                        vel=min(NewUavTeam.Uav(ii).Modularity.vmax,TFC.Airway(index).AverageSpeed(end));
                    else
                        vel=NewUavTeam.Uav(ii).Modularity.vmax;
                    end
                    arrivetime(jj)=arrivetime(jj)+routelist{2,jj}(kk)/vel;
                end
            end
            [~,min1]=min(arrivetime);
            [~,min2]=min(cell2mat(routelist(3,:)));
            if  (routelist{1,min1}(2)~=NewUavTeam.Uav(ii).Routing.PathPlanning(temp-1))
                if min1~=min2 
                NewUavTeam.Uav(ii).Routing.RoutingActive=1;
                NewRoute=routelist{1,min1};
                NewRoute=NewRoute(2:end);
                PreRoute=NewUavTeam.Uav(ii).Routing.PathPlanning(1:temp);
                NewUavTeam.Uav(ii).Routing.PathPlanning=cat(2,PreRoute,NewRoute);
                else
                NewRoute=routelist{1,min2};
                NewRoute=NewRoute(2:end);
                PreRoute=NewUavTeam.Uav(ii).Routing.PathPlanning(1:temp);
                NewUavTeam.Uav(ii).Routing.PathPlanning=cat(2,PreRoute,NewRoute);
                end
            end
        end
    end
end
end