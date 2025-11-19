function [NewUavTeam,u]= VTcontroller_landing(i,UavTeam)

global AirwayNetwork
NewUavTeam=UavTeam;
Pcur  =  NewUavTeam.Uav(i).State.CurrentPos;
Vcur  =  NewUavTeam.Uav(i).State.Velocity;
ksi = Pcur + Vcur / NewUavTeam.Uav(i).Modularity.gain;
rs = NewUavTeam.Uav(i).Modularity.rs;
ra = NewUavTeam.Uav(i).Modularity.ra;
vmax = NewUavTeam.Uav(i).Modularity.vmax;
NewUavTeam.Uav(i).State.ElementType=4;
% Velocity to circumventing
% Vu = [0;0];
k1 = 1;
Pdes = [[AirwayNetwork(NewUavTeam.Uav(i).State.CurrentWaypoint,(1:2))]';0];
eu = Pdes - ksi;
Vu = mysat(k1*eu,vmax);
u = mysat(Vu,vmax);

u=[0 ;0; 0];