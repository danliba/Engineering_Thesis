%% we start
%este codigo no puede ser interpolado porque la lon y lat aumentan y
%disminuyen, por lo cual no funciona la funcion de extract dist, por lo
%cual se usará las lat y lon de los modelos , ya que estos solo aumentan
%(linea recta)
%% datos entrada
% fn = 'SSH&SSTactual.nc';
% lat=double(ncread(fn,'latitude'));
% lon=double(ncread(fn,'longitude'));
% temp=double(ncread(fn,'thetao'));
load coastlines
%% 
r0=[-84 -70 -20 0]; %region range

plot(coastlon,coastlat,'k.');
hold on
plot(coastlon+5,coastlat);
axis(r0);
%% we cut only for peru
%r0=[-84 -78 -20 -10]; %region range

[lon1,lat1,indx_region]=region_cut(r0(1),r0(2),r0(3),r0(4),coastlon,coastlat);
%% plot
plot(lon1,lat1,'k.');
%%
lon=lon1; lat=lat1;
% latcentro=lat(1:109); %10ºS
% loncentro=lon(1:150); %75.58ºW
%% centro
% lon=loncentro; 
% lat=latcentro;
%% pre requisites
[Lon,Lat] = meshgrid(lon,lat);
disti=0:5000:2.6e6;

nm=15;%10 millas nauticas
km = nm2km(nm);
range0=0;
%% 

r=range0;
a=km-r;
b=km+r;
D = dist2coast(Lat,Lon); %calculamos la distancia radial a la costa 
D(island(Lat,Lon)) = NaN;
pcolor(D);shading flat;

% Contour
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
%distancia 
dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
distx=cat(2,0,cumsum(dx));

lonki=interp1(distx,lonk,disti);
latki=interp1(distx,latk,disti);

plot(lonki,latki,'k.');
%ST=permute(SSTs,[3,4,1,2]);
data=permute(temp,[1,2,4,3]);
SST=temp(:,:,1);
SST=SST(1:length(lon),1:length(lat));
pathdata=interp2(lon, lat,SST',lonki,latki);

%% ploteo
  pcolor(lon,lat,SST');shading flat;
        colorbar

        cmocean haline
        
        hold on
        %[c,h]=contour(lonissh,latissh,SSHi,[sshK sshK],'k');
        plot(lonki,latki,'r','linestyle','-','linewidth',1.5)
        borders('countries','k')
        
        axis([-90 -65 -20 0]);
 %% get the data within the line
 plot(pathdata)
