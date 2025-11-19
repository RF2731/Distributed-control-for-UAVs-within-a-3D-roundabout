function out = MyMap(UavTeam)

global AirwayNetwork AdjacentMatrix Airport Node Roundabout
global intersection rh1 rh2 rh_z AirwayList view2D
h=gcf;
%         clf
figure(h);

M = UavTeam.AvailableNumMax;

%Note Plot


%roundabout Plot
for i=1:length(Roundabout)
    %     mydrawcolorball(AirwayNetwork(R_island(i),1:2),r_island_outer,0,'g');
    %     mydrawcolorball(AirwayNetwork(R_island(i),1:2),r_island_inner,0,'w');
    
    
    mycylinder(AirwayNetwork(Roundabout(i).num,1:2),AirwayNetwork(Roundabout(i).num,3)-200,AirwayNetwork(Roundabout(i).num,3),Roundabout(i).radius_o,5);
    mycylinder(AirwayNetwork(Roundabout(i).num,1:2),AirwayNetwork(Roundabout(i).num,3)-200,AirwayNetwork(Roundabout(i).num,3),Roundabout(i).radius_i,5);
    for jj=1:length(Roundabout(i).connection)
        theta1=atan2(-Roundabout(i).Highway(jj).om(2)+Roundabout(i).pos(2),-Roundabout(i).Highway(jj).om(1)+Roundabout(i).pos(1));
        theta2=atan2(-Roundabout(i).Highway(jj).om(2)+Roundabout(i).Highway(jj).p(2),-Roundabout(i).Highway(jj).om(1)+Roundabout(i).Highway(jj).p(1));
        theta3=atan2(-Roundabout(i).Highway(jj).od(2)+Roundabout(i).pos(2),-Roundabout(i).Highway(jj).od(1)+Roundabout(i).pos(1));
        theta4=atan2(-Roundabout(i).Highway(jj).od(2)+Roundabout(i).Highway(jj).p(2),-Roundabout(i).Highway(jj).od(1)+Roundabout(i).Highway(jj).p(1));
        mysector(Roundabout(i).Highway(jj).om(1:2),Roundabout(i).Highway(jj).om(3)-200,Roundabout(i).Highway(jj).om(3),norm(Roundabout(i).Highway(jj).om-Roundabout(i).Highway(jj).p)-rh2/2,9,theta1,theta2);
        mysector(Roundabout(i).Highway(jj).om(1:2),Roundabout(i).Highway(jj).om(3)-200,Roundabout(i).Highway(jj).om(3),norm(Roundabout(i).Highway(jj).om-Roundabout(i).Highway(jj).p)-rh2/2-rh1,9,theta1,theta2);
        mysector(Roundabout(i).Highway(jj).od(1:2),Roundabout(i).Highway(jj).od(3)-200,Roundabout(i).Highway(jj).od(3),norm(Roundabout(i).Highway(jj).om-Roundabout(i).Highway(jj).p)-rh2/2,9,theta3,theta4);
        mysector(Roundabout(i).Highway(jj).od(1:2),Roundabout(i).Highway(jj).od(3)-200,Roundabout(i).Highway(jj).od(3),norm(Roundabout(i).Highway(jj).om-Roundabout(i).Highway(jj).p)-rh2/2-rh1,9,theta3,theta4);
    end
    text(Roundabout(i).pos(1),Roundabout(i).pos(2),Roundabout(i).pos(3),['R',num2str(i)]);
end
%Airport Plot
for i=1:length(Airport)
    %     mydrawcolorball(AirwayNetwork(Airport(i),1:2),r_airport,0,'y');
    mycylinder(AirwayNetwork(Airport(i).num,1:2),AirwayNetwork(Airport(i).num,3)-200,AirwayNetwork(Airport(i).num,3),Airport(i).radius,9);
    text(Airport(i).pos(1),Airport(i).pos(2),Airport(i).pos(3),['A',num2str(i)]);

