function NewPath=PreRouting(Path,TFC,AirwayList,routelist,vmax)
NewPath=Path;
if size(routelist,2)>1
    arrivetime=zeros(size(routelist,2),1);
    for jj=1:size(routelist,2)
        for kk=1:length(routelist{1,jj})-1
            temp1=find(routelist{1,jj}(kk)==AirwayList(:,1));
            temp2=find(routelist{1,jj}(kk+1)==AirwayList(:,2));
            index=intersect(temp1,temp2);
            if ~isempty(TFC.Airway(index).AverageSpeed) && TFC.Airway(index).AverageSpeed(end)~=0
                vel=min(vmax,TFC.Airway(index).AverageSpeed(end));
            else
                vel=vmax;
            end
            arrivetime(jj)=arrivetime(jj)+routelist{2,jj}(kk)/vel;
        end
    end
    [~,min1]=min(arrivetime);
    [~,min2]=min(cell2mat(routelist(3,:)));
    if min1~=min2 
        
        NewRoute=routelist{1,min1};
        NewRoute=NewRoute(2:end);
        PreRoute=NewPath(1);
        NewPath=cat(2,PreRoute,NewRoute);
    end
end
