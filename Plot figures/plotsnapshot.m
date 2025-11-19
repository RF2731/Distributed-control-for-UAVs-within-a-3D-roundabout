function [tempplot,plotnum]=plotsnapshot(tempplot,UavTeam)
hold on
for ii=length(tempplot):-1:1
    delete(tempplot(ii));
end
tempplot=[];
for ii = 1:length(UavTeam.Uav)
    o2 = UavTeam.Uav(ii).State.CurrentPos+1/UavTeam.Uav(ii).Modularity.gain*UavTeam.Uav(ii).State.Velocity;
    if UavTeam.Uav(ii).Routing.RoutingActive==0
    eval(['fs',num2str(ii),'=plot3(o2(1),o2(2),o2(3),''k-o'',''MarkerFaceColor'',''k'',''MarkerSize'',2);']);
    else
        eval(['fs',num2str(ii),'=plot3(o2(1),o2(2),o2(3),''k-o'',''MarkerFaceColor'',''r'',''MarkerSize'',2);']);
    end
    eval(['tempplot=[tempplot fs',num2str(ii),'];'])
    eval(['clear fs',num2str(ii)])
end
plotnum=0;
pause(0.1);
% plotsphere()