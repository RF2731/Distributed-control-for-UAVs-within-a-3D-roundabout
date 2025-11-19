function [UavTeam,Newaccumulation,Airway]=UAVinflow(time,inflow_settings,Airway,AirwayList,Airport,UavTeam,gain,accumulation,lanenum,vmax,vzmax,scenario,TFC)
Newaccumulation=accumulation;
for ii=1:length(Airport)
    if fix(time)==time && time ~=0
        for tt = inflow_settings(ii).totallanenum(time)+1:1:inflow_settings(ii).totallanenum(time+1)
            if tt ~=0
                [NewUAV,Newaccumulation,Airway]=createUAV(time,tt,ii,Airway,AirwayList,Airport,gain,1,accumulation,lanenum,vmax,vzmax,scenario,TFC);
                UavTeam.Uav(Newaccumulation)=NewUAV;
                
                accumulation= accumulation+1;
                if lanenum>1
                    for gg= 1:lanenum-1
                        [NewUAV,Newaccumulation,Airway]=createUAV(time,tt,ii,Airway,AirwayList,Airport,gain,gg+1,accumulation,lanenum,vmax,vzmax,scenario,TFC);
                        UavTeam.Uav(Newaccumulation)=NewUAV;
                        accumulation= accumulation+1;
                    end
                end
            end
        end
    end
end