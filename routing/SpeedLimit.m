function [NewUavTeam]=SpeedLimit(UavTeam)
NewUavTeam=UavTeam;
for ii=1:length(NewUavTeam.Uav)
    if 0 %% to be designed
       UavTeam.Uav(ii).SpeedLimit.SpeedLimitActive=1;
       UavTeam.Uav(ii).SpeedLimit.vmaxLimited=0;
       UavTeam.Uav(ii).SpeedLimit.vzmaxLimited=0;
    end
end
