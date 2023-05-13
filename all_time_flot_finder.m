%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Validacion del modelo con Flotadores %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Version 3 todo el tiempo %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%no restricciones de tiempo
%%
clear all; close all; clc;
%%
cd D:\TESIS_INGE\parte_experimental\flotos\float_TESIS;

%% vamos a buscar flotadores que estan en la fecha cuando se sueltan las particulas
%las fechas de inicio son 2007 10 01 
%La idea es buscar todas los flotadores que se encuentran en todo el mes y
%luego presentar cuantos son, en que regiones y en que tiempo estan, asi
%mismo tomar sus valores de temp,sal y depth
%meses no evaluados 01,02,03,04
%date_ini=datenum([2007 10 01]);

path01='D:\TESIS_INGE\parte_experimental\flotos\float_TESIS';

hdir=dir(fullfile(path01,'*.nc'));

%fn='20120101_prof.nc';
disp(['Analizando flotadores del año ',hdir(1).name(1:4)])
for ifloat=1:1:size(hdir,1)
%for ifloat=273:1:500
    fname=hdir(ifloat).name;
    cprintf('*black',['Analizando flotadores del dia\n'])
    cprintf('*black',[fname(1:8),'\n'])
    mes=fname(5:6);
%     if str2num(mes)<10
%         cprintf('err','Fecha fuera del rango master\n');
%         continue
%     else
%         cprintf('_green','OK master\n')
%     end
    %variables
    depth=ncread(fname,'PRES');
    temp=ncread(fname,'TEMP');
    salt=ncread(fname,'PSAL');
    lon=ncread(fname,'LONGITUDE');
    %lon(lon<0)=lon(lon<0)+360;
    lat=ncread(fname,'LATITUDE');
    time=ncread(fname,'JULD');
    [yr,mo,da]=datevec(double(time)+datenum(1950,1,1,0,0,0));
    times=datenum(yr,mo,da);
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
    %% Region 1 % una sola region que englobe todo
% 10ºS a 12ºS / 84ºW a 82ºW
cprintf('*black','Calculando Region Total.....\n')
%range0=[-84.1 -82 -12 -9.9];
range0=[-86 -78 -20.1 -9.9];

indxlat=find(lat>=range0(3) & lat<=range0(4));indxlon=find(lon>=range0(1) & lon<=range0(2));
%check if the lon and lat are the same index for the region
[aa,~]=ismember(indxlon,indxlat); disp(['Nº floats recruited: ' num2str(sum(aa))])

[lon1,lat1,temp1,sal1,depth1,indx_region1,n_flot1,n_cycle1]=region_selection_float(range0(1),...
    range0(2),range0(3),range0(4),lon(:,1),lat(:,1),temp,salt,...
    depth,platform_number,cycle_number0);
time1=times(indx_region1);


flot_region{ifloat,:}=[n_flot1,lon1,lat1,time1];
%flot_values{ifloat,:}={temp1(1:50,:), sal1(1:50,:), depth1(1:50,:)};
temp_all{ifloat}= temp1(1:50,:);
sal_all{ifloat}= sal1(1:50,:);
depth_all{ifloat}= depth1(1:50,:);
end
%% aqui convertimos a matriz 
float_c_region=cell2mat(flot_region); %info flotadores
temp_c_val=cell2mat(temp_all);
sal_c_val=cell2mat(sal_all);
depth_c_val=cell2mat(depth_all);
%% aqui unimos las matrices de cada variable
for ix=1:1:size(temp_c_val,2)
    data_p_mat=cat(2,depth_c_val(:,ix),temp_c_val(:,ix),sal_c_val(:,ix));
    data_mat(:,:,ix)=data_p_mat;
end
%% aqui buscaremos los valores unicos de flotadores

[C,IA,IC]=unique(float_c_region(:,1));

%aqui unimos todos los ciclos con las variables (lon,lat,tiempo)
for k=1:length(C)
    indxfloto=find(C(k)==float_c_region(:,1));
    data_reg1=float_c_region(indxfloto,:);
    
    my_field = strcat('loc_',num2str(C(k)));
    r_flot.(my_field) = data_reg1;
end
%% Ahora todos los ciclos con las variables fisicas temp,sal,depth

for k=1:length(C)
    indxfloto=find(C(k)==float_c_region(:,1));
    data_reg2=data_mat(:,:,indxfloto);
    
    my_field = strcat('fis_',num2str(C(k)));
    r_vflot.(my_field) = data_reg2;
end

%% ahora guardamos
C2=C;
save('Flotos_tesis_fis_2.mat','-struct','r_vflot');
save('Flotos_tesis_locat_2.mat','-struct','r_flot');
save('N_flotos_2.mat','C2');