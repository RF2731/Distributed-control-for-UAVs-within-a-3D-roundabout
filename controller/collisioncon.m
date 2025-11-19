function [NewUavTeam,V,ConflictMatrix,ConflictMatrix2] = collisioncon(UavTeam,accumulation,conflictcalculate,ConflictMatrix,ConflictMatrix2,vmax)
global Gainfactor_rs Gainfactor_ra
global AirwayNetwork Airport_num Node_num Roundabout_num
global vm_matrix totalnum mode scenario ConflictsNum
NewUavTeam=UavTeam;
M = accumulation;
V = [];
vm_matrix=zeros(3*M,M);
for i=1:M
    for j = 1:M
        if i<j && ((NewUavTeam.Uav(i).State.ElementType==NewUavTeam.Uav(j).State.ElementType)||(NewUavTeam.Uav(i).State.ElementNum==NewUavTeam.Uav(j).State.ElementNum))
            ksimil = (NewUavTeam.Uav(i).State.CurrentPos - NewUavTeam.Uav(j).State.CurrentPos) +...
                1/NewUavTeam.Uav(i).Modularity.gain * (NewUavTeam.Uav(i).State.Velocity - NewUavTeam.Uav(j).State.Velocity);
            rs = NewUavTeam.Uav(i).Modularity.rs*Gainfactor_rs;
            ra = NewUavTeam.Uav(i).Modularity.ra*Gainfactor_ra;
            if norm(ksimil)<(ra+rs)
                % if norm(ksimil)<2*rs
                % NewUavTeam.Uav(i).vmax=2;
                % NewUavTeam.Uav(j).vmax=2;
                % else
                % NewUavTeam.Uav(i).vmax=vmax;
                % NewUavTeam.Uav(j).vmax=vmax;
                % end
                if conflictcalculate==1
                    switch scenario
                        case 1
                            if ConflictMatrix(i,j)==0 
                                ConflictMatrix(i,j)=1;
                                ConflictsNum=ConflictsNum+1;
                            end
                            if ConflictMatrix2(i,j)==0 
                                ConflictMatrix2(i,j)=1;
                            end
                        case 2
                            if ConflictMatrix(i,j)==0 && NewUavTeam.Uav(i).State.ElementType==3 && NewUavTeam.Uav(j).State.ElementType==3
                                ConflictMatrix(i,j)=1;
                                ConflictsNum=ConflictsNum+1;
                            end
                            if ConflictMatrix2(i,j)==0 && NewUavTeam.Uav(i).State.ElementType==3 && NewUavTeam.Uav(j).State.ElementType==3
                                ConflictMatrix2(i,j)=1;
                            end
                    end
                end
                gamma =1;
                k3 = 1; e = 0.000001;
                temp = (1+e)*norm(ksimil) - ((gamma+1)*rs)*mys(norm(ksimil)/((gamma+1)*rs),e);
                bil = k3*dmysigma(norm(ksimil),(gamma+1)*rs,ra+rs)/temp ...
                    - k3*mysigma(norm(ksimil),(gamma+1)*rs,ra+rs)*((1+e)-dmys(norm(ksimil)/((gamma+1)*rs),e))/(temp^2);
                vm_matrix(3*i-2:3*i,j)= - bil*(ksimil/norm(ksimil));
            else
%                 if conflictcalculate==1
%                     if ConflictMatrix(i,j)==1 && NewUavTeam.Uav(i).type==3 && NewUavTeam.Uav(j).type==3
%                         ConflictMatrix(i,j)=0;
%                     end
%                 end
            end
        else if i>j
                vm_matrix(3*i-2:3*i,j)= - vm_matrix(3*j-2:3*j,i);
        end
        end
    end
end

for k = 1:M
    Pcur = NewUavTeam.Uav(k).State.CurrentPos;
    Vcur = NewUavTeam.Uav(k).State.Velocity;
    if NewUavTeam.Uav(k).State.LandingState ==1 %landing
        [NewUavTeam,VelocityCom_k] = VTcontroller_landing(k,NewUavTeam);
    else %virtual tube
        if NewUavTeam.Uav(k).State.CurrentWaypoint ~= NewUavTeam.Uav(k).Routing.NextWaypoint
            [NewUavTeam,VelocityCom_k] = Tcontroller(k,NewUavTeam,[AirwayNetwork(NewUavTeam.Uav(k).State.CurrentWaypoint,:)]',[AirwayNetwork(NewUavTeam.Uav(k).Routing.NextWaypoint,:)]',sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:)));
        else
            if ismember(NewUavTeam.Uav(k).Routing.NextWaypoint,Node_num)==true %Node (Arc)
                [NewUavTeam,VelocityCom_k] = Hcontroller(k,NewUavTeam,sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:)));
            else
                if ismember(NewUavTeam.Uav(k).Routing.NextWaypoint,Roundabout_num)==true %Roundabout
                    switch mode
                        case 1
                            [NewUavTeam,VelocityCom_k] = Rcontroller(k,NewUavTeam,sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:)));
                        case 2
                            [NewUavTeam,VelocityCom_k] = Rcontroller(k,NewUavTeam,sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:)));
                        case 3
                            [NewUavTeam,VelocityCom_k] = Rcontrollerunstructure(k,NewUavTeam,sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:)));
                    end
                else
                    [NewUavTeam,VelocityCom_k]   =  VTcontroller_takeoff(k,NewUavTeam,sum(vm_matrix(3*k-2,:)),sum(vm_matrix(3*k-1,:)),sum(vm_matrix(3*k,:))); %Airport takeoff
                end
            end
        end
    end

    % Collect all the control
    V  = [V;VelocityCom_k];
end

