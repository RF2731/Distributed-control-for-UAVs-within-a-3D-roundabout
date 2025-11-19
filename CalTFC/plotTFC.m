function [] = plotTFC(TFC)
%PLOTTFC Summary of this function goes here
%   Detailed explanation goes here
figure(2)
hold on;
X = [mean(TFC.AirwaysDensity,2), mean(TFC.AirwaysFlow,2), mean(TFC.AirwaysAverageSpeed,2), mean(TFC.AirwaysOutflow,2),mean(TFC.AirwaysAccumulation,2)];
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
figure(3)
Y = [mean(TFC.RoundaboutsDensity,2), mean(TFC.RoundaboutsFlow,2), mean(TFC.RoundaboutsAverageSpeed,2), mean(TFC.RoundaboutsOutflow,2),mean(TFC.RoundaboutsAccumulation,2)];
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
% plot(X(:,5),X(:,3));
% scatter(X(:,5),X(:,3));
% drawArrow(X(:,5)',X(:,3)','r','b',8,1);
% quiver(X(:,5),X(:,3),[diff(X(:,5));0],[diff(X(:,3));0],2);