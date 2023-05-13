cd F:\simulaciones\prueba2\2007-2008;
clear all; close all; clc;
%%
fn='OffPeruJackMac_20071030_20080831.nc';
disp(['Reading ',fn]) 
lon=ncread(fn,'lon');
lat=ncread(fn,'lat');
depth=ncread(fn,'depth');
%temp=ncread(fn,'temp');
time=ncread(fn,'times');
[yr,mo,da,hr,min,sec]=datevec(time);

load('Lonlat20S_interp');
%% buscaremos las particulas que cayeron en la zona de desove por cada mes
% Se inicio el 01 de octubre, para lo cual buscaremos las particulas que
% cayeron el mes de noviembre
flag=0;
%consideraremos toda la profundidad
%años
fnst=fn(16:19); fnend=fn(25:28);
%primero buscamos la fecha 10 al 31 noviembre %yr,mo,da,hr,min
yrp=[str2num(fnst),str2num(fnend)]; mop=[11,12,1,2,3,4,5,6,7,8];

for kk=1:1:length(mop)
    if kk==1 % noviembre
        date_ini=datenum(yr(1),mop(kk)-1,30); date_end=datenum(yr(1),mop(kk),30,23,59,0);
        disp(datestr(datenum(date_end)))
    elseif kk==2 %dic
        date_ini=datenum(yr(1),mop(kk),1); date_end=datenum(yr(1),mop(kk),31,23,59,0);
        disp(datestr(datenum(date_end)))
    elseif kk==3 %en
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),31,23,59,0);
        disp(datestr(datenum(date_end)))
    elseif kk==4 %feb
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),28,23,59,0);
        disp([datestr(datenum(date_end)),' FEB'])
    else
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),30,23,59,0);
        disp([datestr(datenum(date_end)),' mop 2008'])
    end
%nov10=[2007,11,1]; nov31=[2007,11,30];
indxtime=find(time>=datenum(date_ini) & time<=datenum(date_end));

lon2=lon(:,indxtime);
lat2=lat(:,indxtime);
depi2=depth(:,indxtime);

lon3=lon2(:,end); 
lat3=lat2(:,end);


% graph
    if flag==1
        plot(lon2(:,end),lat2(:,end),'.'); 
        hold on
        title(['Particles in ', datestr(datenum(date_end))]);
        hold on
        plot(lon15mn20S,lat15mn20S,'r','linestyle','-','linewidth',0.5)
        borders('countries','k');
        axis square; axis([-85 -65 -30 0])
        pause(2)
        clf
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Encontramos las particulas que cayeron dentro de las 15mn en Nov
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    iter=0;
    for ii=1:1:10000
    iter=iter+1;
    longi=lon3(ii);
    latit=lat3(ii);

    ff=longi>=lon15mn20S;
    %ff2=sum(ff);
    gg=latit>=lat15mn20S;
    %gg2=sum(gg);
    hh=ff.*gg; 
    hh=sum(hh,2);
    %ff2>0 && gg2>0
    if hh>0
        disp(['Particula cayo dentro', ' Nº',num2str(ii)])
        x0(iter,1)=true;
    else
        x0(iter,1)=false;
    end
    end

    indx0=find(x0>0);

%%creamos cuadro para noviembre
n_particles(kk,:)=length(indx0);
mm_yy(kk,:)={datestr(datenum(date_end))}; 
fechas(kk,:)=datenum(date_end);
indx_total{kk}=indx0;%numero de particula
time_mat{:,kk}=indxtime;
end
%% tabla
indx_part=NaN(max(n_particles),length(indx_total));

%%encontramos el numero de las particulas que caen por mes, sacamos las repetidas
%primero creamos el array
iter0=0;
for ij=1:1:length(indx_total)
    leni=length(indx_total{ij});    
    for ik=1:1:leni
        iter0=iter0+1;
        indx_part(ik,ij)=indx_total{ij}(ik);
    end
end

%ahora con indx_part veremos cuales son distintas

