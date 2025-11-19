function out = myangle(theta1,theta2)

out = norm(theta1-theta2);
if out >pi
    out = 2*pi-out;
end