function [] = plotTFCtemp(TFC)
%PLOTTFC Summary of this function goes here
%   Detailed explanation goes here
% figure(2)
hold on;
X3= [mean(TFC.AirwaysDensity,2), mean(TFC.AirwaysFlow,2), mean(TFC.AirwaysAverageSpeed,2), mean(TFC.AirwaysOutflow,2),mean(TFC.AirwaysAccumulation,2)];
[S,ax,BigAx,H,HAx] = plotmatrix(X);
ax(1,1).YLabel.String='K';
ax(2,1).YLabel.String='Q';
ax(3,1).YLabel.String='U';
ax(4,1).YLabel.String='G';
ax(5,1).YLabel.String='N';
ax(5,1).XLabel.String='K';
ax(5,2).XLabel.String='Q';
ax(5,3).XLabel.String='U';
ax(5,4).XLabel.String='G';
ax(5,5).XLabel.String='N';
set(gcf, 'Position',[10 50 1250 550]);
set(findall(gcf,'type','axes'),'FontUnits','points','ticklabelinterpreter','latex','FontSize',12,'FontName','Arial')
set(gcf,'Color','White');
set(gca,'Color','White');
end
Y3_8= [mean(TFC_RF.RoundaboutsDensity,2), mean(TFC_RF.RoundaboutsFlow,2), mean(TFC_RF.RoundaboutsAverageSpeed,2), mean(TFC_RF.RoundaboutsOutflow,2),mean(TFC_RF.RoundaboutsAccumulation,2)];
[S,ax,BigAx,H,HAx] = plotmatrix(Y);
ax(1,1).YLabel.String='K';
ax(2,1).YLabel.String='Q';
ax(3,1).YLabel.String='U';
ax(4,1).YLabel.String='G';
ax(5,1).YLabel.String='N';
ax(5,1).XLabel.String='K';
ax(5,2).XLabel.String='Q';
ax(5,3).XLabel.String='U';
ax(5,4).XLabel.String='G';
ax(5,5).XLabel.String='N';
set(gcf, 'Position',[10 50 1250 550]);
set(findall(gcf,'type','axes'),'FontUnits','points','ticklabelinterpreter','latex','FontSize',12,'FontName','Arial')
set(gcf,'Color','White');
set(gca,'Color','White');
end
hold on
plot(Y1_1(:,5),Y1_1(:,4),'.-');
plot(Y1_2(:,5),Y1_2(:,4),'.-');
plot(Y1_3(:,5),Y1_3(:,4),'.-');
plot(Y1_4(:,5),Y1_4(:,4),'.-');
plot(Y1_5(:,5),Y1_5(:,4),'.-');
plot(Y1_6(:,5),Y1_6(:,4),'.-');
plot(Y1_7(:,5),Y1_7(:,4),'.-');
plot(Y1_8(:,5),Y1_8(:,4),'.-');
plot(Y1_9(:,5),Y1_9(:,4),'.-');
plot(Y1_10(:,5),Y1_10(:,4),'.-');
legend('0.1 veh/s','0.2 veh/s','0.3 veh/s','0.4 veh/s','0.5 veh/s','0.6 veh/s','0.7 veh/s','0.8 veh/s','0.9 veh/s','1 veh/s');
hold off

hold on
plot(Y1_1(:,5),Y1_1(:,4),'^-','color',[0 0 0]);
plot(Y1_2(:,5),Y1_2(:,4),'^-','color',[0 0 1]);
plot(Y1_3(:,5),Y1_3(:,4),'^-','color',[0 1 0]);
plot(Y1_4(:,5),Y1_4(:,4),'^-','color',[0 1 1]);
plot(Y1_5(:,5),Y1_5(:,4),'^-','color',[1 0 0]);
plot(Y1_6(:,5),Y1_6(:,4),'^-','color',[1 0 1]);
% plot(Y1_7(:,5),Y1_7(:,4),'+-','color',[1 1 0]);
% plot(Y1_8(:,5),Y1_8(:,4),'+-','color',[1 0.5 0]);
% plot(Y1_9(:,5),Y1_9(:,4),'+-','color',[0.5 0.5 0.5]);
% plot(Y1_10(:,5),Y1_10(:,4),'+-','color',[0.5 0.25 0]);
% legend('0.1 veh/s','0.2 veh/s','0.3 veh/s','0.4 veh/s','0.5 veh/s','0.6 veh/s');

plot(Y2_1(:,5),Y2_1(:,4),'o-','color',[0 0 0]);
plot(Y2_2(:,5),Y2_2(:,4),'o-','color',[0 0 1]);
plot(Y2_3(:,5),Y2_3(:,4),'o-','color',[0 1 0]);
plot(Y2_4(:,5),Y2_4(:,4),'o-','color',[0 1 1]);
plot(Y2_5(:,5),Y2_5(:,4),'o-','color',[1 0 0]);
plot(Y2_6(:,5),Y2_6(:,4),'o-','color',[1 0 1]);

