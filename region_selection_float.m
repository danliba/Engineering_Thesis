function [lon1,lat1,temp1,sal1,depth1,indx_region,nflot1,ncycle]=region_selection_float(r1,r2,...
    r3,r4,x,y,T,S,D,n_flot,n_cycle)

%%range
range0=[r1 r2 r3 r4];

%x=lon(:,1); y=lat(:,1);
%x=x';
%y=y';

%x(x<0)=x(x<0)+360;
iter=0;

for id=1:1:size(x,1)
   iter=iter+1;
    if range0(1)<=x(id) && x(id)<=range0(2)
       x0(iter,1)=true;
    else
        x0(iter,1)=false;
    end

    if range0(3)<=y(id) && y(id)<=range0(4)
        y0(iter,1)=true;
    else
        y0(iter,1)=false;
    end

    if x0(id)==1 && y0(id)==1
        a(iter,1)=true;
    else
        a(iter,1)=false;
    end

end
indx_region=find(a==1);
lon1=x(indx_region);
lat1=y(indx_region);
temp1=T(:,indx_region);
sal1=S(:,indx_region);
depth1=D(:,indx_region);
nflot1=n_flot(indx_region);
ncycle=n_cycle(indx_region);
end
