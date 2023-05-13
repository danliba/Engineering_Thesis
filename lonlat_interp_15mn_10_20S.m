clear all; close all; clc;
load('Lonlat10S_interp');

%% ahora con las 15mn
% pcolor(Lon,Lat,SST');shading flat;
% colorbar
lono=lon15mn20S(~isnan(lon15mn20S));
lata=lat15mn20S(~isnan(lat15mn20S));
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

mu =  -74.288;
sigma = 2.6585;
z = (x-mu)./sigma;

%Coefficients:
  p1 = -0.65534;
  p2 = -0.071043;
  p3 = 2.6166;
  p4 = -0.0079185;
  p5 = -2.7256;
  p6 = 0.37222;
  p7 = -0.63572;
  p8 = 0.40546;
  p9 = -1.2071;
  p10 = -16.074;
  
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
axis([-81 -65 -20 -10]);
