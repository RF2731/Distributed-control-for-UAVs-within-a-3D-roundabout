function [AirwayNetwork,AdjacentMatrix,Airport,Node,Roundabout,AllPaths,AirwayList,Airway,Airport_num,Node_num,Roundabout_num] = Initial_NetworkSettings(lanenum,vmax,laneiso,lanewidth,rh1,rh2,rh_z,r_airport,min_turn_radius,height,R_ChangeHeight,scenario)
switch scenario

    case 2
        point(1,:) = [-100 -100*1.732 height];
        point(2,:) = [-100 100*1.732 height];
        point(3,:) = [200 0 height];
        point(4,:) = [0 0 height];

        Adjacent(1,:) = [0 0 0 1];
        Adjacent(2,:) = [0 0 0 1];
        Adjacent(3,:) = [0 0 0 1];
        Adjacent(4,:) = [1 1 1 0];
        %%%%%%%% only one intersection to test the number of conflicts under
        %%%%%%%% different scenarios.


end
%%%%%%%% whole grid traffic network.

AirwayNetwork = [];
for ii=1:size(point,1)
    AirwayNetwork = [AirwayNetwork;point(ii,:)];
end

%56zhijian
AdjacentMatrix = [];
for ii=1:size(Adjacent,1)
    AdjacentMatrix = [AdjacentMatrix;Adjacent(ii,:)];
end
Airport=[];
Node=[];
Roundabout=[];
Airport_num=find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 1);
Node_num=find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 2);
Roundabout_num=find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) > 2);
for ii = 1: length(Airport_num)
    Airport(ii).num=Airport_num(ii);
    Airport(ii).pos=AirwayNetwork(Airport(ii).num,:)';
    Airport(ii).radius=r_airport;
end
for ii = 1: length(Node_num)
    for jj=1:2
        Node(2*(ii-1)+jj).num=Node_num(ii);
        Node(2*(ii-1)+jj).pos=AirwayNetwork(Node(2*(ii-1)+jj).num,:)';
        temp=find(AdjacentMatrix(Node(2*(ii-1)+jj).num,:)==1);
        %     Node(ii).radius=sqrt((tan(acos(mycos(AirwayNetwork(temp(1),:),AirwayNetwork(Node(ii).num,:),AirwayNetwork(temp(2),:)))/2)*min_turn_radius)^2+(rh1+rh2/2)^2);
        Node(2*(ii-1)+jj).radius=((min_turn_radius+rh1+rh2/2)/tan(acos(mycos(AirwayNetwork(temp(1),:),AirwayNetwork(Node(2*(ii-1)+jj).num,:),AirwayNetwork(temp(2),:)))/2));
        normv1=(AirwayNetwork(temp(1),:)-AirwayNetwork(Node(2*(ii-1)+jj).num,:))'/norm((AirwayNetwork(temp(1),:)-AirwayNetwork(Node(2*(ii-1)+jj).num,:)));
        normv2=(AirwayNetwork(temp(2),:)-AirwayNetwork(Node(2*(ii-1)+jj).num,:))'/norm((AirwayNetwork(temp(2),:)-AirwayNetwork(Node(2*(ii-1)+jj).num,:)));
        Node(2*(ii-1)+jj).p1=AirwayNetwork(Node(2*(ii-1)+jj).num,:)'+normv1*Node(2*(ii-1)+jj).radius;
        Node(2*(ii-1)+jj).p2=AirwayNetwork(Node(2*(ii-1)+jj).num,:)'+normv2*Node(2*(ii-1)+jj).radius;
        if jj==1
            Node(2*(ii-1)+jj).p11=Node(2*(ii-1)+jj).p1+[0 1 0;-1 0 0;0 0 0]*normv1*(-rh2/2);%right
            Node(2*(ii-1)+jj).p12=Node(2*(ii-1)+jj).p1+[0 1 0;-1 0 0;0 0 0]*normv1*(-rh1-rh2/2);
            Node(2*(ii-1)+jj).p21=Node(2*(ii-1)+jj).p2+[0 1 0;-1 0 0;0 0 0]*normv2*rh2/2;
            Node(2*(ii-1)+jj).p22=Node(2*(ii-1)+jj).p2+[0 1 0;-1 0 0;0 0 0]*normv2*(rh1+rh2/2);

        else
            Node(2*(ii-1)+jj).p11=Node(2*(ii-1)+jj).p1+[0 1 0;-1 0 0;0 0 0]*normv1*rh2/2;%left
            Node(2*(ii-1)+jj).p12=Node(2*(ii-1)+jj).p1+[0 1 0;-1 0 0;0 0 0]*normv1*(rh1+rh2/2);
            Node(2*(ii-1)+jj).p21=Node(2*(ii-1)+jj).p2+[0 1 0;-1 0 0;0 0 0]*normv2*(-rh2/2);
            Node(2*(ii-1)+jj).p22=Node(2*(ii-1)+jj).p2+[0 1 0;-1 0 0;0 0 0]*normv2*(-rh1-rh2/2);
        end
        Node(2*(ii-1)+jj).Or= CrossPoint(Node(2*(ii-1)+jj).p11,Node(2*(ii-1)+jj).p12,Node(2*(ii-1)+jj).p21,Node(2*(ii-1)+jj).p22);
        Node(2*(ii-1)+jj).theta1=atan2(Node(2*(ii-1)+jj).p1(2)-Node(2*(ii-1)+jj).Or(2),Node(2*(ii-1)+jj).p1(1)-Node(2*(ii-1)+jj).Or(1));
        Node(2*(ii-1)+jj).theta2=atan2(Node(2*(ii-1)+jj).p2(2)-Node(2*(ii-1)+jj).Or(2),Node(2*(ii-1)+jj).p2(1)-Node(2*(ii-1)+jj).Or(1));

        if (Node(2*(ii-1)+jj).p12-Node(2*(ii-1)+jj).p11)'*(Node(2*(ii-1)+jj).Or-Node(2*(ii-1)+jj).p11)>0
            Node(2*(ii-1)+jj).state=1;%clockwise

            Node(2*(ii-1)+jj).ri=norm(Node(2*(ii-1)+jj).Or-Node(2*(ii-1)+jj).p12);
            Node(2*(ii-1)+jj).ro=Node(2*(ii-1)+jj).ri+rh1;
        else
            Node(2*(ii-1)+jj).state=-1;%clockwise
            Node(2*(ii-1)+jj).ro=norm(Node(2*(ii-1)+jj).Or-Node(2*(ii-1)+jj).p12);
            Node(2*(ii-1)+jj).ri=Node(2*(ii-1)+jj).ro-rh1;
        end
        Node(2*(ii-1)+jj).volume = rh_z*myangle(Node(ii).theta1,Node(ii).theta2)*(Node(2*(ii-1)+jj).ro^2-Node(2*(ii-1)+jj).ri^2)/(2);
        Node(2*(ii-1)+jj).accumulation = 0;
        Node(2*(ii-1)+jj).AverageSpeed = 0;
        Node(ii).PeriodNexit = 0;
        Node(ii).PeriodTTT = 0;
        Node(ii).PeriodTTD = 0;
        Node(ii).PeriodNum = 0;

    end
