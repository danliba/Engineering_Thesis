cd F:\simulaciones\prueba2\2007-2008
%% %%%%%%%%%%%%%%%% Particle tracker Pro Version 2.0 %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% recupera menos particulas, aun en reparacion
clear all
close all
clc
folders=[2007:2008];
for ij=1:1:length(folders)-1

path01=sprintf('F:\\simulaciones\\prueba2\\%d-%g',folders(ij),folders(ij+1));
hdir=dir(fullfile(path01,'OffPeruJackMac_20*.nc'));
iter=0;
for ifloat=1:1:size(hdir,1)
    fn=hdir(ifloat).name;
    
%%
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
        date_ini=datenum(yr(1),mop(kk)-1,30); date_end=datenum(yr(1),mop(kk),30,23,59,59);
        disp(datestr(datenum(date_end)))
    elseif kk==2 %dic
        date_ini=datenum(yr(1),mop(kk),1); date_end=datenum(yr(1),mop(kk),31,23,59,59);
        disp(datestr(datenum(date_end)))
    elseif kk==3 || kk==5 || kk==7 || kk==9 %en %marzo %mayo %julio
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),31,23,59,59);
        disp(datestr(datenum(date_end)))
    elseif kk==4 %feb
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),28,23,59,59);
        disp([datestr(datenum(date_end)),' FEB'])      
    else %abril %junio %agosto
        date_ini=datenum(yr(end),mop(kk),1); date_end=datenum(yr(end),mop(kk),30,23,59,59);
        disp([datestr(datenum(date_end)),' mop 2008'])
    end
%nov10=[2007,11,1]; nov31=[2007,11,30];
indxtime=find(time>=datenum(date_ini) & time<=datenum(date_end));

%cuando llegan las partictulas
time_p=time(indxtime);

    if ~isempty(indxtime)<1
        disp('Este mes no cayo ni dios')
        continue
    end
lon2=lon(:,indxtime);
lat2=lat(:,indxtime);
depi2=depth(:,indxtime);
%lon3 y lat3 aqui verificamos cual fue la ultima posicion en el mes especificado con
%indxtime 30 noviembre
%%% poner la condicion de que la particula entre al menos una vez

    for itime=1:1:length(indxtime)
    lon3=lon2(:,itime); 
    lat3=lat2(:,itime);
    time_p2=time_p(itime);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%Encontramos las particulas que cayeron dentro de las 15mn en Nov
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        iter=0;
        for ii=1:1:10^4
        iter=iter+1;
        longi=lon3(ii);
        latit=lat3(ii);

        ff=longi>=lon15mn20S;

        gg=latit>=lat15mn20S;

        hh=ff.*gg; 
        hh=sum(hh,2);

        if hh>0
            disp(['Particula ', 'Nº',num2str(ii),' dia ', datestr(datenum(time_p2))])
            %disp(datestr(datenum(time_p2)))
            x0(iter,1)=true;
            time_trap{iter,:}=[time_p2,ii]; %con este metodo salen mas particulas reclutadas
            %investigar este metodo a fondo
        else
            x0(iter,1)=false;

        end
        end

        indx0=find(x0>0);

        %disp(indx0)
        part_trap{itime,:}=indx0;
    %%creamos cuadro para noviembre los 174 datos que nos dio
    end

%%
time_part_indx=cell2mat(time_trap);
[c1,ia1]=unique(time_part_indx(:,2)); %dates by particle

landing_time=time_part_indx(ia1,1);
particles_landed=c1;
%%
n_particles(kk,:)=length(particles_landed);
mm_yy(kk,:)={datestr(datenum(date_end))}; 
fechas(kk,:)=datenum(date_end);
indx_total{:,kk}=particles_landed;%numero de particula
time_mat{:,kk}=indxtime;
all_time_landings{:,kk}=landing_time;

end
%% tabla
indx_part=NaN(max(n_particles),length(indx_total));

%%encontramos el numero de las particulas que caen por mes, sacamos las repetidas
%primero creamos el array
iter0=0;
for ix=1:1:length(indx_total)
    leni=length(indx_total{ix});    
    for ik=1:1:leni
        iter0=iter0+1;
        indx_part(ik,ix)=indx_total{ix}(ik);
        time_landing_part(ik,ix)=all_time_landings{ix}(ik);
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
disp(sum(particles_recruited))
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
time_nan=NaN(length(indx_part),length(indx_total));
%%encontramos las particulas que caen por mes
iter0=0;
for iz=1:1:length(all_time_landings)
    leni=length(all_time_landings{iz});    
    for ik=1:1:leni
        iter0=iter0+1;
        time_nan(ik,iz)=all_time_landings{iz}(ik);
    end
end

%time_end=max(time_nan);
%rep_time=repelem(time_end,particles_recruited);
arrival_time=~isnan(indx_part2).*time_nan;
arrival_time(arrival_time == 0) = NaN;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% We will check the Time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vv=indx_part2(:);
V=vv(~isnan(vv)); %indices sin nan

vvpart=arrival_time(:);
Vpart=vvpart(~isnan(vvpart));
for itimeis=1:1:length(Vpart)
    indxtime_part(itimeis)=find(time>=Vpart(itimeis) & Vpart(itimeis)>=time);
