function out=RouteLength(AirwayList,Route)
out=cell(3,size(Route,2));
for ii=1:size(Route,2)
    out{1,ii}=Route{1,ii};
    temp1=Route{1,ii};
    temp2=zeros(1,length(temp1)-1);
    for jj=1:length(temp1)-1
        ans1=find(temp1(jj)==AirwayList(:,1));
        ans2=find(temp1(jj+1)==AirwayList(:,2));
        index=intersect(ans1,ans2);
        temp2(jj)=AirwayList(index,4);
    end
    out{2,ii}=temp2;
    out{3,ii}=sum(temp2);
end