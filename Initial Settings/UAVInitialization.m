function UavTeam = UAVInitialization(M,UAVnum)
global rv vm Ts
global AirwayNetwork AdjacentMatrix lanenum
UavTeam.AvailableNumMax  = M;
if M==0
    error('Please check the inflow settings!')
end
vm = 0;
rv = 0;
% L=UavTeam.gain;
% % r_initial = 50;%初始地点在此半径内随机生成
% temp=sum(UAVnum);
% for ll=1:lanenum
%     totalnum = 0;
% 
%     for ii = 1:length(UAVnum)
% 
%         for k = 1: UAVnum(ii)
%             UavTeam.Uav(totalnum+k+(ll-1)*temp)=createUAV(totalnum+k+(ll-1)*temp,ii,L,ll);
%         end
%         totalnum = totalnum + UAVnum(ii);
%     end
% end