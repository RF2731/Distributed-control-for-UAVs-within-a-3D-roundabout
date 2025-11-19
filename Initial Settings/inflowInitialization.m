function inflow_settings = inflowInitialization(switchtime,switchvalue,glowthrate,lanenum)
inflow_settings.time = switchtime*60;
inflow_settings.value_init = switchvalue;
inflow_settings.glowthrate = glowthrate;
time_end=inflow_settings.time(end);
inflow_settings.lanenum = zeros(time_end,1);
inflow_settings.totallanenum = zeros(time_end,1);
inflow_settings.totalnum = zeros(time_end,1);
for ii=1:length(switchvalue)
    for jj= inflow_settings.time(ii):inflow_settings.time(ii+1)-1
    temp1=switchvalue(ii)+glowthrate(ii)*(jj-inflow_settings.time(ii));
    temp2=switchvalue(ii)+glowthrate(ii)*(jj+1-inflow_settings.time(ii));
    inflow_settings.lanenum(jj+1)=(temp1+temp2)/2;
%     inflow_settings.num(jj+1)=inflow_settings.lanenum(jj+1)*lanenum;
    end
for ii =1:size(inflow_settings.totalnum,1)
    inflow_settings.totallanenum(ii) = sum(inflow_settings.lanenum(1:ii));
%     inflow_settings.totalnum(ii) = sum(inflow_settings.num(1:ii));
end
inflow_settings.lanenum=[0;inflow_settings.lanenum];
inflow_settings.totallanenum=[0;inflow_settings.totallanenum];
% inflow_settings.totalnum=[0;inflow_settings.totalnum];
inflow_settings.totallanenum=floor(inflow_settings.totallanenum);
inflow_settings.totalnum=lanenum.*inflow_settings.totallanenum;
end