end

for ii = 1: length(Roundabout_num)

    Roundabout(ii).num=Roundabout_num(ii);
    Roundabout(ii).pos=AirwayNetwork(Roundabout(ii).num,:)';
    Roundabout(ii).minangle = (2*pi)/sum(AdjacentMatrix(Roundabout_num(ii),:));
    Roundabout(ii).StateChangeHeight=R_ChangeHeight;
    Roundabout(ii).connection=find(AdjacentMatrix(Roundabout_num(ii),:)==1);
    for jj=1:length(Roundabout(ii).connection)-1
        for kk = jj+1:length(Roundabout(ii).connection)
            if acos(mycos(AirwayNetwork(Roundabout(ii).connection(jj),:),AirwayNetwork(Roundabout(ii).num,:),AirwayNetwork(Roundabout(ii).connection(kk),:)))<Roundabout(ii).minangle
                Roundabout(ii).minangle=acos(mycos(AirwayNetwork(Roundabout(ii).connection(jj),:),AirwayNetwork(Roundabout(ii).num,:),AirwayNetwork(Roundabout(ii).connection(kk),:)));
            end
        end
    end
    Roundabout(ii).buffer=pi/8;
    Roundabout(ii).minangle=Roundabout(ii).minangle-2*Roundabout(ii).buffer;
    Roundabout(ii).radius_i=max(min_turn_radius,2*rh1+rh2);
    ra=((Roundabout(ii).radius_i)*(sin(Roundabout(ii).minangle/2))/(1-sin(Roundabout(ii).minangle/2))-rh1-(rh2/2)/(1-sin(Roundabout(ii).minangle/2)));
    if ra<min_turn_radius
        ra=min_turn_radius;
        Roundabout(ii).radius_i=((min_turn_radius+rh1)*(1-sin(Roundabout(ii).minangle/2))/(sin(Roundabout(ii).minangle/2)))+rh2/(2*sin(Roundabout(ii).minangle/2));
    end
    Roundabout(ii).ra=ra;
    Roundabout(ii).radius_o=Roundabout(ii).radius_i+rh1;
    Roundabout(ii).changedis=(Roundabout(ii).radius_i+rh1+ra)*cos(Roundabout(ii).minangle/2);
    for jj=1:length(Roundabout(ii).connection)
        Roundabout(ii).Highway(jj).p=Roundabout(ii).pos-Roundabout(ii).changedis*(Roundabout(ii).pos-AirwayNetwork(Roundabout(ii).connection(jj),:)')/norm((Roundabout(ii).pos-AirwayNetwork(Roundabout(ii).connection(jj),:)'));
        Roundabout(ii).Highway(jj).om=Roundabout(ii).Highway(jj).p+[0 1 0;-1 0 0;0 0 1]*(Roundabout(ii).pos-Roundabout(ii).Highway(jj).p)/norm(Roundabout(ii).pos-Roundabout(ii).Highway(jj).p)*Roundabout(ii).changedis*tan(Roundabout(ii).minangle/2);
        Roundabout(ii).Highway(jj).od=Roundabout(ii).Highway(jj).p+[0 -1 0;1 0 0;0 0 1]*(Roundabout(ii).pos-Roundabout(ii).Highway(jj).p)/norm(Roundabout(ii).pos-Roundabout(ii).Highway(jj).p)*Roundabout(ii).changedis*tan(Roundabout(ii).minangle/2);
    end
    theta3=atan2(-Roundabout(ii).Highway(jj).od(2)+Roundabout(ii).pos(2),-Roundabout(ii).Highway(jj).od(1)+Roundabout(ii).pos(1));
    theta4=atan2(-Roundabout(ii).Highway(jj).od(2)+Roundabout(ii).Highway(jj).p(2),-Roundabout(ii).Highway(jj).od(1)+Roundabout(ii).Highway(jj).p(1));
    tempr=norm(Roundabout(ii).Highway(jj).od-Roundabout(ii).Highway(jj).p)-rh2/2;
    Roundabout(ii).volume=pi*rh_z*(Roundabout(ii).radius_o^2-Roundabout(ii).radius_i^2)+myangle(theta3,theta4)/(2*pi)*rh_z*2*sum(AdjacentMatrix(Roundabout_num(ii),:))*(tempr^2-(tempr-rh1)^2);
    Roundabout(ii).accumulation=0;
    Roundabout(ii).AverageSpeed = 0;
    Roundabout(ii).PeriodNexit = 0;
    Roundabout(ii).PeriodTTT = 0;
    Roundabout(ii).PeriodTTD = 0;
    Roundabout(ii).PeriodNum = 0;
