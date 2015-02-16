
%count = zeros(29,2);
count(:,1)=-6:1:11;
count(:,2)=0;

mort_count(:,1)=-6:1:11;
mort_count(:,2)=0;

ratio(:,1)=-6:1:11;
ratio(:,2)=0;

for i=1:length(data)
    if(data(i,3)<-6 || data(i,3)>11)
        continue;
    end
    
    if(data(i,4)==1)
        mort_count(data(i,3)+6+1,2)=mort_count(data(i,3)+6+1,2)+1;
    end
    count(data(i,3)+6+1,2)=count(data(i,3)+6+1,2)+1;
end

ratio(:,2)=mort_count(:,2)./count(:,2);