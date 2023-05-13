%% we start
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
range0=[-85 -65 -20 -10];
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
lon15mn20S=lonrm;
lat15mn20S=latrm;

%%
mfile='Lonlat10S_interp';
save(mfile,'lon15mn20S','lat15mn20S','Lon','Lat','SST');
 %% get the data within the line
%  figure
%  plot(pathdata2)
%      
 
%% part 2 masknan 5 a 10ºS

% %modeled 
% % t=polyfit(lo,la,1);
% % t0=polyval(t,lo);
% t=polyfit(lonrm,latrm,9);
% 
% % 
% % Coefficients:
%   p1 = -1.1935e-06;
%   p2 = -0.0015163;
%   p3 = -0.52348;
%   p4 = -72.914;
%   p5 = -1960.2;
%   p6 = 6.8972e+05;
%   p7 = 9.8021e+07;
% %   p8 = 6.0085e+09;
%   p9 = 1.8402e+11;
%   p10 = 2.2995e+12;
%   

%% 5 a 10ºS
% x=Lon;
% lat0 = p1.*x.^9 + p2.*x.^8 +...
%       p3.*x.^7 + p4.*x.^6 +...
%       p5.*x.^5 + p6.*x.^4 +...
%       p7.*x.^3 + p8.*x.^2 +...
%       p9.*x + p10; 
%  lat02=lat0./aa;
%  plot(Lon(1,:),lat02(1,:));
%% 
% plot(Lon,lat0,'b.'); hold on;
%     plot(lonrm,latrm,'r','linestyle','-','linewidth',0.5)
%     borders('countries','k')
%     axis([-90 -65 -35 0]);
%%
%disp(t)
% %create a simulated latitude by the formula y=ax+b, then compare with the real one
% %so we multiply the fitted t*longitude bc they have to be the same size lat
% %and lon
% lat0=t(1,1).*lon3+t(1,2);
% %then we find the where they are different
% mask=double(lat0>=lat3);


%% save

% mfile=Lonlat_interp;
% save(mfile,'lon15mn','lat15mn','lon','depth','SSTw','lat','temp2');
 
%%
% Cubic Spline Interpolant of Smooth Data
% Suppose you want to interpolate some smooth data, e.g., to

% rng(6), x = (4*pi)*[0 1 rand(1,15)]; y = sin(x);
% %You can use the cubic spline interpolant obtained by
% 
% cs = csapi(x,y);
% %and plot the spline, along with the data, with the following code:
% 
% fnplt(cs);
% hold on
% plot(x,y,'o')
% legend('cubic spline','data')
% hold off

% t=csapi(lonrm,latrm);
% fnplt(t);
% hold on
%     plot(lonrm,latrm,'r','linestyle','-','linewidth',0.5)
%     borders('countries','k')

%% formula


%plot(cs.breaks,cs.coefs,'k.');