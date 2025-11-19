function [TFC,TFC_RF,Airway,calculatenum]=CalTFC(time,StateMatrix,M,Ts,dtTFC,TFC,TFC_RF,Airway,Node,Roundabout)

for ii=1:length(Airway)
    [TFC.Airway(ii)] = CalTFC_Airway(time,TFC.Airway(ii),StateMatrix,ii,1,M,Ts,dtTFC,Airway(ii));
%     [TFC.Airway(ii),Airway(ii)] = CalTFC_Airway_RF(time,TFC.Airway(ii),StateMatrix,ii,1,M,Ts,dtTFC,Airway(ii));
    TFC.AirwaysAccumulation(time/dtTFC,ii)=TFC.Airway(ii).Accumulation(time/dtTFC);
    TFC.AirwaysAverageSpeed(time/dtTFC,ii)=TFC.Airway(ii).AverageSpeed(time/dtTFC);
    TFC.AirwaysOutflow(time/dtTFC,ii)=TFC.Airway(ii).Outflow(time/dtTFC);
    TFC.AirwaysFlow(time/dtTFC,ii)=TFC.Airway(ii).Flow(time/dtTFC);
    TFC.AirwaysDensity(time/dtTFC,ii)=TFC.Airway(ii).Density(time/dtTFC);
    TFC.AirwaysTTT(time/dtTFC,ii)=TFC.Airway(ii).TTT(time/dtTFC);
end
for ii=1:length(Airway)
%     [TFC.Airway(ii)] = CalTFC_Airway(time,TFC.Airway(ii),StateMatrix,ii,1,M,Ts,dtTFC,Airway(ii));
    [TFC_RF.Airway(ii),Airway(ii)] = CalTFC_Airway_RF(time,TFC_RF.Airway(ii),StateMatrix,ii,1,M,Ts,dtTFC,Airway(ii));
    TFC_RF.AirwaysAccumulation(time/dtTFC,ii)=TFC_RF.Airway(ii).Accumulation(time/dtTFC);
    TFC_RF.AirwaysAverageSpeed(time/dtTFC,ii)=TFC_RF.Airway(ii).AverageSpeed(time/dtTFC);
    TFC_RF.AirwaysOutflow(time/dtTFC,ii)=TFC_RF.Airway(ii).Outflow(time/dtTFC);
    TFC_RF.AirwaysFlow(time/dtTFC,ii)=TFC_RF.Airway(ii).Flow(time/dtTFC);
    TFC_RF.AirwaysDensity(time/dtTFC,ii)=TFC_RF.Airway(ii).Density(time/dtTFC);
    TFC_RF.AirwaysTTT(time/dtTFC,ii)=TFC_RF.Airway(ii).TTT(time/dtTFC);
end

for ii=1:length(Roundabout)
%     [TFC.Airway(ii)] = CalTFC_Airway(time,TFC.Airway(ii),StateMatrix,ii,1,M,Ts,dtTFC,Airway(ii));
    [TFC_RF.Roundabout(ii),Roundabout(ii)] = CalTFC_Roundabout_RF(time,TFC_RF.Roundabout(ii),StateMatrix,ii,1,M,Ts,dtTFC,Roundabout(ii));
    TFC_RF.RoundaboutsAccumulation(time/dtTFC,ii)=TFC_RF.Roundabout(ii).Accumulation(time/dtTFC);
    TFC_RF.RoundaboutsAverageSpeed(time/dtTFC,ii)=TFC_RF.Roundabout(ii).AverageSpeed(time/dtTFC);
    TFC_RF.RoundaboutsOutflow(time/dtTFC,ii)=TFC_RF.Roundabout(ii).Outflow(time/dtTFC);
    TFC_RF.RoundaboutsFlow(time/dtTFC,ii)=TFC_RF.Roundabout(ii).Flow(time/dtTFC);
    TFC_RF.RoundaboutsDensity(time/dtTFC,ii)=TFC_RF.Roundabout(ii).Density(time/dtTFC);
    TFC_RF.RoundaboutsTTT(time/dtTFC,ii)=TFC_RF.Roundabout(ii).TTT(time/dtTFC);
end
% disp(['time= ' num2str(time) ' n=' num2str(TFC.AirwaysAccumulation(end,:)) ' vs=' num2str(TFC.AirwaysAccumulation(end,:))])
calculatenum=0;