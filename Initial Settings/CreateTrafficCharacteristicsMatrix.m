function TrafficCharacteristicsMatrix=CreateTrafficCharacteristicsMatrix(Airway,Node,Roundabout,time_end,Ts)
TrafficCharacteristicsMatrix=cell(time_end*(1/Ts)+2,length(Airway)*2+length(Node)*2+length(Roundabout)*2+1);
TrafficCharacteristicsMatrix{1,1}='t';
for ii=1:length(Airway)
eval(['TrafficCharacteristicsMatrix{1,2*ii}=''Airway',num2str(ii),'_accumulation'';']);
eval(['TrafficCharacteristicsMatrix{1,2*ii+1}=''Airway',num2str(ii),'_averagespeed'';']);
end
for ii=1:length(Node)
eval(['TrafficCharacteristicsMatrix{1,2*length(Airway)+2*ii}=''Node',num2str(ii),'_accumulation'';']);
eval(['TrafficCharacteristicsMatrix{1,2*length(Airway)+2*ii+1}=''Node',num2str(ii),'_averagespeed'';']);
end
for ii=1:length(Roundabout)
eval(['TrafficCharacteristicsMatrix{1,2*length(Airway)+2*length(Node)+2*ii}=''Roundabout',num2str(ii),'_accumulation'';']);
eval(['TrafficCharacteristicsMatrix{1,2*length(Airway)+2*length(Node)+2*ii+1}=''Roundabout',num2str(ii),'_averagespeed'';']);
end
TrafficCharacteristicsMatrix(2:end,1)=mat2cell((0:Ts:time_end)',ones(1,time_end*(1/Ts)+1));
TrafficCharacteristicsMatrix(2,2:end)=mat2cell(zeros(1,2*(length(Airway)+length(Node)+length(Roundabout)))',ones(1,2*(length(Airway)+length(Node)+length(Roundabout))));
TrafficCharacteristicsMatrix(end,2:end)=mat2cell(zeros(1,2*(length(Airway)+length(Node)+length(Roundabout)))',ones(1,2*(length(Airway)+length(Node)+length(Roundabout))));
