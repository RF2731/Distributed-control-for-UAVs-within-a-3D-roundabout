function [FD] = CalTFC_Airway(time,FD,StateMatrix,NumofSection,SectionType,M,dtSim,dtTFC,Airway)
% Split StateMatrix
tk0 = 1; %(((ii-1)*(dtMFD/dtSim))+2);
tk1 = dtTFC/dtSim; %((ii*(dtMFD/dtSim))+1);
UAVTrajectories = StateMatrix(:,2:3*M+1);
UAVstatus = StateMatrix(:,3*M+2:4*M+1);
UAVstatus = (UAVstatus-mod(UAVstatus,100))./100;%ElementNum
UAVsection = StateMatrix(:,3*M+2:4*M+1);
UAVsection = mod(UAVsection,100);
UAVAirwayStatus = StateMatrix(:,3*M+2:4*M+1);
%% Get at each time step which aircrafts were in the airspace
FlyingIndex = double(UAVAirwayStatus==(SectionType*100+NumofSection));
% UAVIndex = eye(M).*(1:1:M);
% UAVFlying = FlyingIndex*UAVIndex;
UAVFlying=FlyingIndex.*(1:1:M);
%% Id the aircraft that fly in this time window
UAVFlyingUnique = unique(UAVFlying)';
UAVFlyingUnique(UAVFlyingUnique==0)=[];
N = size(UAVFlyingUnique,2);%到这里主要是算出来uavteam大小，这段时间里
%% Calculate the accumulation at each dtMFD and in the time window
UAVFlyingTk1 = UAVFlying(end,:);
UAVFlyingTk1Unique = unique(UAVFlyingTk1);
UAVFlyingTk1Unique(UAVFlyingTk1Unique==0)=[];
Acc = size(UAVFlyingTk1Unique,2);
%% Check each UAV TT TD Nexit
NexitUAV = zeros(1,N);
TripLengthUAV = zeros(1,N);
TravelDistanceUAV = zeros(1,N);
TravelTimeUAV = zeros(1,N);
UAVEnterT = zeros(1,N);
UAVExitT = zeros(1,N);
for mm = 1:N
    %% Get the Departure and Arrival time of each aircraft
    for ttt=tk0:tk1
        if (FlyingIndex(ttt,UAVFlyingUnique(mm))==1)
            UAVEnterT(mm) = ttt;
            break;
        end
    end
    if UAVEnterT(mm)>0
        for ttt=tk0:tk1
            if ((ttt>=UAVEnterT(mm))&&(FlyingIndex(ttt,UAVFlyingUnique(mm))~=1))
                UAVExitT(mm) = ttt-1;
                break;
            end
            if ((ttt==tk1) && (FlyingIndex(ttt,UAVFlyingUnique(mm))==1))
                UAVExitT(mm) = ttt;
                break;
            end
        end
    end
    %% Calculate the travel time of aircraft in this time window
    TravelTimeUAV(mm) = (UAVExitT(mm) - UAVEnterT(mm) + 1)*dtSim ;
    if(TravelTimeUAV(mm)>dtTFC) || (TravelTimeUAV(mm)<0)||(isnan(TravelTimeUAV(mm)))
        warning('CalTFC_Airway: error in TravelTimeUAV')
    end
    %% Calculate the distance travel of aircraft in this time window
    UAVTrajectoriesFlying = UAVTrajectories(UAVEnterT(mm):(UAVExitT(mm)),3*UAVFlyingUnique(mm)-2:3*UAVFlyingUnique(mm));
    if (size(UAVTrajectoriesFlying,1) ~= 1)
        TravelDistanceUAV(mm) = norm(sum(diff(UAVTrajectoriesFlying)));
        if(TravelDistanceUAV(mm)>2*Airway.Dx)||(TravelDistanceUAV(mm)<0)||(isnan(TravelDistanceUAV(mm)))
            warning('CalTFC_Airway: error in TravelDistanceUAV')
        end
    end
    %% Calculate Nexit - the number of aircraft that arive to the Des
    if (size(UAVTrajectoriesFlying,1) ~= 1)&&(UAVExitT(mm)<tk1)
        NexitUAV(mm) = 1;
    end
%     %% Calculate trip length
%     if (NexitUAV(mm)==1)
%         TripLengthUAV(mm) = TravelDistanceUAV(mm);
%         if(TripLengthUAV(mm)>2*Airway.Dx)
%             warning('CalTFC_Airway: error in TripLengthUAV')
%         end
%     end
end
clear mm
%% Calculate travel time in this time window
TTT = sum(TravelTimeUAV);
StdTTT = std(TravelTimeUAV);
MeanTTT = mean(TravelTimeUAV);
ATT = TTT/max(N,1);

%% Calculate the travel distance in this time window
TTD = sum(TravelDistanceUAV);
StdTTD = std(TravelDistanceUAV);
MeanTTD = mean(TravelDistanceUAV);
ATD = TTD/max(N,1);
%% Calculate the average velocity of aircraft in this time window
AverageVelocityUAV = TravelDistanceUAV./TravelTimeUAV;
if (max(AverageVelocityUAV)>8)
        warning('CalTFC_Airway: error in average velocity, bigger than 8')
end
TAS = sum(AverageVelocityUAV);
StdAS = std(AverageVelocityUAV);
MeanAS = mean(AverageVelocityUAV);
%% Calculate the average speed in this time window
if TTT
    U = TTD / TTT;
    if (U>8)
        warning('CalTFC_Airway: error in average velocity, bigger than 8')
    end
else
    U = 0;
end
%% Calculate the outflow in this time window
Nexit = sum(NexitUAV);
G = Nexit/dtTFC;
%% Calculate the density in this time window
K = TTT/(dtTFC*(Airway.volume));
%% Calculate the flow in this time window
Q = TTD/(dtTFC*(Airway.volume));
% %% Calculate the trip length in this time window
% TTL = sum(TripLengthUAV);
% StdTTL = std(TripLengthUAV);
% MeanTTL = mean(TripLengthUAV);
% if Nexit
%     ATL = TTL/Nexit;
% else
%     ATL = 0;
% end
% if(ATL>2*Airway.Dx)
%     warning('CalTFC_Airway: error in ATL')
% end
%% Add Final Values to FD Object
FD.Accumulation(time/dtTFC) = Acc ;% Accumulation
FD.Outflow(time/dtTFC) = G ; % Outflow
FD.AverageSpeed(time/dtTFC) = U ; % Average Speed
FD.Flow(time/dtTFC) = Q; % Flow
FD.Density(time/dtTFC) = K; % Density
FD.TTT(time/dtTFC) = TTT;
% FD. % Average Trip Length
% FD. % Total Travel Time
% FD. % Total Travel Distance
clearvars -except FD
end