function [lonk, latk]=Extract_distaxis(lon, lat,nm,range)
% ���
%    sshfname: �C��?��x�f�[�^���i�[���Ă���Matlab file��
% 
km = nm2km(nm);

r=range;
a=km-r;
b=km+r;
D = dist2coast(lat,lon);
D(island(lat,lon)) = NaN;
% �ǂ�?��񂾊C��?��x��p����?A�����̓��l����v�Z����
c=contourc(lon(1,:),lat(:,1),D,[a b]);

% �v�Z�����ł��������l��ɉ������ܓx�o�x��?o����
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
