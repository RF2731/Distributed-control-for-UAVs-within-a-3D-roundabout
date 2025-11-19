clc;
clear variables;
close all;
dbstop if error;
addpath(genpath(pwd));
% for inflowvec=0.1:0.1:1

disp(['Sim started: Time - ' datestr(now)])
StartSimTime = now;
%%
global rs ra rd Gainfactor_rs Gainfactor_ra
global Airport Node Roundabout UAVnum totalnum
global AirwayNetwork AdjacentMatrix AllPaths AirwayList Airway
global ConflictsNum ConflictMatrix mode ConflictMatrix2
global Airport_num Node_num Roundabout_num scenario gain
global rh1 rh2 rh_z lanenum laneiso lanewidth height routingmode
%%%%%%%%%%%% global settings
plotactive=1;% 1 or 0
Ts=0.2;%time-step
plot_interval=5;%second
conflictcalculate=1;
calculate_interval=1;%second
routing_interval=30;%second
plotnum=0;
routingnum=0;
tempplot=[];
ConflictsNum=0;
calculatenum=0;
routingmode=1;%1:bang-bang routing,2:random routing,
%%%%%%%%%%%%vehicle settings
rs = 2;
ra = 3;
rd = 30;
Gainfactor_rs = 1;
Gainfactor_ra = 1;
vmax=8;
vzmax=8;
routingactive=1;
%%%%%%%%%%%%%%% Network Settings
lanenum=1;%% multi-lane settings. If it is larger than 1, the following inflow settings will
% represent the inflow of each lane.
laneiso=2;% lane isolation band width (only use for multi-lane settings)
rh1=40;% airway width
lanewidth = (rh1-laneiso*(lanenum-1))/lanenum;
rh2=15;% airway isolation width
rh_z=20;% airway height
r_airport = 0;
min_turn_radius = 2;%
height = 120;% the height of the air traffic network
R_ChangeHeight=20;%Distance between different layers in 3D roundabout structure
scenario=2;%
mode =1; 
[AirwayNetwork,AdjacentMatrix,Airport,Node,Roundabout,AllPaths,AirwayList,Airway,Airport_num,Node_num,Roundabout_num] = Initial_NetworkSettings(lanenum,vmax,laneiso,lanewidth,rh1,rh2,rh_z,r_airport,min_turn_radius,height,R_ChangeHeight,scenario);
%%%%%%%%%%%%%% Inflow Settings
InflowRateVec =0.1*lanenum; % Inflow Rate for each lane
if (InflowRateVec>floor(rh1/(2*ra))) % maximum inflow limitation according to the airway width and avoidance radius
    error('Inflow rate can not be bigger')
