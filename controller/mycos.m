function U=mycos(A,B,C)
a=sqrt((C(1)-B(1))^2+(C(2)-B(2))^2);
b=sqrt((A(1)-C(1))^2+(A(2)-C(2))^2);
c=sqrt((A(1)-B(1))^2+(A(2)-B(2))^2);
U=(a^2+c^2-b^2)/(2*a*c);
