function output=createarc(flag, or,radius,heightchange,pt1,angle,clockwise,heightflag)
output=[];
switch flag
    case 1
        for ii=1:60
            theta=2*pi*(ii-1)/60;
            output=[output;or(1:2)'+radius*[cos(theta) sin(theta)] or(3)+heightchange];
        end
    case 2

        for ii=1:ceil(angle*60/(2*pi))+1
            theta=atan2(pt1(2)-or(2),pt1(1)-or(1))-clockwise*(ii-1)*angle/ceil(angle*60/(2*pi));
            output=[output;or(1:2)'+radius*[cos(theta) sin(theta)] or(3)+heightflag*heightchange*(ii-1)/ceil(angle*60/(2*pi))];
            %             output=[output;or(1:2)'+radius*[cos(theta) sin(theta)] or(3)];
        end
end