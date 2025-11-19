function [] = PlotMFDElementsFigs(obj1,obj2,obj3,obj4,obj5,StrCase)
%% Load MAT
load(['.\Outputs\' StrCase '.mat'])

jjjj=1;
NN = size(MFD.inflowvec,2);
C = linspecer(22);
%C = C(1:round(20/(NN+3)):end,:);
SaveFigMFDPlot = 1;
DIRstr = ['.\figures\figBLSim_' StrCase '_' datestr(now,'yyyymmdd_hhMMss')];
for ff=1:1:NN
    PlotType = '.-';
    %% Timeseries

    plot(obj1,MFD.US(ff,:),PlotType,'color',C(jjjj,:), 'DisplayName',[  num2str(MFD.inflowvec(ff)) ])
    legend(obj1,'Location','eastoutside')
%     ArrangeFigure(0,'','','','',0,0,0)
%     title([TitleStr],'interpreter','latex')
hold(obj1,"on")

    plot(obj2,MFD.AccS(ff,:),PlotType,'color',C(jjjj,:), 'DisplayName',[  num2str(MFD.inflowvec(ff)) ])
    legend(obj2,'Location','eastoutside')
%     ArrangeFigure(0,'','','','',0,0,0)
%     title([TitleStr],'interpreter','latex')
hold(obj2,"on")

    plot(obj3,MFD.GS(ff,:),PlotType,'color',C(jjjj,:), 'DisplayName',[  num2str(MFD.inflowvec(ff)) ])
    legend(obj3,'Location','eastoutside')
%     ArrangeFigure(0,'','','','',0,0,0)
%     title([TitleStr],'interpreter','latex')
hold(obj3,"on")
    %%---------------------------------------------------------------------------------------------------------------------------------------------

    plot(obj4,MFD.AccS(ff,:),MFD.US(ff,:),PlotType,'color',C(jjjj,:), 'DisplayName',[  num2str(MFD.inflowvec(ff))])
    legend(obj4,'Location','eastoutside')
    hold(obj4,"on")
%     ArrangeFigure(0,'','Speed U [m/s]','Accumulation N [aircraft]','',1,0,0)
%     title([TitleStr],'interpreter','latex')


    plot(obj5,MFD.AccS(ff,:),MFD.GS(ff,:),PlotType,'color',C(jjjj,:), 'DisplayName',[  num2str(MFD.inflowvec(ff))])
    legend(obj5,'Location','eastoutside')
    hold(obj5,"on")
%     ArrangeFigure(0,'','Outflow G [aircraft /s]','Accumulation N [aircraft]','',1,0,0)
%     title([TitleStr],'interpreter','latex')

    jjjj=jjjj+1;
end
%% Save Figure and Print
% SaveFigMFDPlot=1;
% if(SaveFigMFDPlot==1)
%     FigIndex = [1,4,5,15,16];
%     FigNames = [ 'Ut';
%         'Nt';
%         'Gt';
%         'Un';
%         'Gn';
%         ];
%     SaveFigures(DIRstr,FigIndex,FigNames)
%     winopen(DIRstr);
%     close all; clear all; clc;
% end
end