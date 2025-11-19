function output=scenariomatrix(AdjacentMatrix,AirwayNetwork,Airway,Node,Roundabout,rh1,rh2,rh_z)
output0=zeros(1,3);
temp1=0;
for ii=1:length(Roundabout)
    temp1=temp1+length(Roundabout(ii).Highway);
end
output0(1,1)=length(Airway)+length(Node)+length(Roundabout)+temp1*4;
output0(1,2)=rh1+10;
output0(1,3)=rh_z/2;
output1=[];
tmd0=30;
tmd1=30;
tmd2=30;
tmd3=30;
tmd4=30;
rgb0=[0 0 160];
rgb1=[160 160 0];
rgb2=[0 160 0];
rgb3=[160 0 0];
rgb4=[0 0 160];
for ii=1:length(Airway)

    [V1,V2,V3,V4]=tunnel(AirwayNetwork(Airway(ii).StartNode,:)',AirwayNetwork(Airway(ii).EndNode,:)',rh1,rh2,rh_z);
    V1=V1+(V3-V2)/2;
    V4=V4+(V3-V2)/2;
    V2=V2+(V3-V2)/2;
    V1new=V1;
    V2new=V2;
    if sum(AdjacentMatrix(Airway(ii).StartNode,:))>1
        if sum(AdjacentMatrix(Airway(ii).StartNode,:))==2
            num=find(Airway(ii).StartNode==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1)==2));
            V1new=V1+(V2-V1)*Node(num).radius/norm(V2-V1);
        else
            num=find(Airway(ii).StartNode==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2));
            V1new=V1+(V2-V1)*Roundabout(num).changedis/norm(V2-V1);
        end
    end
    if sum(AdjacentMatrix(Airway(ii).EndNode,:))>1
        if sum(AdjacentMatrix(Airway(ii).EndNode,:))==2
            num=find(Airway(ii).EndNode==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1)==2));
            V1new=V2+(V1-V2)*Node(num).radius/norm(V2-V1);
        else
            num=find(Airway(ii).EndNode==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2));
            V2new=V2+(V1-V2)*Roundabout(num).changedis/norm(V1-V2);
        end
    end
    temp=[0 2 tmd0;rgb0;V1new';V2new'];
    output1=[output1;temp];
end
output2=[];
for ii=1:length(Node)
    temp=[];
end
output3=[];
for ii=1:length(Node)
    pt2=Node(ii).p2;
    or=Node(ii).Or;
    pt1=Node(ii).p1;
    angle=acos(mycos(pt1,or,pt2));
    tempmat=createarc(2,or,Node(ii).ri+rh1/2,0,pt1,angle,Node(ii).state,0);
    temp=[temp;1 size(tempmat,1) tmd4;rgb4;tempmat];
end
for ii=1:length(Roundabout)

    temp=[1 60 tmd1;rgb1;createarc(1,Roundabout(ii).pos,(Roundabout(ii).radius_i+Roundabout(ii).radius_o)/2,Roundabout(ii).StateChangeHeight*3)];
    for jj=1:length(Roundabout(ii).Highway)
        pt2=Roundabout(ii).pos+(Roundabout(ii).Highway(jj).om-Roundabout(ii).pos)*((Roundabout(ii).radius_i+Roundabout(ii).radius_o)/2)/norm(Roundabout(ii).Highway(jj).om-Roundabout(ii).pos);
        or=Roundabout(ii).Highway(jj).om;
        pt1=Roundabout(ii).Highway(jj).p;
        angle=acos(mycos(pt1,or,pt2));
        tempmat=createarc(2,or,Roundabout(ii).ra+rh1/2,Roundabout(ii).StateChangeHeight,pt1,angle,1,0);
        temp=[temp;1 size(tempmat,1) tmd2;rgb2;tempmat];
        tempmat2=createarc(2,Roundabout(ii).pos,(Roundabout(ii).radius_i+Roundabout(ii).radius_o)/2,Roundabout(ii).StateChangeHeight*3,pt2,Roundabout(ii).buffer,-1,1);
        temp=[temp;1 size(tempmat2,1) tmd3;rgb3;tempmat2];
    end
    for jj=1:length(Roundabout(ii).Highway)
        pt2=Roundabout(ii).pos+(Roundabout(ii).Highway(jj).od-Roundabout(ii).pos)*((Roundabout(ii).radius_i+Roundabout(ii).radius_o)/2)/norm(Roundabout(ii).Highway(jj).od-Roundabout(ii).pos);
        or=Roundabout(ii).Highway(jj).od;
        pt1=Roundabout(ii).Highway(jj).p;
        angle=acos(mycos(pt1,or,pt2));
        tempmat1=createarc(2,or,Roundabout(ii).ra+rh1/2,Roundabout(ii).StateChangeHeight,pt1,angle,-1,0);
        temp=[temp;1 size(tempmat1,1) tmd2;rgb2;tempmat1];
        tempmat2=createarc(2,Roundabout(ii).pos,(Roundabout(ii).radius_i+Roundabout(ii).radius_o)/2,Roundabout(ii).StateChangeHeight*3,pt2,Roundabout(ii).buffer,1,1);
        temp=[temp;1 size(tempmat2,1) tmd3;rgb3;tempmat2];
    end
    output3=[output3;temp];
end
output=[output0;output1;output2;output3];
