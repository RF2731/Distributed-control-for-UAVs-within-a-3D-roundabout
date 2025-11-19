function [TrafficCharacteristics,calculatenum]=CalculateTrafficCharacteristics(Airway,Node,Roundabout,vmax)
for ii=1:length(Airway)
    TrafficCharacteristics.Airway(ii).num=Airway(ii).num;
    TrafficCharacteristics.Airway(ii).accumulation=Airway(ii).accumulation;
    TrafficCharacteristics.Airway(ii).AverageSpeed=Airway(ii).AverageSpeed;
    TrafficCharacteristics.Airway(ii).SpeedLimitActive=0;
    TrafficCharacteristics.Airway(ii).SpeedLimit=vmax;
end
for ii=1:length(Node)
    TrafficCharacteristics.Node(ii).num=Node(ii).num;
    TrafficCharacteristics.Node(ii).accumulation=Node(ii).accumulation;
    TrafficCharacteristics.Node(ii).AverageSpeed=Node(ii).AverageSpeed;
    TrafficCharacteristics.Node(ii).SpeedLimitActive=0;
    TrafficCharacteristics.Node(ii).SpeedLimit=vmax;
end
for ii=1:length(Roundabout)
    TrafficCharacteristics.Roundabout(ii).num=Roundabout(ii).num;
    TrafficCharacteristics.Roundabout(ii).accumulation=Roundabout(ii).accumulation;
    TrafficCharacteristics.Roundabout(ii).AverageSpeed=Roundabout(ii).AverageSpeed;
    TrafficCharacteristics.Roundabout(ii).SpeedLimitActive=0;
    TrafficCharacteristics.Roundabout(ii).SpeedLimit=vmax;
end
calculatenum=0;