% plot(Y3_1(:,5),Y3_1(:,4),'*-','color',[0 0 0]);
% plot(Y3_2(:,5),Y3_2(:,4),'*-','color',[0 0 1]);
% plot(Y3_3(:,5),Y3_3(:,4),'*-','color',[0 1 0]);
% plot(Y3_4(:,5),Y3_4(:,4),'*-','color',[0 1 1]);
% plot(Y3_5(:,5),Y3_5(:,4),'*-','color',[1 0 0]);
% plot(Y3_6(:,5),Y3_6(:,4),'*-','color',[1 0 1]);
hold off

%%

hold on
plot(Y1_1(:,5),Y1_1(:,4),'^-','color',[0 0 0]);
plot(Y1_2(:,5),Y1_2(:,3),'^-','color',[0 0 1]);
plot(Y1_3(:,5),Y1_3(:,3),'^-','color',[0 1 0]);
plot(Y1_4(:,5),Y1_4(:,3),'^-','color',[0 1 1]);
plot(Y1_5(:,5),Y1_5(:,3),'^-','color',[1 0 0]);
plot(Y1_6(:,5),Y1_6(:,3),'^-','color',[1 0 1]);
plot(Y1_7(:,5),Y1_7(:,3),'^-','color',[1 1 0]);
plot(Y1_8(:,5),Y1_8(:,3),'^-','color',[1 0.5 0]);
% plot(Y1_1(:,5),Y1_1(:,4),'^','color',[0 0 0]);
% plot(Y1_2(:,5),Y1_2(:,4),'o','color',[0 0 0]);
% plot(Y1_3(:,5),Y1_3(:,4),'*','color',[0 0 0]);
% plot(Y1_9(:,5),Y1_9(:,4),'+-','color',[0.5 0.5 0.5]);
% plot(Y1_10(:,5),Y1_10(:,4),'+-','color',[0.5 0.25 0]);
% legend('0.1 veh/s','0.2 veh/s','0.3 veh/s','0.4 veh/s','0.5 veh/s','0.6 veh/s','0.7 veh/s','0.8 veh/s','3D roundabout','Unstructured');

% plot(Y2_1(:,5),Y2_1(:,3),'o-','color',[0 0 0]);
% plot(Y2_2(:,5),Y2_2(:,3),'o-','color',[0 0 1]);
% plot(Y2_3(:,5),Y2_3(:,3),'o-','color',[0 1 0]);
% plot(Y2_4(:,5),Y2_4(:,3),'o-','color',[0 1 1]);
% plot(Y2_5(:,5),Y2_5(:,3),'o-','color',[1 0 0]);
% plot(Y2_6(:,5),Y2_6(:,3),'o-','color',[1 0 1]);

plot(Y3_1(:,5),Y3_1(:,3),'*-','color',[0 0 0]);
plot(Y3_2(:,5),Y3_2(:,3),'*-','color',[0 0 1]);
plot(Y3_3(:,5),Y3_3(:,3),'*-','color',[0 1 0]);
plot(Y3_4(:,5),Y3_4(:,3),'*-','color',[0 1 1]);
plot(Y3_5(:,5),Y3_5(:,3),'*-','color',[1 0 0]);
plot(Y3_6(:,5),Y3_6(:,3),'*-','color',[1 0 1]);
plot(Y3_7(:,5),Y3_7(:,3),'*-','color',[1 1 0]);
plot(Y3_8(:,5),Y3_8(:,3),'*-','color',[1 0.5 0]);
hold off
%%
hold on
plot(Y1_1(:,5),Y1_1(:,4),'^','color',[0 0 0]);
plot(Y1_2(:,5),Y1_2(:,4),'o','color',[0 0 0]);
plot(Y1_3(:,5),Y1_3(:,4),'*','color',[0 0 0]);

legend('3D roundabout','2D roundabout','Unstructured');
hold off
Y3_1=Y1;
Y3_2=Y2;
Y3_3=Y3;
Y3_4=Y4;
Y3_5=Y5;
Y3_6=Y6;

Y2_1=Y1;
Y2_2=Y2;
Y2_3=Y3;
Y2_4=Y4;
Y2_5=Y5;
Y2_6=Y6;

Y1_1=Y1;
Y1_2=Y2;
Y1_3=Y3;
Y1_4=Y4;
Y1_5=Y5;
Y1_6=Y6;
Y1_7=Y7;
Y1_8=Y8;
Y1_9=Y9;
Y1_10=Y10;
save("figs.mat", "Y1_1","Y1_2","Y1_3","Y1_4","Y1_5","Y1_6","Y1_7","Y1_8","Y1_9","Y1_10",...
    "Y2_1","Y2_2","Y2_3","Y2_4","Y2_5","Y2_6",...
    "Y3_1","Y3_2","Y3_3","Y3_4","Y3_5","Y3_6");