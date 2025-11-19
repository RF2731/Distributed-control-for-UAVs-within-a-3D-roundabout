TFC = [];
if(~isempty(Airway))
    TFC.Airway = [];
    for ii=1:length(Airway)
        TFC.Airway(ii).Accumulation = [];
        TFC.Airway(ii).AverageSpeed = [];
        TFC.Airway(ii).Outflow = [];
        TFC.Airway(ii).Flow = [];
        TFC.Airway(ii).Density = [];
TFC.Airway(ii).TTT = [];
    end
    TFC.AirwaysAccumulation = zeros(1,length(Airway));
    TFC.AirwaysAverageSpeed = zeros(1,length(Airway));
    TFC.AirwaysOutflow = zeros(1,length(Airway));
    TFC.AirwaysFlow = zeros(1,length(Airway));
    TFC.AirwaysDensity = zeros(1,length(Airway));
    TFC.AirwaysTTT = zeros(1,length(Airway));
end
if(length(Node))
    TFC.Node = [];
    for ii=1:length(Node)
        TFC.Node(ii).Accumulation = [];
        TFC.Node(ii).AverageSpeed = [];
        TFC.Node(ii).Outflow = [];
        TFC.Node(ii).Flow = [];
        TFC.Node(ii).Density = [];
        TFC.Node(ii).TTT = [];
    end
    TFC.NodesAccumulation = zeros(1,length(Node));
    TFC.NodesAverageSpeed = zeros(1,length(Node));
    TFC.NodesOutflow = zeros(1,length(Node));
    TFC.NodesFlow = zeros(1,length(Node));
    TFC.NodesDensity = zeros(1,length(Node));
    TFC.NodesTTT = zeros(1,length(Airway));
end
if(length(Roundabout))
    TFC.Roundabout = [];
    for ii=1:length(Roundabout)
        TFC.Roundabout(ii).Accumulation = [];
        TFC.Roundabout(ii).AverageSpeed = [];
        TFC.Roundabout(ii).Outflow = [];
        TFC.Roundabout(ii).Flow = [];
        TFC.Roundabout(ii).Density = [];
        TFC.Roundabout(ii).TTT = [];
    end
    TFC.RoundaboutsAccumulation = zeros(1,length(Roundabout));
    TFC.RoundaboutsAverageSpeed = zeros(1,length(Roundabout));
    TFC.RoundaboutsOutflow = zeros(1,length(Roundabout));
    TFC.RoundaboutsFlow = zeros(1,length(Roundabout));
    TFC.RoundaboutsDensity = zeros(1,length(Roundabout));
    TFC.RoundaboutsTTT = zeros(1,length(Airway));
end


TFC_RF = [];
if(~isempty(Airway))
    TFC_RF.Airway = [];
    for ii=1:length(Airway)
        TFC_RF.Airway(ii).Accumulation = [];
        TFC_RF.Airway(ii).AverageSpeed = [];
        TFC_RF.Airway(ii).Outflow = [];
        TFC_RF.Airway(ii).Flow = [];
        TFC_RF.Airway(ii).Density = [];
TFC_RF.Airway(ii).TTT = [];
    end
    TFC_RF.AirwaysAccumulation = zeros(1,length(Airway));
    TFC_RF.AirwaysAverageSpeed = zeros(1,length(Airway));
    TFC_RF.AirwaysOutflow = zeros(1,length(Airway));
    TFC_RF.AirwaysFlow = zeros(1,length(Airway));
    TFC_RF.AirwaysDensity = zeros(1,length(Airway));
    TFC_RF.AirwaysTTT = zeros(1,length(Airway));
end
if(length(Node))
    TFC_RF.Node = [];
    for ii=1:length(Node)
        TFC_RF.Node(ii).Accumulation = [];
        TFC_RF.Node(ii).AverageSpeed = [];
        TFC_RF.Node(ii).Outflow = [];
        TFC_RF.Node(ii).Flow = [];
        TFC_RF.Node(ii).Density = [];
        TFC_RF.Node(ii).TTT = [];
    end
    TFC_RF.NodesAccumulation = zeros(1,length(Node));
    TFC_RF.NodesAverageSpeed = zeros(1,length(Node));
    TFC_RF.NodesOutflow = zeros(1,length(Node));
    TFC_RF.NodesFlow = zeros(1,length(Node));
    TFC_RF.NodesDensity = zeros(1,length(Node));
    TFC_RF.NodesTTT = zeros(1,length(Airway));
end
if(length(Roundabout))
    TFC_RF.Roundabout = [];
    for ii=1:length(Roundabout)
        TFC_RF.Roundabout(ii).Accumulation = [];
        TFC_RF.Roundabout(ii).AverageSpeed = [];
        TFC_RF.Roundabout(ii).Outflow = [];
        TFC_RF.Roundabout(ii).Flow = [];
        TFC_RF.Roundabout(ii).Density = [];
        TFC_RF.Roundabout(ii).TTT = [];
    end
    TFC_RF.RoundaboutsAccumulation = zeros(1,length(Roundabout));
    TFC_RF.RoundaboutsAverageSpeed = zeros(1,length(Roundabout));
    TFC_RF.RoundaboutsOutflow = zeros(1,length(Roundabout));
    TFC_RF.RoundaboutsFlow = zeros(1,length(Roundabout));
    TFC_RF.RoundaboutsDensity = zeros(1,length(Roundabout));
    TFC_RF.RoundaboutsTTT = zeros(1,length(Airway));
end
