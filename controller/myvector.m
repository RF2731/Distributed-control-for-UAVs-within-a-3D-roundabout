function out =  myvector(A,B,e,height)
if A==B
out=A*ones(1,e+1);
else 
out=A:(B-A)/e:B;
end
% if A(2)==B(2)
% temp2=A(2)*ones(1,e+1);
% else 
% temp2=A(2):(B(2)-A(2))/e:B(2);
% end
% if A(3)==B(3)
% temp3=A(3)*ones(1,e+1);
% else 
% temp3=A(3):(B(3)-A(3))/e:B(3);
% end
% out=[temp1;temp2;temp3];