end
%%%%%%%%%
for i=1:size(AirwayNetwork,1)
    adjacent_point = find(AdjacentMatrix(i,:)==1);
    N1 = [AirwayNetwork(i,:)]';
    for j = 1 : size(adjacent_point,2)
        N2=[AirwayNetwork(adjacent_point(j),:)]';
        [pt1,pt2,pt3,ptz]=tunnel(N1,N2);
        [pts1,pts2,pts3,ptsz]=tunnel(N2,N1);

        if ismember(i,find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 1))==true
            num = find(i==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) ==1));
            radius = Airport(num).radius;
            pt1=pt1+(pt2-pt1)*radius/norm(pt2-pt1);
            pts2=pts2+(pt2-pt1)*radius/norm(pt2-pt1);
            pts3=pts3+(pt2-pt1)*radius/norm(pt2-pt1);
            ptsz=ptsz+(pt2-pt1)*radius/norm(pt2-pt1);
        end
        if ismember(adjacent_point(j),find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 1))==true
            num = find(adjacent_point(j)==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) ==1));
            radius = Airport(num).radius;
            pt2=pt2+(pt1-pt2)*radius/norm(pt1-pt2);
            pt3=pt3+(pt1-pt2)*radius/norm(pt1-pt2);
            pts1=pts1+(pt1-pt2)*radius/norm(pt1-pt2);
            ptz=ptz+(pt1-pt2)*radius/norm(pt1-pt2);
        end
        if ismember(i,find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 2))==true
            num = find(i==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) ==2))*2;
            radius = Node(num).radius;

            pt1=pt1+(pt2-pt1)*radius/norm(pt2-pt1);
            pts2=pts2+(pt2-pt1)*radius/norm(pt2-pt1);
            pts3=pts3+(pt2-pt1)*radius/norm(pt2-pt1);
            ptsz=ptsz+(pt2-pt1)*radius/norm(pt2-pt1);
        end
        if ismember(adjacent_point(j),find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) == 2))==true
            num = find(adjacent_point(j)==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) ==2))*2;
            radius = Node(num).radius;
            pt2=pt2+(pt1-pt2)*radius/norm(pt1-pt2);
            pt3=pt3+(pt1-pt2)*radius/norm(pt1-pt2);
            pts1=pts1+(pt1-pt2)*radius/norm(pt1-pt2);
            ptz=ptz+(pt1-pt2)*radius/norm(pt1-pt2);
        end
        if ismember(i,find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2))==true
            num = find(i==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2));
            radius_o = Roundabout(num).radius_o;
            pt1=pt1+(pt2-pt1)*radius_o/norm(pt2-pt1);
            pts2=pts2+(pt2-pt1)*radius_o/norm(pt2-pt1);
            pts3=pts3+(pt2-pt1)*radius_o/norm(pt2-pt1);
            ptsz=ptsz+(pt2-pt1)*radius_o/norm(pt2-pt1);
        end
        if ismember(adjacent_point(j),find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2))==true
            num = find(adjacent_point(j)==find(AdjacentMatrix*ones(size(AdjacentMatrix,1),1) >2));
            radius_o = Roundabout(num).radius_o;
            pt2=pt2+(pt1-pt2)*radius_o/norm(pt1-pt2);
            pt3=pt3+(pt1-pt2)*radius_o/norm(pt1-pt2);
            pts1=pts1+(pt1-pt2)*radius_o/norm(pt1-pt2);
            ptz=ptz+(pt1-pt2)*radius_o/norm(pt1-pt2);
        end
        pt4=pt1+pt3-pt2;
        pts4=pts1+pts3-pts2;
        mycube(pt2',pt3',pt1',ptz');
        temp=(pt1+pt3+ptz-pt2)/2;
        for k = 1:size(AirwayList,1)
            if AirwayList(k,1)== i && AirwayList(k,2)==adjacent_point(j)
                text(temp(1),temp(2),temp(3),[num2str(k)]);
            end
        end
    end
end
for i=1:length(Node)
    temp=Node(i).intersection(1:3)';
    mysector(Node(i).Or(1:2),Node(i).Or(3)-rh_z/2,Node(i).Or(3)+rh_z/2,Node(i).ri,9,Node(i).theta1,Node(i).theta2);
    mysector(Node(i).Or(1:2),Node(i).Or(3)-rh_z/2,Node(i).Or(3)+rh_z/2,Node(i).ro,9,Node(i).theta1,Node(i).theta2);
    temp=(Node(i).intersection(1:3)+Node(i).intersection(4:6)+Node(i).intersection(7:9)+Node(i).intersection(10:12))/4;
    text(temp(1),temp(2),temp(3),['N',num2str(i)]);
end
%%%%%%%%%
for k = 1: M
    state=zeros(2,1);
    state(1)=UavTeam.Uav(k).TakeOffState;
    state(2)=UavTeam.Uav(k).LandingState;
    if state(1)==1 && state(2)~=2
        o2 = UavTeam.Uav(k).CurrentPos+1/UavTeam.gain*UavTeam.Uav(k).Velocity;
        mydrawcolorball(o2,1,1,1,state);
    end
end
hold off
axis([-1500 2500 -1000 1500])
axis equal
if view2D==true
view(0 ,90);
end
out = 0;