T=table(mm_yy,n_particles);
T;
%% ismember looks for repeated varibles where the data of A is found in B
cols=[1:size(indx_part,2)];
indx_part2=indx_part;
%funcion que saca las particulas repetidas 
for ik=1:1:size(indx_part,2)
%disp(ik)
%col 2 vs 1
for kk=2:1:size(indx_part,2)
    
    if ik==kk
        %disp('No way man, these are the same value')
        continue
    else
    rep_part=~ismember(indx_part2(:,kk),indx_part2(:,cols(ik)));
    indx_part2(:,kk)=indx_part2(:,kk).*rep_part;
    clear rep_part
    end
end
end
%% 
indx_part2(indx_part2 == 0) = NaN;
particles_recruited=sum(~isnan(indx_part2),1);
particles_recruited=particles_recruited';

T2=table(mm_yy,particles_recruited);
T2
%%
flag=0;
if flag==1
    figure
    bar(fechas,T2.particles_recruited)
    datetick('x','keepticks');
    grid minor
    title(fn)
    disp(['Particulas reclutadas: ',num2str(sum(particles_recruited))])
end
%% tiempo
time_nan=NaN(1000,length(indx_total));
%%encontramos las particulas que caen por mes
iter0=0;
for ij=1:1:length(time_mat)
    leni=length(time_mat{ij});    
    for ik=1:1:leni
        iter0=iter0+1;
        time_nan(ik,ij)=time_mat{ij}(ik);
    end
end

time_end=max(time_nan);
rep_time=repelem(time_end,particles_recruited);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% We will check the Time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vv=indx_part2(:);
V=vv(~isnan(vv)); %indices sin nan
flag=0;
%V=rep_time(:);
%sacamos los indices de indx_part y buscamos la temperatura de estas
%particulas y su recorrido
%tenemos que encontrar el tiempo en el que cada particula llega por primera
%vez a la costa peruana
if flag==1
    for jj=1:1:40
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,time(1:rep_time(jj)));
        colorbar; colormap jet;
        hold on
    end

    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square; axis([-85 -65 -30 0])
end 
 %%
flag=0; %para graficar cambiar flag a 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% We will check the Temperature %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%We will read the temperature of the selected particles first
for jj=1:1:length(V)
    temp1=double(ncread(fn,'temp',[V(jj) 1],[1 Inf],[1 1]));
    if jj==1
        disp('reading SST')
    end
    sst(jj,:)=temp1;
    if flag==1
    scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,temp1(1:rep_time(jj)));
    colorbar; colormap jet
    hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Salinity  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for jj=1:1:length(V)
    sal=double(ncread(fn,'salt',[V(jj) 1],[1 Inf],[1 1]));
    if jj==1
        disp('reading sal')
    end
    sali(jj,:)=sal;
    if flag==1
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,sal(1:rep_time(jj)));
        colorbar; caxis([33 35.5]); colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% U velocity  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for jj=1:1:length(V)
    uvel=double(ncread(fn,'u',[V(jj) 1],[1 Inf],[1 1]));
    if jj==1
        disp('reading uvel')
    end
    uveli(jj,:)=uvel;
    %jj=1;
    if flag==1
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,uvel(1:rep_time(jj)));
        colorbar; colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% V velocity  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for jj=1:1:length(V)
    vvel=double(ncread(fn,'v',[V(jj) 1],[1 Inf],[1 1]));
    if jj==1
        disp('reading vvel')
    end
    vveli(jj,:)=vvel;
    if flag==1
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,vvel(1:rep_time(jj)));
        colorbar; colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%% wvel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W velocity  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for jj=1:1:length(V)
    wvel=double(ncread(fn,'w',[V(jj) 1],[1 Inf],[1 1]));
    if jj==1
        disp('reading wvel')
    end
    wveli(jj,:)=wvel;
    %jj=1;
    if flag==1
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,wvel(1:rep_time(jj)));
        colorbar; colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%% depth, lon, lat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Depth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%leemos las particulas que nos interesan contenidas en V
