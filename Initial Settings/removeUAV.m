function [NewUavTeam,ArrivedUavTeam,accumulation] = removeUAV(UavTeam,ArriveNum,ArrivedUavTeam,accumulation)
NewUavTeam=UavTeam;
for kk=1:length(ArriveNum)
    ArrivedUavTeam.Uav(length(ArrivedUavTeam)+1)=NewUavTeam.Uav(ArriveNum(end+1-kk));
    NewUavTeam.Uav(ArriveNum(end+1-kk))=[];
end
accumulation=accumulation-length(ArriveNum);
