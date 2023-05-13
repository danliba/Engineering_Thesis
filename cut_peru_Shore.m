clear all; close all; clc;
load('Lonlat_interp');

%% fig 1
pcolor(Lon,Lat,SST');shading flat;
colorbar

cmocean balance
caxis([-5 5]);
borders('countries','k')
axis([-86 -77 -12 -4]);
hold on

 %%
 %% Line interpolation

lo=[-82:0.076:-78]'; %lo        23x1
la=[-5:-0.095:-10]'; %la        23x1

disti=0:5000:6e6;

 dx=distance(la(2:end),lo(2:end),la(1:end-1),lo(1:end-1)).*60.*1852;
 distx=cat(1,0,cumsum(dx));
 
 lonkli=interp1(distx,lo,disti); % lonkli      1x1201  
 latkli=interp1(distx,la,disti); %latkli      1x1201
 
plot(lonkli,latkli,'ro','linewidth',1)

%% fig 2 
pcolor(Lon,Lat,SST');shading flat;
colorbar

cmocean balance
caxis([-5 5]);
borders('countries','k')
axis([-86 -77 -12 -4]);
hold on
plot(lonkli,latkli,'ro','linewidth',1)
%% 

t=polyfit(lo,la,1);
t0=polyval(t,lo);

%create a simulated latitude by the formula y=ax+b, then compare with the real one
%so we multiply the fitted t*longitude bc they have to be the same size lat
%and lon
lat0=t(1,1).*Lon+t(1,2); %lon3      108x125  %lat0      108x125
%then we find the where they are different
mask=double(lat0<=Lat);

%%
a=SST'.*mask;
a(a==0)=NaN;
%% fig 3
pcolor(Lon,Lat,a); colorbar; shading flat;
borders('countries','k')
hold on
plot(lonkli,latkli,'ro','linewidth',1)
hold on
plot(lon15mn,lat15mn,'b.');
axis([-86 -77 -12 -4]);

%% ahora con las 15mn
% pcolor(Lon,Lat,SST');shading flat;
% colorbar
lono=lon15mn(~isnan(lon15mn));
lata=lat15mn(~isnan(lat15mn));
% t=csapi(lon15mn,lat15mn);
% fnplt(t);


%% 
cmocean balance
caxis([-5 5]);
borders('countries','k')
axis([-90 -65 -35 0]);
hold on
plot(lono,lata,'b.');
%% 
x=Lon;

mu =  -79.761;
sigma = 1.0063;
z = (x-mu)./sigma;

%Coefficients:
  p1 = -0.19134;
  p2 = -0.016468;
  p3 = 1.1411;
  p4 = 0.12334;
  p5 = -2.6014;
  p6 = -0.38862;
  p7 = 2.4613;
  p8 = 0.063345;
  p9 = -2.1061;
  p10 = -7.4841;
  
% where z is centered
% and scaled:

lat0 = p1.*z.^9 + p2.*z.^8 +...
      p3.*z.^7 + p4.*z.^6 +...
      p5.*z.^5 + p6.*z.^4 +...
      p7.*z.^3 + p8.*z.^2 +...
      p9.*z + p10;

plot(lat0(1,338:706));
lat02=lat0(1,338:706);

mask2=double(lat0<=Lat);

a=SST'.*mask2;
a(a==0)=NaN;
%% fig 3
pcolor(Lon,Lat,a); colorbar; shading flat;
borders('countries','k')
hold on
plot(lono,lata,'r.')
axis([-86 -77 -12 -4]);

%%
% t1=polyfit(lono,lata,1);
% t01=polyval(t1,lo);
% 
% %create a simulated latitude by the formula y=ax+b, then compare with the real one
% %so we multiply the fitted t*longitude bc they have to be the same size lat
% %and lon
% lat02=t1(1,1).*Lon+t1(1,2); %lon3      108x125  %lat0      108x125
%then we find the where they are different