end
InflowPlan = 1; % Inflow Profile
UAVnum=zeros(1,length(Airport));
totalnum=zeros(1,length(Airport));
for ii=1:length(Airport)

    switch InflowPlan
        case 1
             % Testing & Debugging
            switchtime = [0;5;10];%(min)
            switchvalue = InflowRateVec.*[2;2];%(veh/s) please set the value less than 6, otherwise it is unreasonable according to the
      
        case 5 % Testing & Debugging
            switchtime = [0;2;4;8;12;16;18;20];%(min)
            switchvalue = InflowRateVec.*[0.5;1;1.5;2;1.5;1;0.5];%(veh/s) please set the value less than 6, otherwise it is unreasonable according to the
            % width & height of airways. (larger than 3 will cause congestion at the arc roads, I don't know if it is reasonable.)
        case 10 % 10 Min Simulation (Minimum Profile)
            switchtime = [0;5;10];%(min)
            switchvalue = InflowRateVec.*[1;0];%(veh/s) please set the value less than 6, otherwise it is unreasonable according to the
            % width & height of airways. (larger than 3 will cause congestion at the arc roads, I don't know if it is reasonable.)
        case 30 % 30 Minutes, including warmup and cooldown periods
            switchtime = [0;5;10;15;45;50;55;60]./2;%(min)
            switchvalue = InflowRateVec.*[0.2;0.6;0.8;1;0.8;0.6;0];%(veh/s)
        case 60 % One hour, including warmup and cooldown periods
            switchtime = [0;5;10;15;45;50;55;60];%(min)
            switchvalue = InflowRateVec.*[0.2;0.6;0.8;1;0.8;0.6;0];%(veh/s)
        otherwise
            error('Inflow Plan index does not exist.')
    end
    disp(['Qin_avg=' num2str(sum(switchvalue.*diff(switchtime))./switchtime(end))])
    QinAvg = sum(switchvalue.*diff(switchtime))./switchtime(end);
    glowthrate = [zeros(size(switchvalue))];

    if scenario==1 && ii==2
        switchvalue=0.*switchvalue;
    end
    if scenario==7 && ii==2
        switchvalue=0.*switchvalue;
    end
    if ii==1
        inflow_settings = inflowInitialization(switchtime,switchvalue,glowthrate,lanenum);
    end
    inflow_settings(ii) = inflowInitialization(switchtime,switchvalue,glowthrate,lanenum);
    UAVnum(ii) = inflow_settings(ii).totalnum(end);
    if ii==1
        totalnum(ii) = UAVnum(ii);
    else
        totalnum(ii) = totalnum(ii-1)+UAVnum(ii);
    end
    % Initialize UavTeam
    time_end=inflow_settings(ii).time(end);
end


totalnum=[0 totalnum];
M=sum(UAVnum);
if conflictcalculate==1
    ConflictMatrix=zeros(M,M);
    ConflictMatrix2=zeros(M,M);
else
    ConflictMatrix=[];
    ConflictMatrix2=[];
end
% Initialize UavTeam
UavTeam = UAVInitialization(M,UAVnum);
gain=2;
hold off
if plotactive==1
    fig=MyMap(UavTeam,mode,scenario);
end
AirwayDisplay=scenariomatrix(AdjacentMatrix,AirwayNetwork,Airway,Node,Roundabout,rh1,rh2,rh_z);
save('TubeMatrix.mat','AirwayDisplay');
csvwrite('Tube.csv',AirwayDisplay);
%% TFC Settings
dtTFC = 30;
SetupTFC
%% Analysis
StateMatrix=zeros(time_end/Ts+1,4*M+1);
accumulation=0;
StateMatrix(:,1)=0:Ts:time_end;
%% RF calculate
TrafficCharacteristicsMatrix=CreateTrafficCharacteristicsMatrix(Airway,Node,Roundabout,time_end,Ts);
ArrivedUavTeam=[];
%%
for time=0:Ts:time_end
    time
    %         if isfield(UavTeam,'Uav')
    plotnum=plotnum+1;
    calculatenum=calculatenum+1;
    routingnum=routingnum+1;
    %         end
    [UavTeam,accumulation,Airway]=UAVinflow(time,inflow_settings,Airway,AirwayList,Airport,UavTeam,gain,accumulation,lanenum,vmax,vzmax,scenario,TFC);
    if isfield(UavTeam,'Uav')
        %%% speed limit
        UavTeam=SpeedLimit(UavTeam);
        %%% microscopic distributed controller
        [UavTeam,VelocityCom,ConflictMatrix,ConflictMatrix2]=collisioncon(UavTeam,accumulation,conflictcalculate,ConflictMatrix,ConflictMatrix2,vmax);

        %%% update states
        [UavTeam,StateMatrix(fix(time*(1/Ts))+1,2:end),ArriveNum,Airway,Node,Roundabout]=UAVStateUpdate(UavTeam,VelocityCom,Ts,M,Airway,Node,Roundabout);
        %%% remove the arrived vehicles
        [UavTeam,ArrivedUavTeam,accumulation] = removeUAV(UavTeam,ArriveNum,ArrivedUavTeam,accumulation);
        %%%Switching Controllers
        [UavTeam,Airway,Node,Roundabout,TrafficCharacteristicsMatrix(fix(time*(1/Ts))+1,:)]=SwitchingController(UavTeam,AirwayNetwork,AirwayList,mode,...
            Airway,Node,Roundabout,Airport,Airport_num,Node_num,Roundabout_num,time);
        %%% calculate the average speed or other parameters (1 minite)
        if calculatenum>=calculate_interval*(1/Ts)
            [TrafficCharacteristics,calculatenum]=CalculateTrafficCharacteristics(Airway,Node,Roundabout,vmax);
        end
        if mod(time,dtTFC)==0
            [TFC,TFC_RF,Airway,calculatenum]=CalTFC(time,StateMatrix((((time-dtTFC)/Ts)+2):((time/Ts)+1),:),M,Ts,dtTFC,TFC,TFC_RF,Airway,Node,Roundabout);
            if plotactive==1
                %                 plotTFC(TFC)
            end
        end
        %%Re-routing
        if routingnum>=routing_interval*(1/Ts) && routingactive==1
            [UavTeam,routingnum]=Routing(UavTeam,TrafficCharacteristics,TFC_RF,AirwayList,AllPaths);
        end

        %%% real-time plot
%                 if plot==1 && plotnum>=plot_interval*(1/Ts)
        if ((plotactive==1) && (mod(time,plot_interval)==0))
            [tempplot,plotnum]=plotsnapshot(tempplot,UavTeam);
            figure(1)
            title(['$t=' num2str(time) '~[\mathrm{sec}] $'],'interpreter','latex','FontUnits','points','FontSize',12,'FontName','Times');
            F(time/plot_interval) = getframe(gcf) ;
        end
        %%%
    else
        if ((time~=0) && (plotactive==1) && (mod(time,plot_interval)==0))
            figure(1)
            title(['$t=' num2str(time) '~[\mathrm{sec}] $'],'interpreter','latex','FontUnits','points','FontSize',12,'FontName','Times');
            F(time/plot_interval) = getframe(gcf) ;
        end
    end
end

disp('Simulation has completed successfully!');
%% Saving Simulation Outputs
% Define output dir
SimOutputDirStr = ['.\Outputs\SimOutput_' datestr(now,'yyyymmdd_hhMMss') '\'];
if ~exist(SimOutputDirStr, 'dir')
    mkdir(SimOutputDirStr)
end
Filename_Trajectory = ['Workspace_M'  int2str(fix(M))];
save([SimOutputDirStr Filename_Trajectory],'-v7.3');
save([SimOutputDirStr 'UAVstate_M'  int2str(fix(M)) '.mat'],'StateMatrix');
save([SimOutputDirStr 'TFC_M'  int2str(fix(M)) '.mat'],'TFC');
save([SimOutputDirStr 'TFC_RF_M'  int2str(fix(M)) '.mat'],'TFC_RF');
save([SimOutputDirStr 'Conflictnum'  int2str(fix(M)) '.mat'],'ConflictsNum');
% plotTFC(TFC_RF)
% 
% figure(2)
print([SimOutputDirStr '\fig_Matrix_TFC_RF_Results'],'-dpng')
%%
% Video
if plotactive==1
writerObj = VideoWriter([SimOutputDirStr 'SimulationPlot' '_' datestr(now,'yyyymmdd_hhMMss')]);
writerObj.FrameRate = round(2*(30/plot_interval));
open(writerObj);
%--- write the frames to the video

for i=1:size(F,2)
    %--- convert the image to a frame
    frame = F(i) ;
    writeVideo(writerObj, frame);
end
close(writerObj); %--- close the writer object
end
% Others
ConflictsNum=sum(ConflictMatrix(:));
EndSimTime = now;
disp(['Sim Ended: Time - ' datestr(now) '. M=' num2str(M)])
% csvwrite('UAVstate.csv',StateMatrix);
% cell2csv('TrafficCharacteristics.csv',TrafficCharacteristicsMatrix);
%% ploting for routing policy
% airwayindex=12;
% x=0:1:20;
% y=[0,TFC.Airway(airwayindex).Outflow(2:2:end)];
% plot(x,y,'.-');
% z=[0,TFC.Airway(airwayindex).Accumulation(2:2:end)];
% plot(x,z,'.-');
% hold on
% obj=gca(figure(1));
% plotpiecewise(obj,inflow_settings(1).time,inflow_settings(1).value_init,inflow_settings(1).glowthrate);
% hold off
% sum(TFC.AirwaysTTT(:))
% end