%clear all;

x=data(:,4:33)
outcome=data(:,34:41);
hosp_mort=outcome(:,1);
mort_28=outcome(:,2);
mort_1yr=outcome(:,3);
mort_2yr=outcome(:,4);

point=zeros(6,30);

%hospital mortality
point(1,:)=ElixhauserPointSystemLogit(x,hosp_mort,0.05);

%28 day mortality
point(2,:)=ElixhauserPointSystemLogit(x,mort_28,0.05);

% 1 yr mortality
point(3,:)=ElixhauserPointSystemLogit(x,mort_1yr,0.05);

%2 yr mortality
point(4,:) = ElixhauserPointSystemLogit(x,mort_2yr,0.05);

%1 yr survivial
point(5,:) = ElixhauserPointSystemCox(x,outcome(:,5),outcome(:,6),0.05);

%2 yr survivial
point(6,:) = ElixhauserPointSystemCox(x,outcome(:,7),outcome(:,8),0.05);