end
%particulas y su recorrido
%tenemos que encontrar el tiempo en el que cada particula llega por primera
%vez a la costa peruana
if flag==1
    for jj=1:1:70
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,time(1:indxtime_part(jj)));
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
    scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,temp1(1:indxtime_part(jj)));
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
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,sal(1:indxtime_part(jj)));
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
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,uvel(1:indxtime_part(jj)));
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
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,vvel(1:indxtime_part(jj)));
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
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,wvel(1:indxtime_part(jj)));        
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
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,dep(1:indxtime_part(jj)));        
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
%% time
 %We will read the time of the selected particles first
 %cortamos el tiempo 
 flag=0;
for jj=1:1:length(V)
    timep=double(ncread(fn,'times',[1],[indxtime_part(jj)],[1]));

    if jj==1
        disp('reading time')
    end
    timeis{:,jj}=timep;

    if flag==1
        scatter(lon(V(jj),1:indxtime_part(jj)),lat(V(jj),1:indxtime_part(jj)),0.1,timep(1:indxtime_part(jj)));
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
for kk=1:1:length(indxtime_part)
    disp('Cortando las variables en el tiempo')
    sst_p{:,kk}=sst(kk,1:indxtime_part(kk));
    depth_p{:,kk}=depis(kk,1:indxtime_part(kk));
    lonpis_p{:,kk}=lonpis(kk,1:indxtime_part(kk));
    latpis_p{:,kk}=latpis(kk,1:indxtime_part(kk));
    sali_p{:,kk}=sali(kk,1:indxtime_part(kk));
    uveli_p{:,kk}=uveli(kk,1:indxtime_part(kk));
    vveli_p{:,kk}=vveli(kk,1:indxtime_part(kk));
    wveli_p{:,kk}=wveli(kk,1:indxtime_part(kk));
end
%% Ahora pasamos de cell a mat y llenamos con NaN los vacios

sal_part=NaN(length(indxtime_part),length(time));
sst_part=NaN(length(indxtime_part),length(time));
depth_part=NaN(length(indxtime_part),length(time));
lonpis_part=NaN(length(indxtime_part),length(time));
latpis_part=NaN(length(indxtime_part),length(time));
time_part=NaN(length(indxtime_part),length(time));
uveli_part=NaN(length(indxtime_part),length(time));
vveli_part=NaN(length(indxtime_part),length(time));
wveli_part=NaN(length(indxtime_part),length(time));

%%encontramos el numero de las particulas que caen por mes, sacamos las repetidas
%primero creamos el array
iter0=0;
for ih=1:1:length(indxtime_part)
   leni=length(1:indxtime_part(ih));    
    for ik=1:1:leni
        iter0=iter0+1;
        sal_part(ih,ik)=sali_p{ih}(ik);
        sst_part(ih,ik)=sst_p{ih}(ik);
        depth_part(ih,ik)=depth_p{ih}(ik);
        lonpis_part(ih,ik)=lonpis_p{ih}(ik);
        latpis_part(ih,ik)=latpis_p{ih}(ik);
        time_part(ih,ik)=timeis{ih}(ik);
        uveli_part(ih,ik)=uveli_p{ih}(ik);
        vveli_part(ih,ik)=vveli_p{ih}(ik);
        wveli_part(ih,ik)=wveli_p{ih}(ik);    
    end
end
%% aqui creamos el t tiempo de llegada a 15mn en formato texto
for dd=1:1:length(indxtime_part)
    tt=max(time_part(dd,1:indxtime_part(dd)));
    dp=depth_part(dd,1:indxtime_part(dd));
    disp([datestr(datenum(tt)),' ', num2str(dp(end))])
    time_part_end(dd)=tt;
    depth_part_end(dd)=dp(end);
    t(dd,:)={datestr(datenum(tt))}; 
end
%% vemos las variables nuevamente de las 10 primeras particulas
%sal filtering
sal_part(sal_part<30)=NaN;
disp('Filtramos la sal <30ups')
flag=1;

if ~isempty(particles_recruited)==0
    flag=0;
end

if sum(particles_recruited)<10
    npart=sum(particles_recruited);
else
    npart=10;
end

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

print([path01,'variables2-',fn(16:end-3)],'-dpng','-r500');
clf
%% Tenemos que limpiar los datos, para esto primero veremos el tiempo 
% vamos a verificar los datos de todas las variables
flag=0;
if flag==1
    boxplot(depth_part'); title('Depth');
    hold on
    plot([1:length(indxtime_part)],depth_part_end,'g'); %depth nursery ground
    hold on
    plot([1:length(indxtime_part)],depth_part(:,1),'m'); %depth spawning region
end
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
plot(lon(V(jj),indxtime_part(jj)),lat(V(jj),indxtime_part(jj)),'r.');
hold on
end
plot(lon15mn20S,lat15mn20S,'k','linestyle','--','linewidth',1)

 borders('countries','k');
 axis square
 axis([-85 -65 -30 0])
legend('Spawning region','Nursery ground');

print([path01,'\Particulas2-',fn(16:end-3)],'-dpng','-r500');
close all
%% save
newfile=[path01,'\procesado'];
mkdir(newfile);
mfile=[newfile '\datos3-',fn(16:end-3)];
save(mfile,'V','latpis_part','lonpis_part','sal_part','sst_part','depth_part',...
    'time_part','uveli_part','vveli_part','wveli_part','yr','T2','T',...
    'indxtime_part','t','time_nan','indx_part','indx_part2','arrival_time');

 close all; clc; 
 clearvars -except hdir folders path01 ifloat fn
end
end