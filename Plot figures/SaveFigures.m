function [outputArg1,outputArg2] = SaveFigures(DIRstr,FigIndex,FigNames)
%UNTITLED3 Summary of this function goes here
% Detailed explanation goes here
if ~exist(DIRstr, 'dir')
    mkdir(DIRstr)
end
%savefig(FigIndex,[DIRstr '\fig_BLSim' int2str(FigIndex(1)) '-' int2str(FigIndex(end)) '.fig'])
for ii=1:1:length(FigIndex)
    figure(FigIndex(ii))
    print([DIRstr '\fig_BLSim_' FigNames(ii,:)],'-dpng')
    %print([DIRstr '\fig_BLSim_' FigNames(ii,:)],'-depsc')
    %cleanfigure()
    %matlab2tikz([DIRstr '\fig_BLSim_' FigNames(ii,:) '.tex']);
end
%winopen(DIRstr);
end

