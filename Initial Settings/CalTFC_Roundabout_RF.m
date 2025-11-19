function [FD,NewRoundabout] = CalTFC_Roundabout_RF(time,FD,StateMatrix,NumofSection,SectionType,M,Ts,dtTFC,Roundabout)
% Split StateMatrix
tk0 = 1; %(((ii-1)*(dtMFD/dtSim))+2);
tk1 = dtTFC/Ts; %((ii*(dtMFD/dtSim))+1);
NewRoundabout=Roundabout;
N = Roundabout.PeriodNum;%到这里主要是算出来uavteam大小，这段时间里

Acc = Roundabout.accumulation;
%% Check each UAV TT TD Nexit
%% Calculate travel time in this time window
TTT = Roundabout.PeriodTTT;
% StdTTT = std(TravelTimeUAV);
% MeanTTT = mean(TravelTimeUAV);
ATT = TTT/max(N,1);

%% Calculate the travel distance in this time window
TTD = Roundabout.PeriodTTD;
% StdTTD = std(TravelDistanceUAV);
% MeanTTD = mean(TravelDistanceUAV);
ATD = TTD/max(N,1);

%% Calculate the average speed in this time window
if TTT
    U = TTD / TTT;
    if (U>8)
        warning('CalTFC_Roundabout: error in average velocity, bigger than 8')
    end
else
    U = 0;
end
%% Calculate the outflow in this time window
Nexit = Roundabout.PeriodNexit;
G = Nexit/dtTFC;
%% Calculate the density in this time window
K = TTT/(dtTFC*(Roundabout.volume));
%% Calculate the flow in this time window
Q = TTD/(dtTFC*(Roundabout.volume));
%% Add Final Values to FD Object
FD.Accumulation(time/dtTFC) = Acc ;% Accumulation
FD.Outflow(time/dtTFC) = G ; % Outflow
FD.AverageSpeed(time/dtTFC) = U ; % Average Speed
FD.Flow(time/dtTFC) = Q; % Flow
FD.Density(time/dtTFC) = K; % Density
FD.TTT(time/dtTFC) = TTT ;
% FD. % Average Trip Length
% FD. % Total Travel Time
% FD. % Total Travel Distance
NewRoundabout.PeriodTTD=0;
NewRoundabout.PeriodTTT=0;
NewRoundabout.PeriodNum=0;
NewRoundabout.PeriodNexit=0;
% clearvars -except FD
end