function [lonk, latk]=Extract_distaxis(lon, lat,nm,range)
% ï¿½ï¿½ï¿½
%    sshfname: ï¿½Cï¿½Ê?ï¿½ï¿½xï¿½fï¿½[ï¿½^ï¿½ï¿½ï¿½iï¿½[ï¿½ï¿½ï¿½Ä‚ï¿½ï¿½ï¿½Matlab fileï¿½ï¿½
% 
km = nm2km(nm);

r=range;
a=km-r;
b=km+r;
D = dist2coast(lat,lon);
D(island(lat,lon)) = NaN;
% ï¿½Ç‚İ?ï¿½ï¿½ñ‚¾ŠCï¿½Ê?ï¿½ï¿½xï¿½ï¿½pï¿½ï¿½ï¿½Ä?Aï¿½ï¿½ï¿½ï¿½ï¿½Ì“ï¿½ï¿½lï¿½ï¿½ï¿½ï¿½vï¿½Zï¿½ï¿½ï¿½ï¿½
c=contourc(lon(1,:),lat(:,1),D,[a b]);

% ï¿½vï¿½Zï¿½ï¿½ï¿½ï¿½ï¿½Å‚ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½lï¿½ï¿½É‰ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ü“xï¿½oï¿½xï¿½ğ’Š?oï¿½ï¿½ï¿½ï¿½
[m,n]=size(c);
flag=1;
endnum=0;
numdatap=0;
while flag==1
    numdata=c(2,endnum+1);
    if numdata > numdatap
        lonk=c(1, endnum+2: endnum+1+numdata);
        latk=c(2, endnum+2: endnum+1+numdata);
        numdatap=numdata;
    end
    endnum=endnum+1+numdata;
    if endnum+1>n
        flag=-1;
     end
end
