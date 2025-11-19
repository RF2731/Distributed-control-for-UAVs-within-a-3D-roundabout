function out=plotpiecewise(obj,x,y,k)
xx=[];
yy=[];
x=x/60;
for ii=1:length(x)-1
    eval(['x',num2str(ii),'=x(ii):0.1:x(ii+1);']);
    if k(ii)~=0
        eval(['y',num2str(ii),'=y(ii):0.1*k(ii):y(ii)+k(ii)*(length(x',num2str(ii),')-1)*0.1;']);
    else
        eval(['y',num2str(ii),'=y(ii)*ones(1,length(x',num2str(ii),'));']);
    end
    eval(['xx=[xx x',num2str(ii),'];']);

    eval(['yy=[yy y',num2str(ii),'];']);
end

plot(obj,xx,yy,'r','LineWidth',1);
axis([0 max(x) 0 max(y)])