for jj=1:1:length(V)
    dep=double(ncread(fn,'depth',[V(jj) 1],[1 Inf],[1 1]));
    lonp=double(ncread(fn,'lon',[V(jj) 1],[1 Inf],[1 1]));
    latp=double(ncread(fn,'lat',[V(jj) 1],[1 Inf],[1 1]));
    
    if jj==1
        disp('reading depth,lon & lat')
    end
    depis(jj,:)=dep;
    lonpis(jj,:)=lonp;
    latpis(jj,:)=latp;
    
    if flag==1
        scatter(lon(V(jj),1:rep_time(jj)),lat(V(jj),1:rep_time(jj)),0.1,dep(1:rep_time(jj)));
        colorbar; colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end

%% ploteo variables de las 10 primeras particulas
flag=0;
if flag==1
    figure 
    subplot(2,3,1)
    boxplot(sst(1:10,:)'); title('Temperature');
    subplot(2,3,2)
    boxplot(sali(1:10,:)'); title('Sal');
    subplot(2,3,3)
    boxplot(vveli(1:10,:)'); title('V vel');
    subplot(2,3,4)
    boxplot(uveli(1:10,:)'); title('Uvel');
    subplot(2,3,5)
    boxplot(wveli(1:10,:)'); title('W vel');
    subplot(2,3,6)
    boxplot(depis(1:10,:)'); title('Depth');
end
%% encuentra el dia en el que llegaron a las 15mn
for kk=1:1:size(lonpis,1)
    for ii=1:1:size(lonpis,2)

        nlon=lonpis(kk,ii);
        nlat=latpis(kk,ii);

        ff2=nlon>=lon15mn20S; %valores > que longitud 15mn
        gg2=nlat>=lat15mn20S; %valores > latitud 15mn

        hh2=ff2.*gg2; 
        hh2=sum(hh2,2);

        if hh2>0
            disp(['Particula cayo dentro', ' tiempo ',num2str(ii)])
            cut_time(kk)=ii;
            break
        end
    end
end
%cut_time tiene el numero de indice, similar a rep_time
%% time
 %We will read the time of the selected particles first
 %cortamos el tiempo 
 flag=0;
for jj=1:1:length(V)
    timep=double(ncread(fn,'times',[1],[cut_time(jj)],[1]));

    if jj==1
        disp('reading time')
    end
    timeis{:,jj}=timep;

    if flag==1
        scatter(lon(V(jj),1:cut_time(jj)),lat(V(jj),1:cut_time(jj)),0.1,timep(1:cut_time(jj)));
        colorbar; colormap jet
        hold on
    end
end

if flag==1
    plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)
    borders('countries','k');
    axis square
    axis([-85 -65 -30 0])
end
%%
% Despues de esto tenemos que cortar en el tiempo con cut_time
for kk=1:1:length(cut_time)
    sst_p{:,kk}=sst(kk,1:cut_time(kk));
    depth_p{:,kk}=depis(kk,1:cut_time(kk));
    lonpis_p{:,kk}=lonpis(kk,1:cut_time(kk));
    latpis_p{:,kk}=latpis(kk,1:cut_time(kk));
    sali_p{:,kk}=sali(kk,1:cut_time(kk));
    uveli_p{:,kk}=uveli(kk,1:cut_time(kk));
    vveli_p{:,kk}=vveli(kk,1:cut_time(kk));
    wveli_p{:,kk}=wveli(kk,1:cut_time(kk));
end

%% Ahora pasamos de cell a mat y llenamos con NaN los vacios

sal_part=NaN(length(cut_time),length(time));
sst_part=NaN(length(cut_time),length(time));
depth_part=NaN(length(cut_time),length(time));
lonpis_part=NaN(length(cut_time),length(time));
latpis_part=NaN(length(cut_time),length(time));
time_part=NaN(length(cut_time),length(time));
uveli_part=NaN(length(cut_time),length(time));
vveli_part=NaN(length(cut_time),length(time));
wveli_part=NaN(length(cut_time),length(time));

%%encontramos el numero de las particulas que caen por mes, sacamos las repetidas
%primero creamos el array
iter0=0;
for ij=1:1:length(cut_time)
   leni=length(1:cut_time(ij));    
    for ik=1:1:leni
        iter0=iter0+1;
        sal_part(ij,ik)=sali_p{ij}(ik);
        sst_part(ij,ik)=sst_p{ij}(ik);
        depth_part(ij,ik)=depth_p{ij}(ik);
        lonpis_part(ij,ik)=lonpis_p{ij}(ik);
        latpis_part(ij,ik)=latpis_p{ij}(ik);
        time_part(ij,ik)=timeis{ij}(ik);
        uveli_part(ij,ik)=uveli_p{ij}(ik);
        vveli_part(ij,ik)=vveli_p{ij}(ik);
        wveli_part(ij,ik)=wveli_p{ij}(ik);    
    end
end
%% aqui creamos el t tiempo de llegada a 15mn en formato texto
for dd=1:1:length(cut_time)
    tt=max(time_part(dd,1:cut_time(dd)));
    dp=depth_part(dd,1:cut_time(dd));
    disp([datestr(datenum(tt)),' ', num2str(dp(end))])
    time_part_end(dd)=tt;
    depth_part_end(dd)=dp(end);
    t(dd,:)={datestr(datenum(tt))}; 
end
%% vemos las variables nuevamente de las 10 primeras particulas
%sal filtering
sal_part(sal_part<30)=NaN;
flag=1;
npart=30;

if flag==1
    figure
    P=get(gcf,'position');
    P(3)=P(3)*2;
    P(4)=P(4)*2;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    subplot(2,3,1)
    boxplot(sst_part(1:npart,:)'); title('Temperature');
    subplot(2,3,2)
    boxplot(sal_part(1:npart,:)'); title('Sal');
    subplot(2,3,3)
    boxplot(vveli_part(1:npart,:)'); title('V vel');
    subplot(2,3,4)
    boxplot(uveli_part(1:npart,:)'); title('Uvel');
    subplot(2,3,5)
    boxplot(wveli_part(1:npart,:)'); title('W vel');
    subplot(2,3,6)
    boxplot(depth_part(1:npart,:)'); title('Depth');
end
print(['variables-',fn(16:end-3)],'-dpng','-r500');
clf
%% Tenemos que limpiar los datos, para esto primero veremos el tiempo 
% vamos a verificar los datos de todas las variables

%dep=double(ncread(fn,'depth',[rep_time(1) 1],[1 Inf],[1 1]));
%%plot(lon(V(jj),1),lat(V(jj),1),'b.');
flag=0;
if flag==1
    boxplot(depth_part'); title('Depth');
    hold on
    plot([1:length(cut_time)],depth_part_end,'g'); %depth nursery ground
    hold on
    plot([1:length(cut_time)],depth_part(:,1),'m'); %depth spawning region
end
%% 
% plot(depth_part(36,:),'r','linewidth',1);
% hold on
% plot(depis(36,:),'b');
%% De donde vinieron estas particulas
flag=1;
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for jj=1:1:length(V)
plot(lon(V(jj),1),lat(V(jj),1),'b.');
hold on 
plot(lon(V(jj),rep_time(jj)),lat(V(jj),rep_time(jj)),'r.');
hold on
end
plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)

 borders('countries','k');
 axis square
 axis([-85 -65 -30 0])
legend('Spawning region','Nursery ground');

print(['Particulas-',fn(16:end-3)],'-dpng','-r500');
%% Next steps 
%buscar literatura de huevos, hasta cuantos metros se puede resuspender y/o
%desarrollar el jurel, por ejemplo si caen debajo de los 100m ya no
%sobreviven
%%
%Encontrar cuantas particulas cayeron en cada region en cada mes

%region/Mes   Nov Dic En Feb Mar Abr  
%region 1
%region 2
%region 3
%region 4
close all
%% save
mfile=['datos2-',fn(16:end-3)];
save(mfile,'latpis_part','lonpis_part','sal_part','sst_part','depth_part',...
    'time_part','uveli_part','vveli_part','wveli_part','yr','T2');
