function [ ] = ArrangeFigure(FirstPlot,Ftitle,Fylabel,Fxlabel,Flegend,FS,Fylim,Fxlim)
%% Main
Fsize = 20;
LineSize = 2;
%% Labels
hold on
xlabel(Fxlabel)
ylabel(Fylabel)
% title(Ftitle,'FontUnits','points','FontSize',Fsize,'FontName','Times','fontWeight','bold')
%% Grid
grid
grid on
grid minor
%% Figure size
    offest = 50;
    screen_size = get(0, 'ScreenSize');
if(FS==1)
    screen_size = [offest offest 1.2*screen_size(4)-offest 0.9*screen_size(4)-offest];
elseif(FS==2)
    screen_size = [offest offest 0.9*screen_size(4)-offest 0.9*screen_size(4)-offest];
else
    screen_size = [offest offest 1.8*screen_size(4)-offest 0.9*screen_size(4)-offest];
end
%% Ticks
% xticks([-1000:200:1000])
% yticks([-1000:200:1000])
%% Axis Limit
if(sum(Fylim))
    ylim(Fylim)
else
    ylim auto
end
if(sum(Fxlim))
    xlim(Fxlim)
else
    xlim auto
end
% axis square
%% Latex Mode
% set(findall(gcf,'type','text'),'FontUnits','points','interpreter','latex','FontSize',Fsize,'FontName','Times')
set(findall(gcf,'type','axes'),'FontUnits','points','ticklabelinterpreter','latex','FontSize',Fsize,'FontName','Times')
set(findall(gcf,'type','legend'),'FontUnits','points','interpreter','latex','FontSize',Fsize,'FontName','Times')
set(findall(gcf,'type','line'),'LineWidth',LineSize)
set(findall(gcf,'type','line'),'MarkerSize',10)
set(findall(gcf,'type','line'),'MarkerFaceColor','auto')
set(gcf, 'Position',[screen_size]);
box off
%% Set Background Color
set(gcf,'Color','White');
set(gca,'Color','White');

%% Legend Location
legend
% legend('Location','eastoutside')
%% Analytic Mode
% legend off
% grid off
% xticks([])
% yticks([])
end