end
AirwayList=[];
for ii= 1: size(AdjacentMatrix,1)
    num=find(AdjacentMatrix(ii,:) == 1);
    if ismember(ii,Airport_num)==true
        ii_radius=Airport(find(ii==Airport_num)).radius;
    else
        if ismember(ii,Node_num)==true
            ii_radius=Node(find(ii==Node_num)).radius;
        else
            ii_radius=Roundabout(find(ii==Roundabout_num)).radius_o;
        end
    end
    for jj =1:length(num)
        if ismember(num(jj),Airport_num)==true
            jj_radius=Airport(find(num(jj)==Airport_num)).radius;
        else
            if ismember(num(jj),Node_num)==true
                jj_radius=Node(find(num(jj)==Node_num)).radius;
            else
                jj_radius=Roundabout(find(num(jj)==Roundabout_num)).radius_o;
            end
        end
        AirwayList=[AirwayList; ii num(jj) norm(AirwayNetwork(ii,:)-AirwayNetwork(num(jj),:))-ii_radius-jj_radius norm(AirwayNetwork(ii,:)-AirwayNetwork(num(jj),:))];
    end
end
for ii=1:size(AirwayList,1)
    Airway(ii).num=ii;
    Airway(ii).StartNode=AirwayList(ii,1);
    Airway(ii).EndNode=AirwayList(ii,2);
    Airway(ii).Dx=AirwayList(ii,3);
    Airway(ii).Dy=rh1;
    Airway(ii).Dz=rh_z;
    Airway(ii).volume=AirwayList(ii,3)*rh1*rh_z;
    Airway(ii).AverageSpeed=0;
    Airway(ii).accumulation=0;
    Airway(ii).PeriodNexit = 0;
    Airway(ii).PeriodTTT = 0;
    Airway(ii).PeriodTTD = 0;
    Airway(ii).PeriodNum = 0;
    Airway(ii).distance=AirwayList(ii,4);
end
AllPaths=cell(length(AdjacentMatrix),length(AdjacentMatrix));
for ii= 1 : length(AdjacentMatrix)
    temp=[];
    for jj = 1: length(Airport)
        if ii~=Airport(jj).num
            Route=APAC(AdjacentMatrix,ii,Airport(jj).num);
            AllPaths{ii,Airport(jj).num}=RouteLength(AirwayList,Route);
        end
    end
end%%%youwenti
