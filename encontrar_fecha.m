%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Validacion del modelo con Flotadores %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd D:\TESIS_INGE\parte_experimental\flotos\float_TESIS;

%% vamos a buscar flotadores que estan en la fecha cuando se sueltan las particulas
%las fechas de inicio son 2007 10 01 
%meses no evaluados 01,02,03,04
%date_ini=datenum([2007 10 01]);

path01='D:\TESIS_INGE\parte_experimental\flotos\float_TESIS';

hdir=dir(fullfile(path01,'*.nc'));

%fn='20120101_prof.nc';
disp(['Analizando flotadores del año ',hdir(1).name(1:4)])
for ifloat=1:1:size(hdir,1)
    fname=hdir(ifloat).name;
    cprintf('*black',['Analizando flotadores del dia\n'])
    cprintf('*black',[fname(1:8),'\n'])
    mes=fname(5:6);
    if str2num(mes)<10
        cprintf('err','Fecha fuera del rango master\n');
        continue
    else
        cprintf('_green','OK master\n')
    end
    %variables
    depth=ncread(fname,'PRES');
    temp=ncread(fname,'TEMP');
    salt=ncread(fname,'PSAL');
    lon=ncread(fname,'LONGITUDE');
    %lon(lon<0)=lon(lon<0)+360;
    lat=ncread(fname,'LATITUDE');
    time=ncread(fname,'JULD');
    %days since 1950-01-01 00:00:00
    Nfloat=ncread(fname,'PLATFORM_NUMBER');
    
       %numero de flotador
        for P_Num=1:1:size(Nfloat,2)
        floto=Nfloat(:,P_Num);
        numflot=floto';
        numflot=str2num(numflot);
        platform_number(P_Num,:)=numflot;
        end
        
    cycle_number0=ncread(fname,'CYCLE_NUMBER');
    
    %encontramos los flotadores en las regiones
    %% Region 1
% 10ºS a 12ºS / 84ºW a 82ºW
cprintf('*black','Calculando Region 1.....\n')
range0=[-84.1 -82 -12 -9.9];
%range0=[-86 -82 -16 -4];

indxlat=find(lat>=range0(3) & lat<=range0(4));indxlon=find(lon>=range0(1) & lon<=range0(2));
%check if the lon and lat are the same index for the region
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon1,lat1,temp1,sal1,depth1,indx_region1,n_flot1,n_cycle1]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);

%% Region 2
% 10ºS a 12ºS / 82ºW a 80ºW
cprintf('*black','Calculando Region 2.....\n')

range0=[-82 -80 -12 -9.9];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon2,lat2,temp2,sal2,depth2,indx_region2,n_flot2,n_cycle2]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% Region 3
% 10ºS a 12ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 3.....\n')
range0=[-80 -77.9 -12 -9.9];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon3,lat3,temp3,sal3,depth3,indx_region3,n_flot3,n_cycle3]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% Region 4
%12ºS a 14ºS / 84ºW a 82ºW
cprintf('*black','Calculando Region 4.....\n')
range0=[-84.1 -82 -14 -12];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon4,lat4,temp4,sal4,depth4,indx_region4,n_flot4,n_cycle4]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 5
%12ºS a 14ºS / 82ºW a 80ºW
cprintf('*black','Calculando Region 5.....\n')
range0=[-82 -80 -14 -12];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon5,lat5,temp5,sal5,depth5,indx_region5,n_flot5,n_cycle5]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 6
%12ºS a 14ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 6.....\n')
range0=[-80 -77.9 -14 -12];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])


[lon6,lat6,temp6,sal6,depth6,indx_region6,n_flot6,n_cycle6]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 7
%14ºS a 16ºS / 84ºW a 82ºW
cprintf('*black','Calculando Region 7.....\n')
range0=[-84.1 -82 -16 -14];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon7,lat7,temp7,sal7,depth7,indx_region7,n_flot7,n_cycle7]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 8
%14ºS a 16ºS / 82ºW a 80ºW
cprintf('*black','Calculando Region 8.....\n')
range0=[-82 -80 -16 -14];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon8,lat8,temp8,sal8,depth8,indx_region8,n_flot8,n_cycle8]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 9
%14ºS a 16ºS / 82ºW a 80ºW
cprintf('*black','Calculando Region 9.....\n')
range0=[-80 -77.9 -16 -14];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon9,lat9,temp9,sal9,depth9,indx_region9,n_flot9,n_cycle9]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region10
%16ºS a 18ºS / 84ºW a 82ºW
cprintf('*black','Calculando Region 10.....\n')
range0=[-84.1 -82 -18 -16];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon10,lat10,temp10,sal10,depth10,indx_region10,n_flot10,n_cycle10]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 11
%16ºS a 18ºS / 82ºW a 80ºW
cprintf('*black','Calculando Region 11.....\n')
range0=[-82 -80 -18 -16];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon11,lat11,temp11,sal11,depth11,indx_region11,n_flot11,n_cycle11]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);

%% region 12
%16ºS a 18ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 12.....\n')
range0=[-80 -77.9 -18 -16];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon12,lat12,temp12,sal12,depth12,indx_region12,n_flot12,n_cycle12]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 13
%16ºS a 18ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 13.....\n')
range0=[-84.1 -82 -20.1 -18];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon13,lat13,temp13,sal13,depth13,indx_region13,n_flot13,n_cycle13]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 14
%16ºS a 18ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 14.....\n')
range0=[-82 -80 -20.1 -18];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(['Nº particles recruited: ' num2str(sum(aa))])

[lon14,lat14,temp14,sal14,depth14,indx_region14,n_flot14,n_cycle14]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
%% region 15
%16ºS a 18ºS / 80ºW a 78ºW
cprintf('*black','Calculando Region 15.....\n')
range0=[-80 -77.9 -20.1 -18];

indxlat=find(lat(:,1)>=range0(3) & lat(:,1)<=range0(4));indxlon=find(lon(:,1)>=range0(1) & lon(:,1)<=range0(2));
[aa,~]=ismember(indxlon,indxlat); disp(sum(aa))

[lon15,lat15,temp15,sal15,depth15,indx_region15,n_flot15,n_cycle15]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);

% newfile=[path01,'\procesado'];
% mkdir(newfile);
% mfile=[newfile '\floto-',fname(16:end-3)];
% save(mfile,

end
clear all 