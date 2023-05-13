%% we start%% we start
cd D:\TESIS_INGE\parte_experimental\costa_extraccion
%% datos entrada
clear all 
close all
clc
%%
fn = '20230109090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc';
lat=double(ncread(fn,'lat'));
lon=double(ncread(fn,'lon'));
%temp=double(ncread(fn,'CHL'));

%range
range0=[-85 -65 -10 -5];
indxlat=find(lat<=range0(4) & lat>=range0(3));
indxlon=find(lon>=range0(1) & lon<=range0(2));

lon2=lon(indxlon); lat2=lat(indxlat); %Range 
%% Definimos el rango
temp=double(ncread(fn,'sst_anomaly',[indxlon(1) indxlat(1) 1],[length(lon2) length(indxlat) 1],[1 1 1]));

%% pre requisites
[Lon,Lat] = meshgrid(lon2,lat2);
disti=0:5000:2.6e6;

%5mn = 9.26km
%resol modelo = 8.3km
nm=15; %10 millas nauticas
km = nm2km(nm);
range0=0;
%% 

r=range0;
a=km-r;
b=km+r;
%calculamos la distancia radial a la costa y aqui tenemos varias isolineas
%paso siguiente mejorar la resolucion de D, para poder tener mejores
%valores
D = dist2coast(Lat,Lon); %this is in km
D(island(Lat,Lon)) = NaN;

D2=movmean(D,10,2,'omitnan');
fff=D-D2;

%% just graphs
pcolor(Lon,Lat,D);shading flat;
%hold on
% [cc,hh]=contour(lon,lat,D,[20 200],'m-','linewidth',0.5); %10 y 100mn
% clabel(cc,hh);
% axis([-85 -65 -20 0]);
% hold on
% [cc,hh]=contour(lon,lat,D2,[20 200],'g-','linewidth',0.5);
% clabel(cc,hh);
% borders('countries','k')

%% Contour
c=contourc(Lon(1,:),Lat(:,1),D,[a b]); % c(1,1) = a %distancia dada al inicio
plot(c(1,:),c(2,:),'k.')

% ï¿½vï¿½Zï¿½ï¿½ï¿½ï¿½ï¿½Å‚ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½lï¿½ï¿½É‰ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ü“xï¿½oï¿½xï¿½ð’Š?oï¿½ï¿½ï¿½ï¿½
[m,n]=size(c);
flag=1;
endnum=0;
numdatap=0;
while flag==1
    numdata=c(2,endnum+1); %vamos a encontrar las latitudes y long correctas con este metodo
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
%esta funcion nos da lonk y latk
%% 
%nangrid=nan([length(lat),length(lon)]);
plot(latk,lonk,'k.')
hold on
plot(latk(2:end),lonk(2:end),'bx');
hold on
plot(latk(1:end-1),lonk(1:end-1),'go');
%%
rm=40;
latk=movmean(latk,rm);
lonk=movmean(lonk,rm);
%% 
%distancia 
dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
distx=cat(2,0,cumsum(dx));

lonki=interp1(distx,lonk,disti);
latki=interp1(distx,latk,disti);

plot(lonki,latki,'k.');
%ST=permute(SSTs,[3,4,1,2]);
data=permute(temp,[1,2,4,3]);
SST=temp(:,:,1);
SST=SST(1:length(lon2),1:length(lat2));
pathdata=interp2(lon2, lat2,SST',lonki,latki);

%% ploteo
  pcolor(lon2,lat2,SST');shading flat;
        colorbar

        cmocean balance
        caxis([-5 5]);
        hold on
        %[c,h]=contour(lonissh,latissh,SSHi,[sshK sshK],'k');
        plot(lonki,latki,'r','linestyle','-','linewidth',1.5)
        borders('countries','k')
        
        axis([-90 -65 -35 0]);
 %% get the data within the line
%  figure
%  plot(pathdata)


   %% running mean
   wz=40;
   lonrm=movmean(lonki,wz,'omitnan');
   latrm=movmean(latki,wz,'omitnan');
   figure
    plot(lonrm,latrm,'r','linestyle','-','linewidth',0.5)
    borders('countries','k')
%     hold on
%     plot(lonrm+0.35,latrm,'g','linestyle','-','linewidth',0.5)% 1º = 60mn, 0.35º = 21mn 
% 
    axis([-90 -65 -35 0]);
    grid on 
    title(['Distancia a la costa ', num2str(nm),'mn']);
    axis square

%% interpolation again with the rm
pathdata2=interp2(lon2, lat2,SST',lonrm,latrm);
lon15mn10S=lonrm;
lat15mn10S=latrm;

%%
mfile='Lonlat15mn_interp';
save(mfile,'lon15mn','lat15mn','Lon','Lat','SST');




